//
//  BetterVC.m
//  HanNiu
//
//  Created by 7kers on 2018/3/21.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "BetterVC.h"

#import "QualityCell.h"

@interface BetterVC ()

@end

@implementation BetterVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.needRefresh) {
        [self.dataSource removeAllObjects];
        [self updateSubviews];
        [self beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRefreshNotification:) name:kNotifi_Login_StateRefresh object:nil];
    [self updateTableViewHeader];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{}];
    //    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Quality/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself.dataSource removeAllObjects];
            [weakself.dataSource addObjectsFromArray:[AppBasicMusicDetailInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
            [weakself updateSubviews];
        }
    }];
}

- (void)doGetMusicDetailFunction:(NSIndexPath *)indexPath {
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    NSString *urlFooter = @"Quality/List";
    
    AppBasicMusicDetailInfo *item = self.dataSource[indexPath.row];
    if (item.Institute) {
        [m_dic setObject:item.Institute.Id forKey:@"schoolId"];
    }
    else if (item.University) {
        [m_dic setObject:item.University.Id forKey:@"universityId"];
    }
    else if (item.College) {
        [m_dic setObject:item.College.Id forKey:@"universityId"];
    }
    
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:urlFooter completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            NSArray *m_array = [AppBasicMusicDetailInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]];
            [[AppPublic getInstance] goToMusicVC:item list:m_array type:PublicMusicDetailFromBetter];
        }
    }];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [QualityCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    QualityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[QualityCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.data = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self doGetMusicDetailFunction:indexPath];
}

@end
