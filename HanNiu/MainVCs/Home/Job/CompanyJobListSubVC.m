//
//  CompanyJobListVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/6.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "CompanyJobListSubVC.h"
#import "CompanyDetailVC.h"
#import "JobDetailVC.h"

#import "PublicImageSubTagTitleCell.h"

#import "NSAttributedString+JTATEmoji.h"

@interface CompanyJobListSubVC ()

@end

@implementation CompanyJobListSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateTableViewHeader];
    
}

- (void)pullBaseListData:(BOOL)isReset {
    CompanyDetailVC *p_VC = (CompanyDetailVC *)self.parentVC;
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"companyId" : p_VC.data.Id}];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Job/Job/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:[AppJobInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
        }
        [weakself updateSubviews];
    }];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PublicImageSubTagTitleCell tableView:tableView heightForRowAtIndexPath:indexPath] + kEdge;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    PublicImageSubTagTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PublicImageSubTagTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.showImageView.hidden = YES;
        cell.titleLabel.left = cell.showImageView.left;
        cell.subTitleLabel.left = cell.titleLabel.left;
        cell.tagLabel.left = cell.titleLabel.left;
        cell.tagLabel.top = cell.subTitleLabel.bottom;
        cell.subTagLabel.frame = CGRectMake(kEdgeMiddle, cell.titleLabel.top, screen_width - 2 * kEdgeMiddle, cell.titleLabel.height);
        cell.subTagLabel.textAlignment = NSTextAlignmentRight;
        cell.subTagLabel.textColor = appMainColor;
    }
    
    AppJobInfo *item = self.dataSource[indexPath.row];
    cell.titleLabel.text = item.Name;
    cell.subTitleLabel.attributedText = [NSAttributedString emojiAttributedString:[NSString stringWithFormat:@"[place] %@　[place] %@　[place] %@及以上", item.Area, item.Exp, item.Edu] withFont:cell.subTitleLabel.font];
    cell.tagLabel.text = item.Company.Name;
    cell.subTagLabel.text = item.Salary;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    JobDetailVC *vc = [JobDetailVC new];
    vc.data = self.dataSource[indexPath.row];
    [self doPushViewController:vc animated:YES];
}

@end
