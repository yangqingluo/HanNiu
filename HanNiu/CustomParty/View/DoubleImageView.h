//
//  DoubleImageView.h
//  HanNiu
//
//  Created by 7kers on 2018/3/21.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleImageView : UIImageView

@property (strong, nonatomic) UIImageView *showImageView;

- (void)adjustShowImageViewWithScale:(CGFloat)scale;

@end
