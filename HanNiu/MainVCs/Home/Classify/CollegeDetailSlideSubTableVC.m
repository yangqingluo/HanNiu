//
//  CollegeDetailSlideSubTableVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/2.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "CollegeDetailSlideSubTableVC.h"
#import "CollegeDetailVC.h"
#import "SchoolDetailVC.h"

#import "QualityCell.h"

@interface CollegeDetailSlideSubTableVC ()

@end

@implementation CollegeDetailSlideSubTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateTableViewHeader];
}

- (void)pullBaseListData:(BOOL)isReset {
    CollegeDetailVC *p_VC = (CollegeDetailVC *)self.parentVC;
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    
    NSString *urlFooter = @"";
    if (self.indextag == 1) {
        urlFooter = @"University/School/List";
    }
    else if (self.indextag == 2) {
        urlFooter = @"Quality/List";
    }
    [m_dic setObject:p_VC.data.Id forKey:@"universityId"];
    
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:urlFooter completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:[AppQualityInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
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
    if (self.indextag  == 1) {
        SchoolDetailVC *vc = [SchoolDetailVC new];
        vc.data = self.dataSource[indexPath.row];
        [self doPushViewController:vc animated:YES];
    }
    
}

@end
