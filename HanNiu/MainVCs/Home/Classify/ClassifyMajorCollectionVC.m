//
//  ClassifyMajorCollectionVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/1.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "ClassifyMajorCollectionVC.h"
#import "MajorListVC.h"

#import "PublicCollectionHeaderTitleView.h"
#import "PublicCollectionFooterLineView.h"
#import "PublicCollectionButtonCell.h"

@interface ClassifyMajorCollectionVC ()

@property (strong, nonatomic) NSMutableArray *trainingList;
@property (strong, nonatomic) NSMutableArray *undergraduateList;
@property (strong, nonatomic) NSMutableArray *mastorList;

@end

@implementation ClassifyMajorCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[PublicCollectionHeaderTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header_title];
    [self.collectionView registerClass:[PublicCollectionFooterLineView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseId_footer_line];
    [self.collectionView registerClass:[PublicCollectionButtonCell class] forCellWithReuseIdentifier:reuseId_cell_btn];
    
    [self.dataSource addObject:self.mastorList];
    [self.dataSource addObject:self.undergraduateList];
    [self.dataSource addObject:self.trainingList];
    [self updateScrollViewHeader];
}

- (void)becomeListed {
    NSDate *lastRefreshTime = [[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey];
    if (self.isResetCondition || self.needRefresh || !self.mastorList.count || !self.undergraduateList.count || !self.trainingList.count || !lastRefreshTime || [lastRefreshTime timeIntervalSinceNow] < -appRefreshTime) {
        [self beginRefreshing];
    }
}

- (void)pullBaseListData:(BOOL)isReset {
    [self doGetMasterListFunction];
    [self doGetUndergraduateFunction];
    [self doGetTrainingListFunction];
}

- (void)doGetMasterListFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"parent" : @"9"}];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"MajorDict/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself.mastorList removeAllObjects];
            [weakself.mastorList addObjectsFromArray:[AppMajorInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
        }
        [weakself updateSubviews];
    }];
}

- (void)doGetUndergraduateFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"parent" : @"6"}];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"MajorDict/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself.undergraduateList removeAllObjects];
            [weakself.undergraduateList addObjectsFromArray:[AppMajorInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
        }
        [weakself updateSubviews];
    }];
}

- (void)doGetTrainingListFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"parent" : @"8"}];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"MajorDict/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself.trainingList removeAllObjects];
            [weakself.trainingList addObjectsFromArray:[AppMajorInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
        }
        [weakself updateSubviews];
    }];
}

#pragma mark - getter
- (NSMutableArray *)mastorList {
    if (!_mastorList) {
        _mastorList = [NSMutableArray new];
    }
    return _mastorList;
}

- (NSMutableArray *)undergraduateList {
    if (!_undergraduateList) {
        _undergraduateList = [NSMutableArray new];
    }
    return _undergraduateList;
}

- (NSMutableArray *)trainingList {
    if (!_trainingList) {
        _trainingList = [NSMutableArray new];
    }
    return _trainingList;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *m_array = self.dataSource[section];
    return m_array.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PublicCollectionHeaderTitleView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseId_header_title forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headView.titleLabel.text = @"研究生专业";
        }
        else if (indexPath.section == 1) {
            headView.titleLabel.text = @"本科专业";
        }
        else if (indexPath.section == 2) {
            headView.titleLabel.text = @"专科专业";
        }
        headView.rightImageView.hidden = YES;
        return headView;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        PublicCollectionFooterLineView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseId_footer_line forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    NSArray *m_array = self.dataSource[section];
    return m_array.count > 0 ? CGSizeMake(screen_width, kCellHeight) : CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    NSArray *m_array = self.dataSource[section];
    return m_array.count > 0 ? CGSizeMake(collectionView.width, kEdgeMiddle) : CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PublicCollectionButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId_cell_btn forIndexPath:indexPath];
    
    NSArray *m_array = self.dataSource[indexPath.section];
    AppMajorInfo *item = m_array[indexPath.row];
    [cell.button setTitle:item.FirstTag forState:UIControlStateNormal];
    cell.button.tag = indexPath.row;
    cell.button.userInteractionEnabled = NO;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSArray *m_array = self.dataSource[indexPath.section];
    MajorListVC *vc = [MajorListVC new];
    vc.majorData = m_array[indexPath.row];
    [self doPushViewController:vc animated:YES];
}

@end
