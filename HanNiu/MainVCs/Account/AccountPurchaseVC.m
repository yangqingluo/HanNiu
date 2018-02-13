//
//  AccountPurchaseVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/22.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AccountPurchaseVC.h"

#import "MusicCell.h"

@interface AccountPurchaseVC ()

@end

@implementation AccountPurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的购买";
    self.tableView.height = screen_height - TAB_BAR_HEIGHT - self.navigationBarView.bottom;
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{}];
    //    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Music/Buy" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself.dataSource removeAllObjects];
            [weakself.dataSource addObjectsFromArray:[AppMusicInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
             [weakself updateSubviews];
        }
    }];
}

- (void)doGetMusicDetailFunction:(NSIndexPath *)indexPath {
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    NSString *urlFooter = nil;
    
    AppMusicInfo *music = self.dataSource[indexPath.row];
    NSString *key = music.showItemKey;
    AppItemInfo *item = music.showItem;
    [m_dic setObject:item.Id forKey:@"id"];
    if ([key isEqualToString:musicKeyUniversitys]) {
        urlFooter = @"University/Detail";
    }
    else if ([key isEqualToString:musicKeySchools]) {
        urlFooter = @"University/School/Detail";
    }
    else if ([key isEqualToString:musicKeyMajors]) {
        urlFooter = @"University/Major/Detail";
    }
    else if ([key isEqualToString:musicKeyQualities]) {
        urlFooter = @"Quality/Detail";
    }
    
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:urlFooter completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            AppBasicMusicDetailInfo *college = [AppBasicMusicDetailInfo mj_objectWithKeyValues:responseBody[@"Data"]];
            college.Music = self.dataSource[indexPath.row];
            [weakself goToMusicVC:college fromIndexPath:indexPath];
        }
    }];
}

- (void)goToMusicVC:(AppBasicMusicDetailInfo *)data fromIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        if (i == indexPath.row) {
            [m_array addObject:data];
        }
        else {
            AppMusicInfo *music = self.dataSource[i];
            AppBasicMusicDetailInfo *m_data = [AppBasicMusicDetailInfo mj_objectWithKeyValues:music.showItem.mj_keyValues];
            m_data.Music = music;
            [m_array addObject:m_data];
        }
    }
    [[AppPublic getInstance] goToMusicVC:data list:m_array type:PublicMusicDetailDefault];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MusicCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"select_cell";
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MusicCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.music = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self doGetMusicDetailFunction:indexPath];
}

@end
