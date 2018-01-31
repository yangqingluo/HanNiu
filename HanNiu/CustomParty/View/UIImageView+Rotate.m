//
//  UIImageView+Rotate.m
//  HanNiu
//
//  Created by 7kers on 2018/1/30.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "UIImageView+Rotate.h"

static NSString *rotate_key = @"app_key_rotate";

@implementation UIImageView (Rotate)

- (void)addRotateAnimationForKey:(NSString *)key {
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];   // 旋转一周
    rotateAnimation.duration = 20.0;                                 // 旋转时间20秒
    rotateAnimation.repeatCount = MAXFLOAT;                          // 重复次数，这里用最大次数
    [self.layer addAnimation:rotateAnimation forKey:key];
}

- (void)startRotating {
    if (![self.layer animationForKey:rotate_key]) {
        [self addRotateAnimationForKey:rotate_key];
    }
    CFTimeInterval pausedTime = self.layer.timeOffset;
    self.layer.speed = 1.0;                                         // 开始旋转
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;                                             // 恢复时间
    self.layer.beginTime = timeSincePause;                          // 从暂停的时间点开始旋转
}

- (void)stopRotating {
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;                                          // 停止旋转
    self.layer.timeOffset = pausedTime;                              // 保存时间，恢复旋转需要用到
}

- (void)recoverRotating {
    if ([self.layer animationForKey:rotate_key]) {
        [self.layer removeAnimationForKey:rotate_key];
    }
}

@end
