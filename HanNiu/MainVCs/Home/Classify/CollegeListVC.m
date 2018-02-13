//
//  CollegeListVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/1.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "CollegeListVC.h"
#import "CollegeDetailVC.h"

#import "PublicImageSubTagTitleCell.h"
#import "UIImageView+WebCache.h"

@interface CollegeListVC ()

@end

@implementation CollegeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.tagString;
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"tag" : self.tagString}];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"University/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:[AppCollegeInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
        }
        [weakself updateSubviews];
    }];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PublicImageSubTagTitleCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    PublicImageSubTagTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PublicImageSubTagTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.subTitleLabel.width = [AppPublic textSizeWithString:@"播放：9999999999次" font:cell.subTitleLabel.font constantHeight:cell.subTitleLabel.height].width;
        cell.tagLabel.frame = CGRectMake(0.5 * screen_width, cell.subTitleLabel.top, screen_width - 0.5 * screen_width, cell.subTitleLabel.height);
        cell.tagLabel.font = [AppPublic appFontOfSize:appLabelFontSizeTiny];
    }
    AppCollegeInfo *item = self.dataSource[indexPath.row];
    [cell.showImageView sd_setImageWithURL:fileURLWithPID(item.Image) placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    cell.titleLabel.text = item.Name;
    cell.subTitleLabel.text = [NSString stringWithFormat:@"播放：%d次", item.Music.PlayTimes];
    cell.tagLabel.text = [NSString stringWithFormat:@"分类：%@", item.showStringForTags];
    cell.subTagLabel.text = item.showStringForAddr;
    [AppPublic adjustLabelWidth:cell.titleLabel];
    [AppPublic adjustLabelWidth:cell.subTagLabel];
    cell.subTagLabel.left = cell.titleLabel.right + kEdgeHuge;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CollegeDetailVC *vc = [CollegeDetailVC new];
    vc.data = [self.dataSource[indexPath.row] copy];
    [self doPushViewController:vc animated:YES];
}

@end
