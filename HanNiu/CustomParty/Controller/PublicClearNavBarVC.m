//
//  PublicClearNavBarVC.m
//  HanNiu
//
//  Created by 7kers on 2018/3/19.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicClearNavBarVC.h"

@interface PublicClearNavBarVC ()

@end

@implementation PublicClearNavBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initializeNavigationBar {
    UIColor *color = [UIColor whiteColor];
    [self createNavWithTitle:self.title createMenuItem:^UIView *(int nIndex) {
        if (nIndex == 0) {
            UIButton *btn = NewBackButton(color);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
    self.titleLabel.textColor = color;
    if (color) {
        self.navigationBarView.backgroundColor = [UIColor clearColor];
        self.shadowLine.hidden = YES;
        self.view.backgroundColor = appMainColor;
    }
}

@end
