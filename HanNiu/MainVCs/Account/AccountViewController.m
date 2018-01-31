//
//  AccountViewController.m
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountDetailVC.h"
#import "AccountFavoriteVC.h"
#import "AccountPurchaseVC.h"
#import "AccountCoinVC.h"
#import "AccountSuggestVC.h"
#import "AccountSettingsVC.h"
#import "AccountAboutVC.h"

#import "PublicTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRefreshNotification:) name:kNotifi_Login_StateRefresh object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.needRefresh) {
        [self beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    self.tableView.height = screen_height - TAB_BAR_HEIGHT - self.navigationBarView.height;
    [self initializeData];
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"我的收藏",@"subTitle":@"",@"key":@"icon_me_suggestion"},
                      @{@"title":@"我的购买",@"subTitle":@"",@"key":@"icon_me_bought"},
                       @{@"title":@"我的M币",@"subTitle":@"充值",@"key":@"icon_me_coin"},
                       @{@"title":@"意见反馈",@"subTitle":@"",@"key":@"icon_me_suggestion"},
                       @{@"title":@"设置",@"subTitle":@"",@"key":@"icon_me_setting"},
                       @{@"title":@"关于我们",@"subTitle":@"",@"key":@"icon_me_about_us"}];
}

- (void)beginRefreshing {
    self.needRefresh = NO;
    self.isResetCondition = NO;
    [self.tableView reloadData];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? kCellHeightBig: kCellHeightMiddle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"head_cell";
        PublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[PublicTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            CGFloat c_height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            CGFloat i_radius = c_height - 2 * kEdgeMiddle;
            cell.showImageView.frame = CGRectMake(kEdgeHuge, kEdgeMiddle, i_radius, i_radius);
            [AppPublic roundCornerRadius:cell.showImageView];
            cell.titleLabel.frame = CGRectMake(cell.showImageView.right + kEdgeHuge, 0, screen_width - (cell.showImageView.right + kEdgeHuge) - kEdgeHuge, c_height);
            cell.titleLabel.numberOfLines = 0;
        }
        if ([UserPublic getInstance].userData) {
            cell.titleLabel.text = [UserPublic getInstance].userData.Extra.userinfo.NickName;
            [cell.showImageView sd_setImageWithURL:fileURLWithPID([UserPublic getInstance].userData.Extra.userinfo.Image) placeholderImage:[UIImage imageNamed:defaultHeadPlaceImageName]];
        }
        else {
            cell.titleLabel.text = @"点击登录";
            cell.showImageView.image = [UIImage imageNamed:defaultHeadPlaceImageName];
        }
        
        return cell;
    }
    static NSString *CellIdentifier = @"select_cell";
    PublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PublicTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [AppPublic appFontOfSize:appLabelFontSize];
        cell.detailTextLabel.font = cell.textLabel.font;
    }
    NSDictionary *dic = self.showArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dic[@"key"]];
    cell.textLabel.text = dic[@"title"];
    cell.detailTextLabel.text = dic[@"subTitle"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if ([UserPublic getInstance].userData) {
            AccountDetailVC *vc = [AccountDetailVC new];
            [self doPushViewController:vc animated:YES];
        }
        else {
             [[AppPublic getInstance] goToLoginCompletion:nil];
        }
    }
    else {
        if (indexPath.row <= 3) {
            if (![UserPublic getInstance].userData) {
                [[AppPublic getInstance] goToLoginCompletion:nil];
                return;
            }
        }
        NSDictionary *m_dic = self.showArray[indexPath.row];
        PublicViewController *vc = nil;
        switch (indexPath.row) {
            case 0:{
                vc = [AccountFavoriteVC new];
            }
                break;
                
            case 1:{
                vc = [AccountPurchaseVC new];
            }
                break;
                
            case 2:{
                vc = [AccountCoinVC new];
            }
                break;
                
            case 3:{
                vc = [AccountSuggestVC new];
            }
                break;
                
            case 4: {
                vc = [AccountSettingsVC new];
            }
                break;
                
            case 5: {
                vc = [AccountAboutVC new];
            }
                break;
                
            default:
                break;
        }
        if (vc) {
            [self doPushViewController:vc animated:YES];
        }
        else {
            [self doShowHintFunction:[NSString stringWithFormat:@"%@ 敬请期待", m_dic[@"title"]]];
        }
    }
}

@end
