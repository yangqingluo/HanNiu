//
//  AccountViewController.m
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AccountViewController.h"
#import "LoginViewController.h"

#import "PublicTableViewCell.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self initializeData];
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"我的购买",@"subTitle":@"",@"key":@"icon_me_bought"},
                       @{@"title":@"我的M币",@"subTitle":@"充值",@"key":@"icon_me_coin"},
                       @{@"title":@"意见反馈",@"subTitle":@"",@"key":@"icon_me_suggestion"},
                       @{@"title":@"设置",@"subTitle":@"",@"key":@"icon_me_setting"},
                       @{@"title":@"关于我们",@"subTitle":@"",@"key":@"icon_me_about_us"}];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? kCellHeightBig: kCellHeightFilter;
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
            cell.titleLabel.frame = CGRectMake(cell.showImageView.right + kEdgeHuge, 0, screen_width - (cell.showImageView.right + kEdgeHuge) - kEdgeHuge, c_height);
            cell.showImageView.image = [UIImage imageNamed:defaultDownloadPlaceImageName];
            
            cell.titleLabel.numberOfLines = 0;
        }
        if ([UserPublic getInstance].userData) {
            cell.titleLabel.text = @"";
        }
        else {
            cell.titleLabel.text = @"点击登录";
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
            
        }
        else {
            LoginViewController *vc = [LoginViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self doPushViewController:vc animated:YES];
        }
    }
    else {
        switch (indexPath.row) {
            case 0: {
                
            }
                break;
                
            default:
                break;
        }
    }
}

@end
