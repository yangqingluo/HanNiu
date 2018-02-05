//
//  PublicThreeImageButtonCell.h
//  HanNiu
//
//  Created by 7kers on 2018/2/5.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Event_PublicThreeImageButtonCellButtonClicked @"Event_PublicThreeImageButtonCellButtonClicked"

@interface PublicThreeImageButtonCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSArray *data;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
