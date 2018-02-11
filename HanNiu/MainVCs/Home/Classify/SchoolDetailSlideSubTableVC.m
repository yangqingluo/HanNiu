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

#import "QualityCell.h"
#import "CollegeIntroduceHeaderView.h"

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
        urlFooter = @"Quality/List";
        [m_dic setObject:self.p_vc.data.Id forKey:@"schoolId"];
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

- (void)doGetMusicCommentFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"MusicId" : self.p_vc.data.Music.Id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Music/Comment/List" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            
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
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - getter
- (SchoolDetailVC *)p_vc {
   return (SchoolDetailVC *)self.parentVC;
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
    return [QualityCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.indextag == 0) {
        return kCellHeight;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
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
    if (self.indextag  == 0) {
        
    }
    else if (self.indextag == 1) {
        MusicDetailVC *vc = [MusicDetailVC new];
        vc.data = self.dataSource[indexPath.row];
        [self doPushViewController:vc animated:YES];
    }
}

@end
