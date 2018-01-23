//
//  HomeRecommendVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "HomeRecommendVC.h"

#import "PublicCollectionHeaderAdView.h"
#import "PublicCollectionHeaderTitleView.h"
#import "PublicCollectionCell.h"

#import "UIImageView+WebCache.h"

static NSString *reuseId_header_ad = @"reuseId_header_ad";
static NSString *reuseId_header_title = @"reuseId_header_title";
static NSString *reuseId_cell_school = @"reuseId_cell_school";

@interface HomeRecommendVC ()


@end

@implementation HomeRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[PublicCollectionHeaderAdView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header_ad];
    [self.collectionView registerClass:[PublicCollectionHeaderTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header_title];
    [self.collectionView registerClass:[PublicCollectionCell class] forCellWithReuseIdentifier:reuseId_cell_school];
}

- (void)initializeNavigationBar {
    
}

#pragma mark - getter

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = 0;
    if (section == 1) {
        count = 6;
    }
    else if (section == 2) {
        count = 6;
    }
    return count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PublicCollectionHeaderAdView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header_ad forIndexPath:indexPath];
        [headView.adView setImageNameArray:@[@"http://101.201.51.208:9528/api/File/?pid=383", @"http://101.201.51.208:9528/api/File/?pid=408"]];
        return headView;
    }
    else {
        PublicCollectionHeaderTitleView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header_title forIndexPath:indexPath];
        switch (indexPath.section) {
            case 1: {
                headView.titleLabel.text = @"推荐学校";
            }
                break;
                
            case 2: {
                headView.titleLabel.text = @"推荐精品";
            }
                break;
                
            default:
                break;
        }
        
        return headView;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(screen_width, screen_width * 320.0 / 1050.0);
    }
    else {
        return CGSizeMake(screen_width, kCellHeight);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(collectionView.width, kEdgeMiddle);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PublicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId_cell_school forIndexPath:indexPath];
    [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:@"http://101.201.51.208:9528/api/File/?pid=408"] placeholderImage:nil];
    cell.titleLabel.text = [NSString stringWithFormat:@"大学%d", (int)indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
