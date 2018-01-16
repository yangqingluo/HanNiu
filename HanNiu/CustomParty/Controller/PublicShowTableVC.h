//
//  PublicShowTableVC.h
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicTableViewController.h"

@interface PublicShowTableVC : PublicTableViewController

@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) NSString *dateKey;
@property (assign, nonatomic) NSInteger indextag;
@property (assign, nonatomic) BOOL isResetCondition;


- (void)updateTableViewHeader;
- (void)updateTableViewFooter;
- (void)beginRefreshing;
- (void)endRefreshing;
- (void)updateSubviews;
- (void)loadFirstPageData;
- (void)loadMoreData;
- (void)pullBaseListData:(BOOL)isReset;

@end
