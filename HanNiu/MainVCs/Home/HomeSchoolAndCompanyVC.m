//
//  HomeSchoolAndCompanyVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "HomeSchoolAndCompanyVC.h"
#import "SchoolAndCompanyTableVC.h"

#import "PublicCollectionHeaderAdView.h"
#import "QCSlideSwitchView.h"
#import "UIImage+SubImage.h"

@interface HomeSchoolAndCompanyVC ()<QCSlideSwitchViewDelegate>

@property (strong, nonatomic) QCSlideSwitchView *slidePageView;
@property (strong, nonatomic) NSMutableArray *viewArray;

@property (strong, nonatomic) AdScrollView *adHeadView;
@property (strong, nonatomic) NSMutableArray *bannerList;

@end

@implementation HomeSchoolAndCompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.adHeadView];
    
    self.viewArray = [NSMutableArray new];
    [self.viewArray addObject:@{@"title":@"校", @"VC":[[SchoolAndCompanyTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self.parentVC andIndexTag:0]}];
    [self.viewArray addObject:@{@"title":@"企", @"VC":[[SchoolAndCompanyTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self.parentVC andIndexTag:1]}];
    [self.viewArray addObject:@{@"title":@"$", @"VC":[[SchoolAndCompanyTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self.parentVC andIndexTag:2]}];
    [self.view addSubview:self.slidePageView];
    [self.slidePageView buildUI];
}

- (void)becomeListed {
    NSDate *lastRefreshTime = [[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey];
    if (self.isResetCondition || self.needRefresh || !self.bannerList.count || !lastRefreshTime || [lastRefreshTime timeIntervalSinceNow] < -appRefreshTime) {
        [self doGetBannerListFunction];
    }
    for (NSDictionary *m_dic in self.viewArray) {
        PublicViewController *vc = m_dic[@"VC"];
        if (vc) {
            if (self.slidePageView.superview) {
                if ([self.viewArray indexOfObject:m_dic] == self.slidePageView.selectedIndex) {
                    [vc becomeListed];
                }
            }
        }
    }
    [self slideSwitchView:self.slidePageView didselectTab:self.slidePageView.selectedIndex];
}

- (void)becomeUnListed {
    
}

- (void)doGetBannerListFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type" : @"4"}];
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
        [weakself.adHeadView updateAdvertisements:weakself.bannerList];
    }];
}

- (void)endRefreshing {
    //记录刷新时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.dateKey];
    [self doHideHudFunction];
}

- (void)updateSubviews {
    
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

- (QCSlideSwitchView *)slidePageView{
    if (!_slidePageView) {
        _slidePageView = [[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, self.adHeadView.bottom, self.view.width, self.view.height - self.adHeadView.bottom)];
        _slidePageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        _slidePageView.delegate = self;
        _slidePageView.topScrollView.backgroundColor = [UIColor whiteColor];
        _slidePageView.tabItemNormalColor = appTextColor;
        _slidePageView.tabItemSelectedColor = appMainColor;
        _slidePageView.shadowImageView.backgroundColor = appSeparatorColor;
        _slidePageView.rootScrollView.scrollEnabled = YES;
    }
    
    return _slidePageView;
}

#pragma mark - QCSlider
- (CGFloat)widthOfTab:(NSUInteger)index {
    return self.view.bounds.size.width / self.viewArray.count;
}
- (NSString *)titleOfTab:(NSUInteger)index {
    NSDictionary *dic = self.viewArray[index];
    return dic[@"title"];
}

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view {
    return self.viewArray.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number {
    NSDictionary *dic = self.viewArray[number];
    return dic[@"VC"];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number {
    if (self.isListed) {
        NSDictionary *dic = self.viewArray[number];
        PublicViewController *listVC = dic[@"VC"];
        if ([listVC respondsToSelector:@selector(becomeListed)]) {
            [listVC performSelector:@selector(becomeListed)];
        }
        [self.slidePageView showRedPoint:NO withIndex:number];
    }
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didunselectTab:(NSUInteger)number {
    NSDictionary *dic = self.viewArray[number];
    PublicViewController *listVC = dic[@"VC"];
    if ([listVC respondsToSelector:@selector(becomeUnListed)]) {
        [listVC performSelector:@selector(becomeUnListed)];
    }
}

@end
