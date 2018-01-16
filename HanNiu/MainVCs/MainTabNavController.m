//
//  MainTabNavController.m
//  HanNiu
//
//  Created by 7kers on 2018/1/15.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "MainTabNavController.h"

@interface MainTabNavController ()

@end

@implementation MainTabNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation_bar_back"]];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar_back"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.tintColor = [UIColor whiteColor];
    
//    最近iOS项目中要求导航栏的返回按钮只保留那个箭头，去掉后边的文字，在网上查了一些资料，最简单且没有副作用的方法就是
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];

}

@end
