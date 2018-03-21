//
//  HomeRecommendVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "HomeRecommendVC.h"
#import "CollegeDetailVC.h"
#import "RecommendCollegeListVC.h"
#import "BetterListVC.h"
#import "MusicDetailVC.h"

#import "PublicCollectionHeaderTitleView.h"
#import "PublicCollectionCell.h"

static NSString *reuseId_cell_school = @"reuseId_cell_school";

@interface HomeRecommendVC ()

@property (strong, nonatomic) NSMutableArray *universityList;
@property (strong, nonatomic) NSMutableArray *qualityList;

@end

@implementation HomeRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[PublicCollectionHeaderTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header_title];
    [self.collectionView registerClass:[PublicCollectionCell class] forCellWithReuseIdentifier:reuseId_cell_school];
    
    [self updateScrollViewHeader];
}

- (void)becomeListed {
    NSDate *lastRefreshTime = [[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey];
    if (self.isResetCondition || self.needRefresh || !self.universityList.count || !self.qualityList.count || !lastRefreshTime || [lastRefreshTime timeIntervalSinceNow] < -appRefreshTime) {
        [self beginRefreshing];
    }
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
        [weakself.adHeadView.adView updateAdvertisements:weakself.bannerList];
    }];
}

- (void)doGetUniversityListFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type" : @"1"}];
    //    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Featured/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself.universityList removeAllObjects];
            [weakself.universityList addObjectsFromArray:[AppBasicMusicDetailInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
        }
        [weakself updateSubviews];
    }];
}

- (void)doGetQuantityListFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type" : @"2"}];
    //    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Featured/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself.qualityList removeAllObjects];
            [weakself.qualityList addObjectsFromArray:[AppBasicMusicDetailInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
        }
        [weakself updateSubviews];
    }];
}

- (void)doGetMusicDetailFunction:(NSIndexPath *)indexPath {
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    NSString *urlFooter = @"Quality/List";
    
    AppBasicMusicDetailInfo *item;
    if (indexPath.section == 2) {
        item = self.qualityList[indexPath.row];
    }
    if (item.Institute) {
        [m_dic setObject:item.Institute.Id forKey:@"schoolId"];
    }
    else if (item.University) {
        [m_dic setObject:item.University.Id forKey:@"universityId"];
    }
    else if (item.College) {
        [m_dic setObject:item.College.Id forKey:@"universityId"];
    }
    
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:urlFooter completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            NSArray *m_array = [AppBasicMusicDetailInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]];
            [[AppPublic getInstance] goToMusicVC:item list:m_array type:PublicMusicDetailFromBetter];
        }
    }];
}

#pragma mark - getter
- (NSMutableArray *)universityList {
    if (!_universityList) {
        _universityList = [NSMutableArray new];
    }
    return _universityList;
}

- (NSMutableArray *)qualityList {
    if (!_qualityList) {
        _qualityList = [NSMutableArray new];
    }
    return _qualityList;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = 0;
    if (section == 1) {
        count = self.universityList.count;
    }
    else if (section == 2) {
        count = self.qualityList.count;
    }
    return MIN(6, count);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.adHeadView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header_ad forIndexPath:indexPath];
        [self.adHeadView.adView updateAdvertisements:self.bannerList];
        return self.adHeadView;
    }
    else {
        PublicCollectionHeaderTitleView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header_title forIndexPath:indexPath];
        headView.tag = indexPath.section;
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
        return [AdScrollView adSize];
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
    cell.backgroundColor = [UIColor greenColor];
    cell.titleLabel.text = @"";
    cell.showImageView.hidden = YES;
    AppBasicMusicDetailInfo *item = nil;
    if (indexPath.section == 1) {
        cell.showImageView.showImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.showImageView adjustShowImageViewWithScale:0.8];
        item = self.universityList[indexPath.row];
    }
    else if (indexPath.section == 2) {
        cell.showImageView.showImageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.showImageView adjustShowImageViewWithScale:1.0];
        item = self.qualityList[indexPath.row];
    }
    if (item) {
        [cell.showImageView.showImageView sd_setImageWithURL:fileURLWithPID(item.Image) placeholderImage:nil];
        cell.showImageView.hidden = NO;
        cell.titleLabel.text = item.Name;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        CollegeDetailVC *vc = [CollegeDetailVC new];
        vc.data = self.universityList[indexPath.row];
        [self doPushViewController:vc animated:YES];
    }
    else if (indexPath.section == 2) {
        [self doGetMusicDetailFunction:indexPath];
    }
}

//#pragma mark - UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 1) {
//        double width = [PublicCollectionViewController cellWithWithListCount:4 sectionInset:UIEdgeInsetsZero];
//        return CGSizeMake(width, width + 40);
//    }
//    return [(UICollectionViewFlowLayout *)collectionViewLayout itemSize];
//}

#pragma mark - UIResponder+Router
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSObject *)userInfo {
    if ([eventName isEqualToString:Event_PublicCollectionHeaderTitleViewTapped]) {
        NSDictionary *m_dic = (NSDictionary *)userInfo;
        int tag = [m_dic[@"tag"] intValue];
        if (tag == 1) {
            RecommendCollegeListVC *vc = [RecommendCollegeListVC new];
            [self doPushViewController:vc animated:YES];
        }
        else if (tag == 2) {
            BetterListVC *vc = [BetterListVC new];
            [self doPushViewController:vc animated:YES];
        }
    }
}

@end
