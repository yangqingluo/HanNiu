//
//  PublicPlayView.m
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicPlayView.h"

@implementation PublicPlayView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, screen_width, 2 * TAB_BAR_HEIGHT)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _playBtn = NewButton(CGRectMake(0, kEdgeMiddle, 40, 40), nil, nil, nil);
        _playBtn.centerX = 0.5 * self.width;
        [_playBtn setImage:[UIImage imageNamed:@"icon_play_big"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"icon_pause_big"] forState:UIControlStateSelected];
        [self addSubview:_playBtn];
        
        _lastBtn = NewButton(CGRectMake(0, 0, 30, 30), nil, nil, nil);
        _lastBtn.centerY = _playBtn.centerY;
        _lastBtn.right = _playBtn.left - kEdgeMiddle;
        [_lastBtn setImage:[UIImage imageNamed:@"icon_prev_music"] forState:UIControlStateNormal];
        [self addSubview:_lastBtn];
        
        _nextBtn = NewButton(_lastBtn.frame, nil, nil, nil);
        _nextBtn.left = _playBtn.right + kEdgeMiddle;
        [_nextBtn setImage:[UIImage imageNamed:@"icon_next_music"] forState:UIControlStateNormal];
        [self addSubview:_nextBtn];
        
        _progressSlider = [[PublicSlider alloc] initWithFrame:CGRectMake(0, 0 , self.width, 20)];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"icon_seekbar_thumb"] forState:UIControlStateNormal];
        _progressSlider.tintColor = appMainColor;
        [self addSubview:_progressSlider];
        _progressSlider.value = 0.5;
        
        
//        for (UIGestureRecognizer *gesture in _progressSlider.gestureRecognizers) {
//            [[AppPublic getInstance].topViewController.navigationController.interactivePopGestureRecognizer requireGestureRecognizerToFail:gesture];
//        }
    }
    return self;
}

@end
