//
//  PublicCollectionHeaderTitleView.m
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicCollectionHeaderTitleView.h"

@implementation PublicCollectionHeaderTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kEdgeMiddle, 0, 2, 14)];
        leftImageView.centerY = 0.5 * self.height;
        leftImageView.image = [UIImage imageNamed:@"icon_text_header"];
        [self addSubview:leftImageView];
        
        UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - kEdgeMiddle - 9, 0, 9, 18)];
        rightImageView.centerY = 0.5 * self.height;
        rightImageView.image = [UIImage imageNamed:@"icon_right_arrow"];
        [self addSubview:rightImageView];
        
        _titleLabel = NewLabel(CGRectMake(leftImageView.right + kEdgeMiddle, 0,  rightImageView.left - leftImageView.right - 2 * kEdgeMiddle, self.height), nil, nil, NSTextAlignmentLeft);
        [self addSubview:_titleLabel];
    }
    return self;
}

@end
