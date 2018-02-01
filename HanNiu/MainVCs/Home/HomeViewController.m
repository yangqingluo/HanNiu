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
#import "HomeRecommendVC.h"
#import "HomeClassifyVC.h"
#import "HomeBetterVC.h"
#import "HomeJobVC.h"
#import "HomeSchoolAndCompanyVC.h"

#import "PublicBarTextField.h"
#import "QCSlideSwitchView.h"

@interface HomeViewController ()<UITextFieldDelegate>

@end

@implementation HomeViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addViewController:@"推荐" vc:[[HomeRecommendVC alloc] initWithCollectionSectionInset:UIEdgeInsetsMake(0, kEdgeMiddle, 0, kEdgeMiddle)]];
        [self addViewController:@"分类" vc:[HomeClassifyVC new]];
        [self addViewController:@"纷声" vc:[HomeBetterVC new]];
        [self addViewController:@"就业" vc:[[HomeJobVC alloc] initWithCollectionRowCount:4 cellHeight:38.0 sectionInset:UIEdgeInsetsMake(0, kEdgeSmall, 0, kEdgeSmall)]];
        [self addViewController:@"校&企" vc:[[HomeSchoolAndCompanyVC alloc] initWithParentVC:self]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slidePageView.height = screen_height - self.navigationBarView.bottom - TAB_BAR_HEIGHT;
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
            PublicBarTextField *searchTextField = [[PublicBarTextField alloc] initWithFrame:CGRectMake(STATUS_BAR_HEIGHT, 7, screen_width - 2 * STATUS_BAR_HEIGHT, 30)];
            [searchTextField resetLeftView];
            searchTextField.backgroundColor = [UIColor whiteColor];
            searchTextField.placeholder = @"搜索您感兴趣的内容";
            searchTextField.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
            searchTextField.borderStyle = UITextBorderStyleNone;
            searchTextField.layer.cornerRadius = 0.5 * searchTextField.bounds.size.height;
            searchTextField.delegate = self;
            return searchTextField;
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
