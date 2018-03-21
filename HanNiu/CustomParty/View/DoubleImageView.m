//
//  DoubleImageView.m
//  HanNiu
//
//  Created by 7kers on 2018/3/21.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "DoubleImageView.h"

@implementation DoubleImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.showImageView];
    }
    return self;
}

- (void)adjustShowImageViewWithScale:(CGFloat)scale {
    self.showImageView.width = scale * self.width;
    self.showImageView.height = scale * self.height;
    self.showImageView.center = CGPointMake(0.5 * self.width, 0.5 * self.height);
}

@end
