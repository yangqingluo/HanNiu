//
//  PublicCollectionButtonCell.m
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicCollectionButtonCell.h"

@implementation PublicCollectionButtonCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _button = NewButton(CGRectMake(0, kEdgeSmall, self.contentView.width, self.contentView.height - 2 * kEdgeSmall), @"", appTextColor, [AppPublic appFontOfSize:appButtonTitleFontSizeLittle]);
        [_button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageWithColor:appMainColor] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_button];
        [AppPublic roundCornerRadius:_button cornerRadius:appButtonCornerRadius];
        _button.layer.borderColor = appSeparatorColor.CGColor;
        _button.layer.borderWidth = 1.0;
    }
    return self;
}

@end
