//
//  BetterListVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/5.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "BetterListVC.h"
#import "MusicDetailVC.h"

#import "QualityCell.h"

@interface BetterListVC ()

@end

@implementation BetterListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐精品";
    self.tableView.height = screen_height - TAB_BAR_HEIGHT - self.navigationBarView.bottom;
    
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type" : @"2"}];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Featured/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:[AppBasicMusicDetailInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
        }
        [weakself updateSubviews];
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
    static NSString *CellIdentifier = @"select_cell";
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
    
    [[AppPublic getInstance] goToMusicVC:self.dataSource[indexPath.row] list:nil type:PublicMusicDetailFromBetter];
}

@end
