//
//  HomeViewController.m
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "HomeViewController.h"
#import "AccountViewController.h"
#import "HomeSearchVC.h"

#import "PublicBarTextFiled.h"

@interface HomeViewController ()<UITextFieldDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"";
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, DEFAULT_BAR_HEIGHT)];
    [btn setImage:[UIImage imageNamed:@"main_me_icon"] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn addTarget:self action:@selector(accountButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:btn];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, DEFAULT_BAR_HEIGHT)];
    leftView.clipsToBounds = NO;
    [leftView addSubview:btn];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItems = @[leftItem];
    
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 7, screen_width - 2 * kEdgeToScreen, 30)];
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, DEFAULT_BAR_HEIGHT)];
    [titleView addSubview:searchField];
    [self.navigationItem setTitleView:titleView];
}

- (void)initializeNavigationBar {
    [self createNavWithTitle:self.title createMenuItem:^UIView *(int nIndex) {
        if (nIndex == 0) {
            UIButton *btn = NewBackButton(nil);
            [btn setImage:[UIImage imageNamed:@"main_me_icon"] forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            [btn addTarget:self action:@selector(accountButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1) {
            UIButton *btn = NewRightButton([UIImage imageNamed:@"main_msg_icon"], nil);
            [btn addTarget:self action:@selector(messageButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 2) {
            PublicBarTextFiled *searchTextFiled = [[PublicBarTextFiled alloc] initWithFrame:CGRectMake(STATUS_BAR_HEIGHT, 7, screen_width - 2 * STATUS_BAR_HEIGHT, 30)];
            searchTextFiled.backgroundColor = [UIColor whiteColor];
            searchTextFiled.placeholder = @"搜索您感兴趣的内容";
            searchTextFiled.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
            searchTextFiled.borderStyle = UITextBorderStyleNone;
            searchTextFiled.layer.cornerRadius = 0.5 * searchTextFiled.bounds.size.height;
            searchTextFiled.delegate = self;
            return searchTextFiled;
        }
        return nil;
    }];
}

- (void)accountButtonAction {
    AccountViewController *vc = [AccountViewController new];
    [self doPushViewController:vc animated:YES];
}

- (void)messageButtonAction {
    
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    HomeSearchVC *vc = [HomeSearchVC new];
    [self doPushViewController:vc animated:YES];
    return NO;
}

@end
