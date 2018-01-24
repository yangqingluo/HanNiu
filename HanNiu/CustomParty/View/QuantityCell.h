//
//  QuantityCell.h
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicTableViewCell.h"
#import "PublicButton.h"

@interface QuantityCell : PublicTableViewCell

@property (strong, nonatomic) PublicButton *playBtn;
@property (strong, nonatomic) PublicButton *messageBtn;
@property (strong, nonatomic) PublicButton *timeBtn;

@property (strong, nonatomic) AppQualityInfo *data;

@end
