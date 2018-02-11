//
//  SchoolDetailVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/4.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "SchoolDetailVC.h"
#import "PublicSlideSubVC.h"

@interface SchoolDetailVC ()

@end

@implementation SchoolDetailVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        [self addViewController:@"简介" vc:[PublicSlideSubVC new]];
        [self addViewController:@"本科专业" vc:[PublicSlideSubVC new]];
        [self addViewController:@"精品收听" vc:[PublicSlideSubVC new]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.data.Name;
}

- (void)initializeNavigationBar {
    [self createNavWithTitle:self.title createMenuItem:^UIView *(int nIndex) {
        if (nIndex == 0) {
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1) {
            UIButton *btn = NewRightButton([UIImage imageNamed:@"icon_back_to_mainview"], nil);
            btn.frame = CGRectMake(screen_width - 44, 0, 44, DEFAULT_BAR_HEIGHT);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [btn addTarget:self action:@selector(homeButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 2) {
            UIButton *btn = NewRightButton([UIImage imageNamed:@"icon_share"], nil);
            btn.frame = CGRectMake(screen_width - 2 * 44, 0, 44, DEFAULT_BAR_HEIGHT);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
            [btn addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)shareButtonAction {
    [self addViewController:@"专科专业" vc:[PublicSlideSubVC new]];
    [self.slidePageView buildUI];
}

@end
