//
//  MainTabNavController.m
//  HanNiu
//
//  Created by 7kers on 2018/1/15.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "MainTabNavController.h"
#import "AccountViewController.h"

@interface MainTabNavController ()

@end

@implementation MainTabNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 22, 24)];
    [btn setImage:[UIImage imageNamed:@"main_me_icon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(accountButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationBar addSubview:btn];
    self.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation_bar_back"]];
}

- (void)accountButtonAction {
    AccountViewController *vc = [AccountViewController new];
    [self pushViewController:vc animated:YES];
}

@end
