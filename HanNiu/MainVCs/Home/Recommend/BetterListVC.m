//
//  BetterListVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/5.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "BetterListVC.h"
#import "MusicDetailVC.h"

#import "QualityCell.h"

@interface BetterListVC ()

@end

@implementation BetterListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐精品";
    self.tableView.tableHeaderView = nil;
    self.tableView = nil;
    self.tableView.frame = CGRectMake(0, self.navigationBarView.bottom, screen_width, screen_height - TAB_BAR_HEIGHT - self.navigationBarView.bottom);
    [self.view addSubview:self.tableView];
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)initializeNavigationBar {
    [self createNavWithTitle:self.title createMenuItem:^UIView *(int nIndex) {
        if (nIndex == 0) {
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type" : @"2"}];
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
