//
//  CompanyDetailVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/5.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "CompanyDetailVC.h"
#import "CompanyIntroduceSubVC.h"
#import "CompanyJobListSubVC.h"

@interface CompanyDetailVC ()

@end

@implementation CompanyDetailVC

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViewController:@"企业简介" vc:[[CompanyIntroduceSubVC alloc] initWithParentVC:self]];
        [self addViewController:@"岗位需求" vc:[[CompanyJobListSubVC alloc] initWithParentVC:self]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.data.Name;
    
    self.slidePageView.height = screen_height - self.navigationBarView.bottom - TAB_BAR_HEIGHT;
}

@end
