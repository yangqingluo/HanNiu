//
//  PublicAlertView.m
//  HanNiu
//
//  Created by 7kers on 2018/1/22.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicAlertView.h"

@interface PublicAlertView ()

@end

@implementation PublicAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.6);
    }
    return self;
}

- (instancetype)initWithContentView:(UIView *)contentView {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        //        self.userInteractionEnabled = YES;
        //        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        //        [self addGestureRecognizer:tapGesture];
        [self addSubview:contentView];
    }
    return self;
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)show {
    [[AppPublic getInstance].topViewController.view addSubview:self];
}

@end
