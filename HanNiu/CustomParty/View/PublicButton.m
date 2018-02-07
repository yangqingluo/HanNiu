//
//  PublicButton.m
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicButton.h"

#define edge_scale 0.7
@implementation PublicButton

- (void)dealloc {
    [self.showLabel removeObserver:self forKeyPath:@"text"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.edgeInTextImage = kEdge;
        
        self.showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, frame.size.width - 15, edge_scale * frame.size.height)];
        [self addSubview:self.showImageView];
        
        _showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, edge_scale * frame.size.height, frame.size.width, (1 - edge_scale) * frame.size.height)];
        self.showLabel.textColor = [UIColor whiteColor];
        self.showLabel.font = [UIFont systemFontOfSize:12.0];
        self.showLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.showLabel];
        
        [self.showLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

- (void)startAnimation {
    self.enabled = NO;
    
    CABasicAnimation * transformRoate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    transformRoate.byValue = [NSNumber numberWithDouble:(2 * M_PI)];
    transformRoate.duration = 1;
    transformRoate.repeatCount = MAXFLOAT;
    [self.showImageView.layer addAnimation:transformRoate forKey:@"rotationAnimation"];
}

- (void)stopAnimation {
    self.enabled = YES;
    
    [self.showImageView.layer removeAllAnimations];
}

- (void)adjustTextAndImage {
    [AppPublic adjustLabelWidth:self.showLabel];
    if (self.positionStyle == PublicButtonPSMiddleTextLeftImageRight) {
        self.showLabel.center = CGPointMake(0.5 * self.width - 0.5 * self.showImageView.width, 0.5 * self.height);
        
        self.showImageView.center = CGPointMake(self.showLabel.right + self.edgeInTextImage + 0.5 * self.showImageView.width, 0.5 * self.height);
    }
    else if (self.positionStyle == PublicButtonPSMiddleTextRightImageLeft) {
        self.showLabel.center = CGPointMake(0.5 * self.width + 0.5 * self.showImageView.width, 0.5 * self.height);
        
        self.showImageView.center = CGPointMake(self.showLabel.left - self.edgeInTextImage - 0.5 * self.showImageView.width, 0.5 * self.height);
    }
    else if (self.positionStyle == PublicButtonPSMiddleTextUpImageDown) {
        self.showLabel.center = CGPointMake(0.5 * self.width, 0.5 * self.height);
        self.showImageView.width = self.showLabel.width + 25;
        self.showImageView.height = self.showLabel.height + 8;
        
        self.showImageView.center = self.showLabel.center;
    }
    else if (self.positionStyle == PublicButtonPSLeftTextRightImageLeft) {
        self.showImageView.left = 0;
        self.showImageView.centerY = 0.5 * self.height;
        self.showLabel.left = self.showImageView.right + self.edgeInTextImage;
        self.showLabel.centerY = self.showImageView.centerY;
    }
    else if (self.positionStyle == PublicButtonPSRightTextLeftImageRight) {
        self.showImageView.right = self.width;
        self.showImageView.centerY = 0.5 * self.height;
        self.showLabel.right = self.showImageView.left - self.edgeInTextImage;
        self.showLabel.centerY = self.showImageView.centerY;
    }
}

#pragma kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"text"]) {
        if (self.autoAdjust) {
            [self adjustTextAndImage];
        }
    }
}

#pragma setter
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.showLabel.highlighted = selected;
    self.showImageView.highlighted = selected;
}

@end
