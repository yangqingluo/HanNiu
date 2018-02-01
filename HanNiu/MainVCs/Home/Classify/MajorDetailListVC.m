//
//  MajorDetailListVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/1.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "MajorDetailListVC.h"

@interface MajorDetailListVC ()

@end

@implementation MajorDetailListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.thirdMajorData.ThirdTag;
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"tag" : self.thirdMajorData.Id}];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"MajorDict/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:[AppMajorInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
        }
        [weakself updateSubviews];
    }];
}

@end
