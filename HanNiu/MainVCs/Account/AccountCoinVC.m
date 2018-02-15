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

@interface AccountCoinVC ()

@property (strong, nonatomic) NSArray *payArray;

@end

@implementation AccountCoinVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值M币";
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"支付宝",@"subTitle":@"",@"key":@"icon_pay_by_zfb"},
                       @{@"title":@"微信支付",@"subTitle":@"",@"key":@"icon_pay_by_wx"},
                      ];
    self.payArray = @[@{@"title":@"200个M币", @"subTitle":@"", @"amount" : @0.02},
                      @{@"title":@"400个M币", @"subTitle":@"", @"amount" : @0.04},
                      @{@"title":@"600个M币", @"subTitle":@"", @"amount" : @0.06},
                      @{@"title":@"1000个M币", @"subTitle":@"", @"amount" : @0.1},
                      @{@"title":@"2000个M币", @"subTitle":@"", @"amount" : @0.2},
                      @{@"title":@"500个M币", @"subTitle":@"", @"amount" : @0.5},
                      ];
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
    return kCellHeightBig;
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
        }
        return cell;
    }
    static NSString *CellIdentifier = @"type_cell";
    PublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PublicTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [AppPublic appFontOfSize:appLabelFontSize];
        cell.detailTextLabel.font = cell.textLabel.font;
    }
    NSDictionary *dic = self.showArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dic[@"key"]];
    cell.textLabel.text = dic[@"title"];
    cell.detailTextLabel.text = dic[@"subTitle"];
    
    return cell;
}

@end
