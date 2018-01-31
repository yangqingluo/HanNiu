//
//  HomeJobVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "HomeJobVC.h"
#import "JobListVC.h"

#import "PublicCollectionButtonCell.h"

@interface HomeJobVC ()

@property (strong, nonatomic) NSArray *provinceList;

@end

@implementation HomeJobVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[PublicCollectionButtonCell class] forCellWithReuseIdentifier:reuseId_cell_btn];
}

- (void)becomeListed {
    NSDate *lastRefreshTime = [[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey];
    if (self.isResetCondition || self.needRefresh || !self.bannerList.count || !lastRefreshTime || [lastRefreshTime timeIntervalSinceNow] < -appRefreshTime) {
        [self doGetBannerListFunction];
    }
}

- (void)pullBaseListData:(BOOL)isReset {
    [self doGetBannerListFunction];
}

- (void)doGetBannerListFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type" : @"3"}];
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

- (void)cellButtonAction:(UIButton *)button {
    JobListVC *vc = [JobListVC new];
    vc.province = self.provinceList[button.tag];
    [self doPushViewController:vc animated:YES];
}

#pragma mark - getter
- (NSArray *)provinceList {
    if (!_provinceList) {
        _provinceList = [AppItemInfo mj_objectArrayWithKeyValuesArray:[UserPublic getInstance].dataMapDic[@"province"]];
    }
    return _provinceList;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = self.provinceList.count;
    return 4 * ceil(count / 4.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.adHeadView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header_ad forIndexPath:indexPath];
        [self.adHeadView.adView updateAdvertisements:self.bannerList];
        return self.adHeadView;
    }
    
    return nil;
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
    PublicCollectionButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId_cell_btn forIndexPath:indexPath];
    
    cell.button.hidden = YES;
    if (indexPath.row < self.provinceList.count) {
        AppItemInfo *item = self.provinceList[indexPath.row];
        [cell.button setTitle:item.Name forState:UIControlStateNormal];
        cell.button.hidden = NO;
        cell.button.tag = indexPath.row;
        [cell.button addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
}

@end
