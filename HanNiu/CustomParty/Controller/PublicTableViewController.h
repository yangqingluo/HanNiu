//
//  PublicTableViewController.h
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicViewController.h"

@interface PublicTableViewController : PublicViewController<UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithStyle:(UITableViewStyle)style;

@property (nonatomic, strong) UITableView *tableView;

@end
