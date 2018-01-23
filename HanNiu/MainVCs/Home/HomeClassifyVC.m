//
//  HomeClassifyVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "HomeClassifyVC.h"

#import "PublicCollectionHeaderAdView.h"

@interface HomeClassifyVC ()

@property (strong, nonatomic) AdScrollView *adHeadView;
@property (strong, nonatomic) NSMutableArray *bannerList;

@end

@implementation HomeClassifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.adHeadView];
    [self doGetBannerListFunction];
}

- (void)becomeListed {
    NSDate *lastRefreshTime = [[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey];
    if (self.isResetCondition || self.needRefresh || !self.bannerList.count || !lastRefreshTime || [lastRefreshTime timeIntervalSinceNow] < -appRefreshTime) {
        
    }
}

- (void)doGetBannerListFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type" : @"1"}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Config/Banner/List" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
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

- (void)updateSubviews {
    [self.adHeadView updateAdvertisements:self.bannerList];
}

#pragma mark - getter
- (AdScrollView *)adHeadView {
    if (!_adHeadView) {
        _adHeadView = [AdScrollView new];
    }
    return _adHeadView;
}

- (NSMutableArray *)bannerList {
    if (!_bannerList) {
        _bannerList = [NSMutableArray new];
    }
    return _bannerList;
}

@end
