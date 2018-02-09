//
//  HomeMessageSubTableVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/9.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "HomeMessageSubTableVC.h"
#import "MusicCommentVC.h"

#import "PublicImageTagTitleCell.h"

@interface HomeMessageSubTableVC ()

@end

@implementation HomeMessageSubTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateTableViewHeader];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{}];
    
    NSString *url_footer = @"";
    if (self.indextag == 0) {
        url_footer = @"Music/Comment/ToMe";
    }
    else if (self.indextag == 1) {
        url_footer = @"Music/Comment/FromMe";
    }
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:url_footer completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:[AppCommentInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
            [weakself updateSubviews];
        }
    }];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.indextag == 0) {
        return [MusicCommentToMeCell tableView:tableView heightForRowAtIndexPath:indexPath andComment:self.dataSource[indexPath.row]];
    }
    else {
        return [MusicCommentFromMeCell tableView:tableView heightForRowAtIndexPath:indexPath andComment:self.dataSource[indexPath.row]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    if (self.indextag == 0) {
        MusicCommentToMeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MusicCommentToMeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.data = self.dataSource[indexPath.row];
        return cell;
    }
    else {
        MusicCommentFromMeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MusicCommentFromMeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.data = self.dataSource[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AppCommentInfo *item = self.dataSource[indexPath.row];
    MusicCommentVC *vc = [MusicCommentVC new];
    vc.musicId = item.MusicId;
    [self doPushViewController:vc animated:YES];
}


@end
