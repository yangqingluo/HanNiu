//
//  PublicMusicPlayerManager.m
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicMusicPlayerManager.h"

@implementation PublicMusicPlayerManager

static PublicMusicPlayerManager *_sharedManager = nil;
+ (PublicMusicPlayerManager *)getInstance {
    @synchronized([PublicMusicPlayerManager class]){
        if(!_sharedManager)
            _sharedManager = [[self alloc] init];
        return _sharedManager;
    }
    return nil;
}

#pragma mark - public
- (void)resetPlayItem:(NSString *)songURLString {
    _playItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:songURLString]];
}

- (void)resetPlayer {
    _player = [[AVPlayer alloc] initWithPlayerItem:_playItem];
}

- (void)startPlay {
    [_player play];
}

- (void)stopPlay {
    [_player pause];
}

- (void)play:(NSString *)songURLString {
    [self resetPlayItem:songURLString];
    [self resetPlayer];
    [self startPlay];
}

@end
