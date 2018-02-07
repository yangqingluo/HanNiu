//
//  PublicButton.h
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PublicButtonPSMiddleTextLeftImageRight = 0, // default
    PublicButtonPSMiddleTextRightImageLeft,
    PublicButtonPSMiddleTextUpImageDown,
    PublicButtonPSLeftTextRightImageLeft,
    PublicButtonPSRightTextLeftImageRight,
} PublicButtonPositionStyle;

@interface PublicButton : UIButton

@property (strong, nonatomic) UIImageView *showImageView;
@property (strong, nonatomic, readonly) UILabel *showLabel;

@property (assign, nonatomic) PublicButtonPositionStyle positionStyle;
@property (assign, nonatomic) BOOL autoAdjust;
@property (assign, nonatomic) double edgeInTextImage;//图片和文本的间距

- (void)startAnimation;
- (void)stopAnimation;
- (void)adjustTextAndImage;

@end
