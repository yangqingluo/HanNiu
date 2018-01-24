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
        
        _playBtn = NewButton(CGRectMake(0, kEdgeMiddle, 33, 33), nil, nil, nil);
        _playBtn.centerX = 0.5 * self.width;
        [_playBtn setImage:[UIImage imageNamed:@"icon_play_big"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"icon_pause_big"] forState:UIControlStateSelected];
        [self addSubview:_playBtn];
    }
    return self;
}

@end
