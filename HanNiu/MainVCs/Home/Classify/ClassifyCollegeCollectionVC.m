//
//  ClassifyCollectionVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/31.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "ClassifyCollegeCollectionVC.h"
#import "CollegeListVC.h"

#import "PublicCollectionHeaderTitleView.h"
#import "PublicCollectionFooterLineView.h"
#import "PublicCollectionButtonCell.h"

@interface ClassifyCollegeCollectionVC ()

@end

@implementation ClassifyCollegeCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[PublicCollectionHeaderTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header_title];
    [self.collectionView registerClass:[PublicCollectionFooterLineView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseId_footer_line];
    [self.collectionView registerClass:[PublicCollectionButtonCell class] forCellWithReuseIdentifier:reuseId_cell_btn];
    [self updateScrollViewHeader];
}

- (void)pullBaseListData:(BOOL)isReset {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:@[@{@"NameKey" : @"college_title", @"NameValue" : @"学校等级", @"ListKey" : @"college_title_list", @"ListValue" : [UserPublic getInstance].dataMapDic[@"college_title"]},
    @{@"NameKey" : @"college_level", @"NameValue" : @"学校批次", @"ListKey" : @"college_level_list", @"ListValue" : [UserPublic getInstance].dataMapDic[@"college_level"]},
    @{@"NameKey" : @"college_area", @"NameValue" : @"学校区域", @"ListKey" : @"college_area_list", @"ListValue" : [UserPublic getInstance].dataMapDic[@"province"]},
    @{@"NameKey" : @"college_major", @"NameValue" : @"学校分类", @"ListKey" : @"college_major_list", @"ListValue" : [UserPublic getInstance].dataMapDic[@"college_major"]}]];
    [self endRefreshing];
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *m_array = self.dataSource[section][@"ListValue"];
    return m_array.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PublicCollectionHeaderTitleView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseId_header_title forIndexPath:indexPath];
        headView.titleLabel.text = self.dataSource[indexPath.section][@"NameValue"];
        headView.rightImageView.hidden = YES;
        
        return headView;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        PublicCollectionFooterLineView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseId_footer_line forIndexPath:indexPath];
        footerView.lineView.hidden = (indexPath.section == [self numberOfSectionsInCollectionView:collectionView] - 1);
        return footerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(screen_width, kCellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    if (section == [self numberOfSectionsInCollectionView:collectionView] - 1) {
        return CGSizeMake(collectionView.width, kEdgeMiddle);
//    }
//    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PublicCollectionButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId_cell_btn forIndexPath:indexPath];

    NSArray *m_array = self.dataSource[indexPath.section][@"ListValue"];
    AppItemInfo *item = m_array[indexPath.row];
    [cell.button setTitle:item.Name forState:UIControlStateNormal];
    cell.button.tag = indexPath.row;
    cell.button.userInteractionEnabled = NO;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSArray *m_array = self.dataSource[indexPath.section][@"ListValue"];
    AppItemInfo *item = m_array[indexPath.row];
    
    CollegeListVC *vc = [CollegeListVC new];
    vc.tagString = [item.Name copy];
    [self doPushViewController:vc animated:YES];
}

@end
