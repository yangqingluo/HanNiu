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

@end
