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
} PublicButtonPositionStyle;

@interface PublicButton : UIButton

@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UILabel *showLabel;

@property (nonatomic, assign) PublicButtonPositionStyle positionStyle;
@property (nonatomic, assign) BOOL autoAdjust;
@property (nonatomic, assign) double edgeInTextImage;//图片和文本的间距

- (void)startAnimation;
- (void)stopAnimation;
- (void)adjustTextAndImage;

@end
