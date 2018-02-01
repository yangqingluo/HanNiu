//
//  MajorListVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/1.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "MajorListVC.h"
#import "MajorDetailListVC.h"

#import "PublicTableViewCell.h"

@interface MajorListVC () {
    NSInteger selectedSection;
}

@end

@implementation MajorListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.majorData.FirstTag;
    [self resetSelectedSection];
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"parent" : self.majorData.Id}];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"MajorDict/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:[AppMajorDetailInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
        }
        [weakself updateSubviews];
    }];
}

- (void)doGetThirdMajorListFunction:(NSInteger)section {
    if (section > self.dataSource.count - 1) {
        return;
    }
    AppMajorDetailInfo *secondMajor = self.dataSource[section];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"parent" : secondMajor.Id}];
    
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"MajorDict/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            
            secondMajor.subMajors = [AppMajorDetailInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]];
            [weakself selectSelection:section];
        }
    }];
}

- (void)resetSelectedSection {
    selectedSection = -1;
}

- (void)selectSelection:(NSInteger)section {
    if (selectedSection == section) {
        [self resetSelectedSection];
        [self updateSubviews];
    }
    else {
        AppMajorDetailInfo *secondMajor = self.dataSource[section];
        if (secondMajor.subMajors) {
            if (secondMajor.subMajors.count) {
                selectedSection = section;
                [self updateSubviews];
            }
        }
        else {
            [self doGetThirdMajorListFunction:section];
        }
    }
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AppMajorDetailInfo *secondMajor = self.dataSource[section];
    return 1 + (section == selectedSection ? secondMajor.subMajors.count : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PublicTableViewCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == [self numberOfSectionsInTableView:tableView] - 1) ? kEdge : 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    PublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PublicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.showImageView.contentMode = UIViewContentModeCenter;
    }
    
    AppMajorDetailInfo *item = self.dataSource[indexPath.section];
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:indexPath.section == selectedSection ? @"icon_arrow_up" : @"icon_arrow_down"];
        cell.textLabel.text = item.SecondTag;
    }
    else {
        AppMajorDetailInfo *subItem = item.subMajors[indexPath.row - 1];
        cell.imageView.image = [UIImage imageNamed:@"icon_arrow_space"];
        cell.textLabel.text = subItem.ThirdTag;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        [self selectSelection:indexPath.section];
    }
    else {
        AppMajorDetailInfo *item = self.dataSource[indexPath.section];
        
        MajorDetailListVC *vc = [MajorDetailListVC new];
        vc.thirdMajorData = item.subMajors[indexPath.row - 1];
        [self doPushViewController:vc animated:YES];
    }
}

@end
