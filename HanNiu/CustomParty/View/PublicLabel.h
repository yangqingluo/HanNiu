//
//  PublicLabel.h
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    VerticalAlignmentMiddle = 0, // default
    VerticalAlignmentTop,
    VerticalAlignmentBottom,
} VerticalAlignment;
@interface PublicLabel : UILabel

@property (nonatomic) VerticalAlignment verticalAlignment;

@end


@interface PublicSubTitleView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;

@end
