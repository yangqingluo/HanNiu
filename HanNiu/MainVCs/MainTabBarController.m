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
        CGRect frame = CGRectMake(0, self.tabBar.frame.origin.y - (TAB_BAR_HEIGHT - DEFAULT_TAB_BAR_HEIGHT), self.tabBar.frame.size.width, TAB_BAR_HEIGHT);
        self.tabBar.frame = frame;
    });
}

@end
