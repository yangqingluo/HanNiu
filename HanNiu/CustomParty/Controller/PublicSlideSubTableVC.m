//
//  PublicSlideSubTableVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicSlideSubTableVC.h"

@interface PublicSlideSubTableVC ()

@end

@implementation PublicSlideSubTableVC

- (instancetype)initWithStyle:(UITableViewStyle)style parentVC:(PublicViewController *)pVC andIndexTag:(NSInteger)index {
    self = [super initWithStyle:style];
    if (self) {
        self.indextag = index;
        self.parentVC = pVC;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
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
