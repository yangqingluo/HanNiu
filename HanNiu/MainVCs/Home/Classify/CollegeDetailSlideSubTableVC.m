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
#import "CollegeIntroduceHeaderView.h"

#import "UIImageView+WebCache.h"

@interface CollegeDetailSlideSubTableVC ()

@property (strong, nonatomic) CollegeIntroduceHeaderView *headerView;
@property (strong, nonatomic) AppCollegeInfo *detailData;

@end

@implementation CollegeDetailSlideSubTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateTableViewHeader];
    if (self.indextag == 0) {
        self.tableView.tableHeaderView = self.headerView;
        [self updateHeaderView];
    }
}

- (void)pullBaseListData:(BOOL)isReset {
    CollegeDetailVC *p_VC = (CollegeDetailVC *)self.parentVC;
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    
    NSString *urlFooter = @"";
    if (self.indextag == 0) {
        urlFooter = @"University/Detail";
        [m_dic setObject:p_VC.data.Id forKey:@"id"];
    }
    else if (self.indextag == 1) {
        urlFooter = @"University/School/List";
        [m_dic setObject:p_VC.data.Id forKey:@"universityId"];
    }
    else if (self.indextag == 2) {
        urlFooter = @"Quality/List";
        [m_dic setObject:p_VC.data.Id forKey:@"universityId"];
    }
    
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:urlFooter completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            if (self.indextag == 0) {
                weakself.detailData = [AppCollegeInfo mj_objectWithKeyValues:responseBody[@"Data"]];
            }
            else {
                if (isReset) {
                    [weakself.dataSource removeAllObjects];
                }
                [weakself.dataSource addObjectsFromArray:[AppQualityInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
            }
        }
        [weakself updateSubviews];
    }];
}

- (void)updateSubviews {
    [super updateSubviews];
    if (self.indextag == 0) {
        [self updateHeaderView];
    }
}

- (void)updateHeaderView{
    [self.headerView.showImageView sd_setImageWithURL:fileURLWithPID(self.detailData.Image) placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    self.headerView.titleLabel.text = self.detailData.Name;
    self.headerView.subTitleLabel.text = self.detailData.Web;
    self.headerView.tagLabel.text = self.detailData.Introduce;
    [self.headerView adjustTagLabelHeight:self.headerView.tagLabel.numberOfLines];
}

- (void)foldButtonAction:(UIButton *)button {
    if (self.headerView.tagLabel.numberOfLines == 3) {
        [self.headerView adjustTagLabelHeight:0];
    }
    else {
        [self.headerView adjustTagLabelHeight:3];
    }
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - getter
- (CollegeIntroduceHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [CollegeIntroduceHeaderView new];
        [_headerView.foldBtn addTarget:self action:@selector(foldButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (AppCollegeInfo *)detailData {
    if (!_detailData) {
        CollegeDetailVC *p_VC = (CollegeDetailVC *)self.parentVC;
        _detailData = [p_VC.data copy];
    }
    return _detailData;
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
