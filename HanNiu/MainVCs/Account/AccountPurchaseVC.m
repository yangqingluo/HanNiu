//
//  AccountPurchaseVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/22.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AccountPurchaseVC.h"

@interface AccountPurchaseVC ()

@end

@implementation AccountPurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的购买";
    
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{}];
    //    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Music/Buy" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself.dataSource removeAllObjects];
            [weakself.dataSource addObjectsFromArray:[AppQualityInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
        }
        [weakself updateSubviews];
    }];
}

@end
