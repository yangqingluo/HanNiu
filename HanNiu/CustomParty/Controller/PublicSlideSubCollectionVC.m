//
//  PublicSlideSubCollectionVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicSlideSubCollectionVC.h"

@interface PublicSlideSubCollectionVC ()

@end

@implementation PublicSlideSubCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[PublicCollectionHeaderAdView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header_ad];
}

- (void)initializeNavigationBar {
    
}

- (void)becomeListed {
    NSDate *lastRefreshTime = [[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey];
    if (self.isResetCondition || self.needRefresh || !self.dataSource.count || !lastRefreshTime || [lastRefreshTime timeIntervalSinceNow] < -appRefreshTime) {
        [self beginRefreshing];
    }
}

#pragma mark - getter
- (NSMutableArray *)bannerList {
    if (!_bannerList) {
        _bannerList = [NSMutableArray new];
    }
    return _bannerList;
}

@end
