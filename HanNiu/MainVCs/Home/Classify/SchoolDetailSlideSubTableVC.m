//
//  SchoolDetailSlideSubTableVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/11.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "SchoolDetailSlideSubTableVC.h"
#import "SchoolDetailVC.h"
#import "MusicDetailVC.h"
#import "MusicCommentVC.h"

#import "QualityCell.h"
#import "PublicImageTagTitleCell.h"
#import "CollegeIntroduceHeaderView.h"
#import "PublicCollectionHeaderTitleView.h"

@interface SchoolDetailSlideSubTableVC ()

@property (weak, nonatomic) SchoolDetailVC *p_vc;
@property (strong, nonatomic) SchoolIntroduceHeaderView *headerView;
@property (strong, nonatomic) AppQualityInfo *detailData;


@end

@implementation SchoolDetailSlideSubTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateTableViewHeader];
    if (self.indextag == 0) {
        self.tableView.tableHeaderView = self.headerView;
        [self updateHeaderView];
    }
}

- (void)pullBaseListData:(BOOL)isReset {
    if (self.indextag == 0) {
        [self doGetSchoolDetailFunction];
    }
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    
    NSString *urlFooter = @"";
    if (self.indextag == 0) {
        urlFooter = @"Music/Comment/List";
        [m_dic setObject:self.p_vc.data.Music.Id forKey:@"musicId"];
    }
    else if (self.indextag == 1) {
        urlFooter = @"Quality/List";
        [m_dic setObject:self.p_vc.data.Id forKey:@"schoolId"];
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
                [weakself.dataSource addObjectsFromArray:[AppCommentInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
            }
            else {
                [weakself.dataSource addObjectsFromArray:[AppQualityInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
            }
        }
        [weakself updateSubviews];
    }];
}

- (void)doGetSchoolDetailFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"id" : self.p_vc.data.Id}];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"University/School/Detail" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            weakself.detailData = [AppQualityInfo mj_objectWithKeyValues:responseBody[@"Data"]];
            [weakself updateSubviews];
        }
    }];
}

- (void)updateSubviews {
    [super updateSubviews];
    if (self.indextag == 0) {
        [self updateHeaderView];
    }
}

- (void)updateHeaderView{
    self.headerView.tagLabel.text = notNilString(self.detailData.Introduce, @"暂无简介");
    [self.headerView adjustTagLabelHeight:self.headerView.tagLabel.numberOfLines];
}

- (void)foldButtonAction:(UIButton *)button {
    if (self.headerView.tagLabel.numberOfLines == 3) {
        [self.headerView adjustTagLabelHeight:0];
    }
    else {
        [self.headerView adjustTagLabelHeight:3];
    }
    [self.tableView reloadData];
}

- (void)goToCommentVCAction {
    MusicCommentVC *vc = [MusicCommentVC new];
    vc.musicId = self.p_vc.data.Music.Id;
    [self doPushViewController:vc animated:YES];
}

- (void)cellHeaderViewAction {
    MusicDetailVC *vc = [MusicDetailVC new];
    vc.data = self.p_vc.data;
    [self doPushViewController:vc animated:YES];
}

#pragma mark - getter
- (SchoolDetailVC *)p_vc {
    if (!_p_vc) {
        _p_vc = (SchoolDetailVC *)self.parentVC;
    }
    return _p_vc;
}

- (SchoolIntroduceHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [SchoolIntroduceHeaderView new];
        [_headerView.foldBtn addTarget:self action:@selector(foldButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.indextag == 0) {
        AppCommentInfo *item = self.dataSource[indexPath.row];
        return [MusicCommentCell tableView:tableView heightForRowAtIndexPath:indexPath andSubTitle:item.showStringForContent];
    }
    return [QualityCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.indextag == 0) {
        return kCellHeight + kEdge;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.indextag == 0) {
        PublicCollectionHeaderTitleView *m_view = [[PublicCollectionHeaderTitleView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeight)];
        m_view.titleLabel.text = @"听众点评";
        m_view.subTitleLabel.text = @"";
        CGFloat right = m_view.rightImageView.right;
        CGFloat centerY = m_view.rightImageView.centerY;
        m_view.rightImageView.frame = CGRectMake(0, 0, 24, 24);
        m_view.rightImageView.right = right;
        m_view.rightImageView.centerY = centerY;
        m_view.rightImageView.image = [UIImage imageNamed:@"icon_play"];
        [m_view addSubview:NewSeparatorLine(CGRectMake(0, 0, m_view.width, appSeparaterLineSize))];
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, m_view.width, m_view.height + kEdge)];
        m_view.bottom = baseView.height;
        [baseView addSubview:m_view];
        return baseView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    if (self.indextag == 0) {
        MusicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MusicCommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.likeBtn removeFromSuperview];
        }
        cell.data = self.dataSource[indexPath.row];
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
    if (self.indextag  == 0) {
        [self goToCommentVCAction];
    }
    else if (self.indextag == 1) {
        MusicDetailVC *vc = [MusicDetailVC new];
        vc.data = self.dataSource[indexPath.row];
        [self doPushViewController:vc animated:YES];
    }
}

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_PublicCollectionHeaderTitleViewTapped]) {
        [self cellHeaderViewAction];
    }
}

@end
