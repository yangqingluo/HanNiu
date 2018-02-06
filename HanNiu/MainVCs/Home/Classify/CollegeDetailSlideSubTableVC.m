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
#import "PublicThreeImageButtonCell.h"
#import "CollegeIntroduceHeaderView.h"
#import "PublicCollectionHeaderTitleView.h"

#import "UIImageView+WebCache.h"
#import "PublicMessageReadManager.h"

@interface CollegeDetailSlideSubTableVC ()

@property (strong, nonatomic) CollegeIntroduceHeaderView *headerView;
@property (strong, nonatomic) AppCollegeInfo *detailData;

@end

@implementation CollegeDetailSlideSubTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateTableViewHeader];
    if (self.indextag == 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            if (self.indextag == 0) {
                weakself.detailData = [AppCollegeInfo mj_objectWithKeyValues:responseBody[@"Data"]];
                [weakself.dataSource addObject:[AppCollegeInfo mj_objectWithKeyValues:responseBody[@"Data"]]];
            }
            else {
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
    if (self.indextag == 0) {
        return [PublicThreeImageButtonCell tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return [QualityCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.indextag == 0) {
        return kCellHeight;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.indextag == 0) {
        PublicCollectionHeaderTitleView *m_view = [[PublicCollectionHeaderTitleView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeight)];
        m_view.titleLabel.text = @"学校风采";
        m_view.subTitleLabel.text = @"更多";
        [m_view addSubview:NewSeparatorLine(CGRectMake(0, 0, m_view.width, appSeparaterLineSize))];
        return m_view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    if (self.indextag == 0) {
        PublicThreeImageButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[PublicThreeImageButtonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.data = self.detailData.picsAddressListForPics;
        return cell;
    }
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

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_PublicThreeImageButtonCellButtonClicked]) {
        NSDictionary *m_dic = (NSDictionary *)userInfo;
        int tag = [m_dic[@"tag"] intValue];
        [[PublicMessageReadManager defaultManager] showBrowserWithImages:self.detailData.picsAddressListForPics currentPhotoIndex:tag];
    }
    else if ([eventName isEqualToString:Event_PublicCollectionHeaderTitleViewTapped]) {
        [[PublicMessageReadManager defaultManager] showBrowserWithImages:self.detailData.picsAddressListForPics];
    }
}

@end
