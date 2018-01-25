//
//  PublicPlayBar.m
//  HanNiu
//
//  Created by 7kers on 2018/1/25.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicPlayBar.h"

@implementation PublicPlayBar

static PublicPlayBar *_singleShare = nil;
+ (PublicPlayBar *)getInstance {
    @synchronized([PublicPlayBar class]){
        if(!_singleShare)
            _singleShare = [[self alloc] init];
        return _singleShare;
    }
    return nil;
}

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, screen_width, TAB_BAR_HEIGHT)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _playBtn = NewButton(CGRectMake(0, 0, 40, 40), nil, nil, nil);
        _playBtn.center = CGPointMake(0.5 * self.width, 0.5 * self.height);
        [_playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateSelected];
        [self addSubview:_playBtn];
    }
    return self;
}

@end
