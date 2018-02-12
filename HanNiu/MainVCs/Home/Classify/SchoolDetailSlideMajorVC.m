//
//  SchoolDetailSlideMajorVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/11.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "SchoolDetailSlideMajorVC.h"
#import "MusicDetailVC.h"

#import "QualityCell.h"

@interface SchoolDetailSlideMajorVC ()

@end

@implementation SchoolDetailSlideMajorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [QualityCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"select_cell";
    QualityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[QualityCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.data = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [[AppPublic getInstance] goToMusicVC:self.dataSource[indexPath.row] list:nil type:PublicMusicDetailFromMajor];
}

@end
