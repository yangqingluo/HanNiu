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
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 22, 24)];
    [btn setImage:[UIImage imageNamed:@"main_me_icon"] forState:UIControlStateNormal];
    
    [self.navigationBar addSubview:btn];
    self.navigationBar.barTintColor = [UIColor colorWithRed:0xff / 255.0 green:0x69 / 255.0 blue:0x45 / 255.0 alpha:1.0];
}

@end
