//
//  HomeViewController.m
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "HomeViewController.h"
#import "AccountViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 24)];
    [btn setImage:[UIImage imageNamed:@"main_me_icon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(accountButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:btn];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:leftItem animated:YES];
    
}

- (void)accountButtonAction {
    AccountViewController *vc = [AccountViewController new];
//    vc.hidesBottomBarWhenPushed = YES;
    [self doPushViewController:vc animated:YES];
}

@end
