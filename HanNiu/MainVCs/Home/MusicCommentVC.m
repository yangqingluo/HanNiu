//
//  MusicCommentVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/25.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "MusicCommentVC.h"

#import "PublicImageTagTitleCell.h"

@interface MusicCommentVC ()

@end

@implementation MusicCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所有评论";
    
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"musicId" : self.data.Id}];
    //    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Music/Comment/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:[AppCommentInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
        }
        [weakself updateSubviews];
    }];
}

- (void)doCommentLikeFunction:(NSInteger)row {
    if (row > self.dataSource.count - 1) {
        return;
    }
    AppCommentInfo *item = self.dataSource[row];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"id" : item.Id, @"like" : stringWithBoolValue(!item.HasMakeGood)}];
    //    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Post:nil HeadParm:nil URLFooter:[NSString stringWithFormat:@"Music/Comment/Like?id=%@&like=%@", m_dic[@"id"], m_dic[@"like"]] completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            item.HasMakeGood = !item.HasMakeGood;
            if (item.HasMakeGood) {
                item.LikeCount++;
            }
            else {
                item.LikeCount--;
            }
            [weakself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)likeButtonAction:(UIButton *)button {
    [self doCommentLikeFunction:button.tag];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppCommentInfo *item = self.dataSource[indexPath.row];
    return [MusicCommentCell tableView:tableView heightForRowAtIndexPath:indexPath andSubTitle:item.showStringForContent];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    MusicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MusicCommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.likeBtn addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.data = self.dataSource[indexPath.row];
    cell.likeBtn.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
}

@end
