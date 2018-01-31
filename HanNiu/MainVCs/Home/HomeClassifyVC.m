//
//  HomeClassifyVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "HomeClassifyVC.h"

#import "PublicCollectionHeaderAdView.h"
#import "QCSlideSwitchView.h"
#import "UIImage+SubImage.h"

@interface HomeClassifyVC ()<QCSlideSwitchViewDelegate>

@property (strong, nonatomic) QCSlideSwitchView *slidePageView;
@property (strong, nonatomic) NSMutableArray *viewArray;

@property (strong, nonatomic) AdScrollView *adHeadView;
@property (strong, nonatomic) NSMutableArray *bannerList;

@end

@implementation HomeClassifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.adHeadView];
    
    
    self.viewArray = [NSMutableArray new];
    [self.viewArray addObject:@{@"title":@"院校大全", @"image" : @"icon_classify_tab_title_left", @"VC":[PublicSlideSubVC new]}];
    [self.viewArray addObject:@{@"title":@"专业大全", @"image" : @"icon_classify_tab_title_right", @"VC":[PublicSlideSubVC new]}];
    [self.view addSubview:self.slidePageView];
    [self.slidePageView buildUI];
}

- (void)becomeListed {
    NSDate *lastRefreshTime = [[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey];
    if (self.isResetCondition || self.needRefresh || !self.bannerList.count || !lastRefreshTime || [lastRefreshTime timeIntervalSinceNow] < -appRefreshTime) {
        [self doGetBannerListFunction];
    }
}

- (void)doGetBannerListFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type" : @"1"}];
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
        _slidePageView = [[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, self.adHeadView.bottom + kEdge, self.view.width, self.view.height - (self.adHeadView.bottom + kEdge)) withHeightOfTop:88.0];
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

- (UIImage *)normalImageNameOfTab:(NSUInteger)index {
    NSDictionary *dic = self.viewArray[index];
    
    CGFloat radius = 50.0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 60, radius, radius)];
    imageView.image = [UIImage imageNamed:@"icon_classify_tab_title_back"];
    
    UIImage *m_image = [UIImage imageNamed:dic[@"image"]];
    CGSize m_size = m_image.size;
    UIImageView *subImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.6 * radius, 0.6 * radius * m_size.height / m_size.width)];
    subImageView.image = m_image;
    subImageView.center = CGPointMake(0.5 * imageView.width, 0.5 * imageView.height);
    [imageView addSubview:subImageView];
    
    return [UIImage imageFromView:imageView];
}

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view {
    return self.viewArray.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number {
    NSDictionary *dic = self.viewArray[number];
    return dic[@"VC"];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number {
    NSDictionary *dic = self.viewArray[number];
    PublicViewController *listVC = dic[@"VC"];
    if ([listVC respondsToSelector:@selector(becomeListed)]) {
        [listVC performSelector:@selector(becomeListed)];
    }
    
    [self.slidePageView showRedPoint:NO withIndex:number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didunselectTab:(NSUInteger)number {
    NSDictionary *dic = self.viewArray[number];
    PublicViewController *listVC = dic[@"VC"];
    if ([listVC respondsToSelector:@selector(becomeUnListed)]) {
        [listVC performSelector:@selector(becomeUnListed)];
    }
}

@end
