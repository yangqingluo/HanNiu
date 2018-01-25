//
//  PublicBarTextFiled.m
//  HanNiu
//
//  Created by 7kers on 2018/1/22.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicBarTextField.h"

@implementation PublicBarTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 设置背景
//        self.background = [UIImage stretchableImageNamed:@"searchbar_textfield_background"];
        // 设置左边的view
//        [self setLeftView];
        // 设置右边的录音按钮
//        [self setRightView];
    }
    return self;
}

- (instancetype)init {
    // 设置frame
    CGFloat width = screen_width - 90 - 85;
    CGFloat height = 30;
    CGFloat X = 90;
    CGFloat Y = 7;
    CGRect frame = CGRectMake(X, Y, width, height);
    
    return [self initWithFrame:frame];
}

// 设置左边的view
- (void)resetLeftView {
    // initWithImage:默认UIImageView的尺寸跟图片一样
    //    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-icon-"]];
    //    leftImageView.centerX += 10;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    [leftButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    leftButton.userInteractionEnabled = NO;
    
    self.leftView = leftButton;
    self.leftViewMode = UITextFieldViewModeAlways;
}

// 设置右边的view
- (void)setRightView {
    // 创建按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"audio_nav_icon"] forState:UIControlStateNormal];
    [rightButton sizeToFit];
    // 将imageView宽度
    rightButton.width += 10;
    //居中
    rightButton.contentMode = UIViewContentModeCenter;
    
    self.rightView = rightButton;
    self.rightViewMode = UITextFieldViewModeAlways;
}

@end
