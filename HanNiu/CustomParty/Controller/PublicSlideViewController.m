//
//  PublicSlideViewController.m
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicSlideViewController.h"

@interface PublicSlideViewController ()

@end

@implementation PublicSlideViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (NSDictionary *m_dic in self.viewArray) {
        PublicViewController *vc = m_dic[@"VC"];
        if (vc) {
            if (self.slidePageView.superview) {
                if ([self.viewArray indexOfObject:m_dic] == self.slidePageView.selectedIndex) {
                    [vc viewWillAppear:animated];
                }
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.slidePageView];
    [self.slidePageView buildUI];
}

- (void)addViewController:(NSString *)title vc:(PublicViewController *)vc {
    vc.parentVC = self;
    [self.viewArray addObject:@{@"title" : title, @"VC" : vc}];
}

#pragma mark - getter
- (QCSlideSwitchView *)slidePageView{
    if (!_slidePageView) {
        _slidePageView = [[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.bottom, self.view.width, self.view.height - self.navigationBarView.bottom)];
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

- (NSMutableArray *)viewArray {
    if (!_viewArray) {
        _viewArray = [NSMutableArray new];
    }
    return _viewArray;
}

#pragma mark - QCSlider
- (CGFloat)widthOfTab:(NSUInteger)index{
    return self.view.bounds.size.width / self.viewArray.count;
}
- (NSString *)titleOfTab:(NSUInteger)index{
    NSDictionary *dic = self.viewArray[index];
    return dic[@"title"];
}

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view{
    return self.viewArray.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number{
    NSDictionary *dic = self.viewArray[number];
    return dic[@"VC"];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number{
    NSDictionary *dic = self.viewArray[number];
    PublicViewController *listVC = dic[@"VC"];
    listVC.isListed = YES;
    if ([listVC respondsToSelector:@selector(becomeListed)]) {
        [listVC performSelector:@selector(becomeListed)];
    }
    
    [self.slidePageView showRedPoint:NO withIndex:number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didunselectTab:(NSUInteger)number{
    NSDictionary *dic = self.viewArray[number];
    PublicViewController *listVC = dic[@"VC"];
    listVC.isListed = NO;
    if ([listVC respondsToSelector:@selector(becomeUnListed)]) {
        [listVC performSelector:@selector(becomeUnListed)];
    }
}

@end
