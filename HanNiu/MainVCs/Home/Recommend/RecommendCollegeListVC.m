//
//  RecommendCollegeListVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/5.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "RecommendCollegeListVC.h"

@interface RecommendCollegeListVC ()

@end

@implementation RecommendCollegeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐学校";
    
    self.tableView.height = screen_height - TAB_BAR_HEIGHT - self.navigationBarView.bottom;
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type" : @"1"}];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Featured/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:[AppBasicMusicDetailInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
        }
        [weakself updateSubviews];
    }];
}

@end
