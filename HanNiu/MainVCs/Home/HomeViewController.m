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
    
//    self.title = @"";
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [btn setImage:[UIImage imageNamed:@"main_me_icon"] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn addTarget:self action:@selector(accountButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:btn];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    leftView.clipsToBounds = NO;
    [leftView addSubview:btn];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItems = @[leftItem];
    
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(-20, 5, screen_width - 2 * kEdgeToScreen, 30)];
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    [titleView addSubview:searchField];
    [self.navigationItem setTitleView:titleView];
}

- (void)accountButtonAction {
    AccountViewController *vc = [AccountViewController new];
    [self doPushViewController:vc animated:YES];
}

@end
