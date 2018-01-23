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

@property (strong, nonatomic) PublicCollectionHeaderAdView *adHeadView;
@property (strong, nonatomic) NSMutableArray *bannerList;
@property (strong, nonatomic) NSMutableArray *universityList;
@property (strong, nonatomic) NSMutableArray *quantityList;

@end

@implementation HomeRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[PublicCollectionHeaderAdView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header_ad];
    [self.collectionView registerClass:[PublicCollectionHeaderTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header_title];
    [self.collectionView registerClass:[PublicCollectionCell class] forCellWithReuseIdentifier:reuseId_cell_school];
    
    [self updateScrollViewHeader];
    [self beginRefreshing];
}

- (void)initializeNavigationBar {
    
}

- (void)pullBaseListData:(BOOL)isReset {
    [self doGetBannerListFunction];
    [self doGetUniversityListFunction];
    [self doGetQuantityListFunction];
}

- (void)doGetBannerListFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type" : @"0"}];
//    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Config/Banner/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself.bannerList removeAllObjects];
            [weakself.bannerList addObjectsFromArray:responseBody[@"Data"]];
        }
        [weakself updateSubviews];
    }];
}

- (void)doGetUniversityListFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"channel" : @"1"}];
    //    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"University/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself.universityList removeAllObjects];
            [weakself.universityList addObjectsFromArray:responseBody[@"Data"]];
        }
        [weakself updateSubviews];
    }];
}

- (void)doGetQuantityListFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{}];
    //    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Quality/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself.quantityList removeAllObjects];
            [weakself.quantityList addObjectsFromArray:responseBody[@"Data"]];
        }
        [weakself updateSubviews];
    }];
}



#pragma mark - getter
- (NSMutableArray *)bannerList {
    if (!_bannerList) {
        _bannerList = [NSMutableArray new];
    }
    return _bannerList;
}

- (NSMutableArray *)universityList {
    if (!_universityList) {
        _universityList = [NSMutableArray new];
    }
    return _universityList;
}

- (NSMutableArray *)quantityList {
    if (!_quantityList) {
        _quantityList = [NSMutableArray new];
    }
    return _quantityList;
}

//- (PublicCollectionHeaderAdView *)adHeadView {
//    if (!_adHeadView) {
//        _adHeadView = [[PublicCollectionHeaderAdView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_width * 320.0 / 1050.0)];
//    }
//    return _adHeadView;
//}

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
        self.adHeadView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header_ad forIndexPath:indexPath];
        NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:self.bannerList.count];
        for (NSDictionary *item in self.bannerList) {
            [m_array addObject:urlStringWithService([NSString stringWithFormat:@"File/?pid=%@", item[@"Image"]])];
        }
        [self.adHeadView.adView setImageNameArray:m_array];
        return self.adHeadView;
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
        return CGSizeMake(screen_width, screen_width * 1.0 / 2.5);
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
    
    cell.titleLabel.text = @"";
    cell.showImageView.hidden = YES;
    if (indexPath.section == 1) {
        if (indexPath.row < self.universityList.count) {
            NSDictionary *item = self.universityList[indexPath.row];
            [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:urlStringWithService([NSString stringWithFormat:@"File/?pid=%@", item[@"Image"]])] placeholderImage:nil];
            cell.showImageView.hidden = NO;
            cell.titleLabel.text = item[@"Name"];
        }
    }
    else if (indexPath.section == 2) {
        if (indexPath.row < self.quantityList.count) {
            NSDictionary *item = self.quantityList[indexPath.row];
            [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:urlStringWithService([NSString stringWithFormat:@"File/?pid=%@", item[@"Image"]])] placeholderImage:nil];
            cell.showImageView.hidden = NO;
            cell.titleLabel.text = item[@"Name"];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
