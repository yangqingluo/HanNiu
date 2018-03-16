//
//  AccountCoinVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/22.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AccountCoinVC.h"

#import "PublicCollectionHeaderTitleView.h"
#import "PublicTableViewCell.h"
#import "PayAmountCell.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"
#import "AppPurchases.h"

@interface AccountCoinVC (){
    NSInteger payAmountIndex;
    NSInteger payStyleIndex;
}

@property (strong, nonatomic) NSArray *payAmountArray;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIView *footerView;

@end

@implementation AccountCoinVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayResultNotification:) name:kNotifi_Pay_Alipay object:nil];
        self.hidesBottomBarWhenPushed = YES;
        payAmountIndex = -1;
        payStyleIndex = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值M币";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.bottomView];
    self.tableView.height = self.bottomView.top - self.navigationBarView.bottom;
    self.tableView.tableFooterView = self.footerView;
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"支付宝",@"subTitle":@"",@"key":@"icon_pay_by_zfb"},
                       @{@"title":@"微信支付",@"subTitle":@"",@"key":@"icon_pay_by_wx"},
                      ];
    self.payAmountArray = @[@{@"title":@"6个M币", @"subTitle":@"", @"amount" : @"6"},
                      @{@"title":@"18个M币", @"subTitle":@"", @"amount" : @"18"},
                      @{@"title":@"50个M币", @"subTitle":@"", @"amount" : @"50"},
                      @{@"title":@"118个M币", @"subTitle":@"", @"amount" : @"118"},
                      @{@"title":@"158个M币", @"subTitle":@"", @"amount" : @"158"},
                      @{@"title":@"218个M币", @"subTitle":@"", @"amount" : @"218"},
                      ];
}

- (void)doGetUserDataFunction {
//    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:nil HeadParm:nil URLFooter:@"UserInfo" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [UserPublic getInstance].userData.Extra.userinfo = [AppUserInfo mj_objectWithKeyValues:responseBody[@"Data"]];
            [[UserPublic getInstance] saveUserData:nil];
            [weakself updateSubviews];
            if (weakself.doneBlock) {
                [weakself goBackWithDone:YES];
            }
        }
    }];
}

- (void)doGetPayDataFunction {
    NSDictionary *amountDic = self.payAmountArray[payAmountIndex];
    
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    [m_dic setObject:amountDic[@"amount"] forKey:@"Amount"];
    [m_dic setObject:@"0" forKey:@"Item"];
    [m_dic setObject:[NSString stringWithFormat:@"%d", (int)payStyleIndex + 1] forKey:@"Channel"];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Post:m_dic HeadParm:nil URLFooter:@"Pay/Simple" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            if (payStyleIndex == 0) {
                NSDictionary *m_data = responseBody[@"Data"];
                [weakself doAliPayFunction:m_data[@"Data"]];
            }
            else if (payStyleIndex == 1) {
                NSDictionary *m_data = responseBody[@"Data"];
                NSDictionary *info = [m_data[@"Data"] mj_JSONObject];
                if (info.count) {
                    PayReq *req = [PayReq new];
                    req.partnerId = info[@"partnerid"];
                    req.prepayId = info[@"prepayid"];
                    req.nonceStr = info[@"noncestr"];
                    req.timeStamp = [info[@"timestamp"] intValue];
                    req.package = info[@"package"];
                    req.sign = info[@"sign"];
                    [weakself doWXPayFunction:req];
                }
                else {
                    [weakself doShowHintFunction:@"数据异常"];
                }
            }
            else {
                [weakself doShowHintFunction:@"该支付方式敬请期待"];
            }
        }
    }];
}

- (void)doAliPayFunction:(NSString *)orderString {
    NSString *appScheme = @"com.zdz.HanNiu";
    [self doShowHudFunction];
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
    }];
}

- (void)doWXPayFunction:(PayReq *)prepay {
    [WXApi sendReq:prepay];
}

- (void)amountButtonAction:(UIButton *)button {
    payAmountIndex = button.tag;
    [self updateSubviews];
}

- (void)payButtonAction {
    if (payAmountIndex < 0) {
        [self doShowHintFunction:@"请选择充值金额"];
        return;
    }
    else if (payStyleIndex < 0) {
        [self doShowHintFunction:@"请选择充值方式"];
        return;
    }
    [self doGetPayDataFunction];
//    if ([[AppPurchases getInstance] canMakePayments]) {
//        [[AppPurchases getInstance] requestProductData:[NSString stringWithFormat:@"com.zdz.HanNiu_%02d", (int)payAmountIndex + 1]];
//    }
//    else {
//        [self doShowHintFunction:@"不支持购买"];
//    }
    
}

#pragma mark - getter
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height - 60, screen_width, 60)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIButton *payBtn = NewButton(CGRectMake(kEdgeMiddle, 0, _bottomView.width - 2 * kEdgeMiddle, 44), @"立即支付", [UIColor whiteColor], nil);
        payBtn.centerY = 0.5 * _bottomView.height;
        [payBtn setBackgroundImage:[UIImage imageNamed:@"back_pay"] forState:UIControlStateNormal];
        [payBtn setBackgroundImage:[UIImage imageNamed:@"back_pay"] forState:UIControlStateHighlighted];
        [_bottomView addSubview:payBtn];
        [payBtn addTarget:self action:@selector(payButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomView addSubview:NewSeparatorLine(CGRectMake(0, 0, _bottomView.width, appSeparaterLineSize))];
    }
    return _bottomView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 120)];
        UILabel *noticeLabel = NewLabel(CGRectMake(kEdgeMiddle, kEdgeSmall, _footerView.width - 2 * kEdgeMiddle, 100), [UIColor grayColor], [AppPublic appFontOfSize:appLabelFontSizeLittle], NSTextAlignmentLeft);
        noticeLabel.text = @"充值说明：\n1.M币充值成功后无法退款，不可提现。\n2.如遇到无法充值、充值失败等问题，请关注汗牛微信公众号，我们会及时为您解决问题。\n3.根据苹果公司规定，安卓平台内充值的M币与苹果设备充值的M币不能相互通用。";
        noticeLabel.numberOfLines = 0;
        [_footerView addSubview:noticeLabel];
    }
    return _footerView;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 2 ? self.showArray.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return [PayAmountCell tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if (indexPath.section == 2) {
        return [PayStyleCell tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return kCellHeightMiddle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return kCellHeight;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        PublicCollectionHeaderTitleView *m_view = [[PublicCollectionHeaderTitleView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeight)];
        m_view.titleLabel.text = @"";
        if (section == 1) {
            m_view.titleLabel.text = @"选择充值金额";
        }
        else if (section == 2) {
            m_view.titleLabel.text = @"选择充值方式";
        }
        m_view.subTitleLabel.text = @"";
        m_view.rightImageView.hidden = YES;
        [m_view addSubview:NewSeparatorLine(CGRectMake(0, 0, m_view.width, appSeparaterLineSize))];
        return m_view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"head_cell";
        PublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[PublicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.font = [AppPublic appFontOfSize:appLabelFontSize];
            cell.titleLabel.text = @"余额";
            cell.titleLabel.frame = CGRectMake(kEdgeMiddle, 0, 0, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
            [AppPublic adjustLabelWidth:cell.titleLabel];
            cell.subTitleLabel = NewLabel(CGRectMake(cell.titleLabel.right + kEdgeMiddle, cell.titleLabel.top, screen_width - (cell.titleLabel.right + kEdgeMiddle), cell.titleLabel.height), appMainColor, [AppPublic appFontOfSize:appLabelFontSize], NSTextAlignmentLeft);
            [cell.contentView addSubview:cell.subTitleLabel];
        }
        cell.subTitleLabel.text = [NSString stringWithFormat:@"%d", [UserPublic getInstance].userData.Extra.userinfo.Coin];
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"amount_cell";
        PayAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[PayAmountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            for (NSInteger i = 0; i < self.payAmountArray.count; i++) {
                NSDictionary *m_dic = self.payAmountArray[i];
                PublicSelectButton *btn = cell.buttonArray[i];
                btn.showLabel.text = m_dic[@"title"];
                btn.subTitleLabel.text = [NSString stringWithFormat:@"¥%@", m_dic[@"amount"]];
                [btn addTarget:self action:@selector(amountButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        for (NSInteger i = 0; i < self.payAmountArray.count; i++) {
            PublicSelectButton *btn = cell.buttonArray[i];
            BOOL selected = (i == payAmountIndex);
            btn.showImageView.hidden =!selected;
            btn.layer.borderColor = (selected ? appMainColor :appSeparatorColor).CGColor;
        }
        return cell;
    }
    static NSString *CellIdentifier = @"type_cell";
    PayStyleCell*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PayStyleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [AppPublic appFontOfSize:appLabelFontSize];
        cell.detailTextLabel.font = cell.textLabel.font;
    }
    NSDictionary *dic = self.showArray[indexPath.row];
    cell.showImageView.image = [UIImage imageNamed:dic[@"key"]];
    cell.titleLabel.text = dic[@"title"];
    cell.tagImageView.highlighted = (payStyleIndex == indexPath.row);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    payStyleIndex = indexPath.row;
    [self updateSubviews];
}

#pragma mark - notification
- (void)alipayResultNotification:(NSNotification *)notification {
    NSDictionary *resultDic =notification.object;
    [self doHideHudFunction];
    if (resultDic[@"memo"]) {
        NSString *memo = [NSString stringWithFormat:@"%@",resultDic[@"memo"]];
        if (memo.length) {
            NSLog(@"支付结果:%@",memo);
        }
    }
    //            9000     订单支付成功
    //            8000     正在处理中
    //            4000     订单支付失败
    //            6001     用户中途取消
    //            6002     网络连接出错
    if ([resultDic[@"resultStatus"] intValue] == 9000) {
        [self doShowHintFunction:@"充值完成"];
        [self doGetUserDataFunction];
    }
}

@end
