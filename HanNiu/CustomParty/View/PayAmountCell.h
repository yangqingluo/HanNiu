//
//  PayAmountCell.h
//  HanNiu
//
//  Created by 7kers on 2018/2/15.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicTableViewCell.h"
#import "PublicButton.h"

@interface PublicSelectButton : PublicButton

@property (strong, nonatomic) UILabel *subTitleLabel;

@end


@interface PayAmountCell : PublicTableViewCell

@property (strong, nonatomic) NSMutableArray *buttonArray;

@end
