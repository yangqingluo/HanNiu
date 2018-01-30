//
//  MainTabBarController.m
//  HanNiu
//
//  Created by 7kers on 2018/1/15.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "MainTabBarController.h"

#import "PublicPlayBar.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    
    [self.tabBar addSubview:[PublicPlayBar getInstance]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect frame = CGRectMake(0
                                  , self.tabBar.frame.origin.y - (TAB_BAR_HEIGHT - DEFAULT_TAB_BAR_HEIGHT)
                                  , self.tabBar.frame.size.width
                                  , TAB_BAR_HEIGHT);
        
        self.tabBar.frame = frame;
        
        NSLog(@"%lf, %lf, %lf, %lf,", self.tabBar.frame.origin.x, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
        
        //        self.tabBar.backgroundColor = [UIColor redColor];
        
//        WDYTabbar *wDYTabbar = [[WDYTabbar alloc] initWithFrame:self.tabBar.bounds];
//
//        //添加五个按钮
//
//        [wDYTabbar addTabbarBtnWithNormalImg:@"lights0" selImg:@"lights1"];
//
//        [wDYTabbar addTabbarBtnWithNormalImg:@"aircon0" selImg:@"aircon1"];
//
//        [wDYTabbar addTabbarBtnWithNormalImg:@"service0" selImg:@"service1"];
//
//        [wDYTabbar addTabbarBtnWithNormalImg:@"setting0" selImg:@"setting1"];
//        
//        //设置代理
//
//        wDYTabbar.delegate = self;
//
//        //把自定义的tabbar添加到 系统的tabbar上
//
//        [self.tabBar addSubview:wDYTabbar];
        
    });
    
}

@end
