//
//  AccountSettingsVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/17.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AccountSettingsVC.h"
#import "ChangePasswordVC.h"

#import "PublicTableViewCell.h"

@interface AccountSettingsVC ()

@property (strong, nonatomic) UIView *footerView;

@end

@implementation AccountSettingsVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateRefreshNotification:) name:kNotifi_Login_StateRefresh object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self initializeData];
}

//初始化数据
- (void)initializeData {
    NSMutableArray *m_array = [NSMutableArray arrayWithArray:@[@{@"title":@"2G/3G/4G下播放",@"subTitle":@"",@"key":@""},
    @{@"title":@"打开应用后自动播放",@"subTitle":@"充值",@"key":@""},
    @{@"title":@"检查更新",@"subTitle":@"",@"key":@""},
    @{@"title":@"修改密码",@"subTitle":@"",@"key":@""}]];
    if (![UserPublic getInstance].userData) {
        [m_array removeLastObject];
    }
    self.showArray = [NSArray arrayWithArray:m_array];
    self.tableView.tableFooterView = [UserPublic getInstance].userData ? self.footerView : nil;
    [self.tableView reloadData];
}

- (void)logoutButtonAction {
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定退出登录？" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakself doLogoutFunction];
        }
    } otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)doLogoutFunction {
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Delete:nil HeadParm:nil URLFooter:@"Token" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (!error) {
            [[AppPublic getInstance] logout];
        }
        else {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

#pragma mark - getter
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 120)];
        
        UIButton *logoutBtn = NewButton(CGRectMake(kEdgeToScreen, 0, _footerView.width - 2 * kEdgeToScreen, 44), @"退出登录", [UIColor whiteColor], nil);
        logoutBtn.bottom = _footerView.height;
        [logoutBtn setBackgroundImage:[UIImage imageNamed:@"back_dialog_confirm_btn"] forState:UIControlStateNormal];
        [logoutBtn setBackgroundImage:[UIImage imageNamed:@"back_dialog_confirm_btn"] forState:UIControlStateHighlighted];
        [_footerView addSubview:logoutBtn];
        [logoutBtn addTarget:self action:@selector(logoutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeightMiddle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"select_cell";
    PublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PublicTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [AppPublic appFontOfSize:appLabelFontSize];
        cell.detailTextLabel.font = cell.textLabel.font;
    }
    NSDictionary *dic = self.showArray[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == self.showArray.count - 1) {
        ChangePasswordVC *vc = [ChangePasswordVC new];
        [self doPushViewController:vc animated:YES];
    }
}

#pragma mark - notification
- (void)loginStateRefreshNotification:(NSNotification *)notification {
    [self initializeData];
}

@end
