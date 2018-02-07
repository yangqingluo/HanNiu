//
//  MusicCommentVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/25.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "MusicCommentVC.h"

#import "PublicImageTagTitleCell.h"

#import "UIImageView+WebCache.h"

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

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PublicImageTagTitleCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    PublicImageTagTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PublicImageTagTitleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.height = 0.5 * cell.showImageView.height;
        cell.subTitleLabel.top = cell.showImageView.centerY + kEdgeSmall;
        cell.tagLabel.frame = CGRectMake(screen_width - kEdgeMiddle - 120, cell.titleLabel.top, 120, cell.titleLabel.height);
        cell.tagLabel.textAlignment = NSTextAlignmentRight;
    }
    
    AppCommentInfo *item = self.dataSource[indexPath.row];
    [cell.showImageView sd_setImageWithURL:fileURLWithPID(item.User.Image) placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    cell.titleLabel.text = item.User.Name;
    cell.subTitleLabel.text = item.showStringForContent;
    cell.tagLabel.text = stringFromDate([NSDate dateWithTimeIntervalSince1970:0.001 * [item.UpdateTime integerValue]], @"yyyy.MM.dd");
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
}

@end
