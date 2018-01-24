//
//  AccountDetailVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/22.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AccountDetailVC.h"

#import "PublicTableViewCell.h"
#import "UIButton+WebCache.h"

@interface AccountDetailVC ()

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIButton *headerBtn;

@property (strong, nonatomic) AppUserInfo *userData;

@end

@implementation AccountDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    self.tableView.tableHeaderView = self.headerView;
    [self initializeData];
    [self updateSubviews];
//    [self pullBaseListData:YES];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"username" : [UserPublic getInstance].userData.Extra.userinfo.Name}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"UserInfo" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself updateSubviews];
        }
    }];
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"昵称",@"subTitle":@"请输入",@"key":@"NickName"}];
}

- (void)updateSubviews {
    [self.headerBtn sd_setImageWithURL:fileURLWithPID(self.userData.Image) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:defaultHeadPlaceImageName]];
    [self.tableView reloadData];
}

#pragma mark - getter
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeightHuge)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        CGFloat radius = 0.8 * _headerView.height;
        _headerBtn = NewButton(CGRectMake(0, 0, radius, radius), nil, nil, nil);
        _headerBtn.center = CGPointMake(0.5 * _headerView.width, 0.5 * _headerView.height);
        [_headerBtn setBackgroundImage:[UIImage imageNamed:defaultHeadPlaceImageName] forState:UIControlStateNormal];
        [_headerView addSubview:_headerBtn];
        [AppPublic roundCornerRadius:_headerBtn];
    }
    return _headerView;
}

- (AppUserInfo *)userData {
    if (!_userData) {
        _userData = [[UserPublic getInstance].userData.Extra.userinfo copy];
    }
    return _userData;
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
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [AppPublic appFontOfSize:appLabelFontSize];
        cell.detailTextLabel.textColor = appTextColor;
        cell.detailTextLabel.font = cell.textLabel.font;
    }
    NSDictionary *dic = self.showArray[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.detailTextLabel.text = [[UserPublic getInstance].userData.Extra.userinfo valueForKey:dic[@"key"]];
    
    return cell;
}

@end
