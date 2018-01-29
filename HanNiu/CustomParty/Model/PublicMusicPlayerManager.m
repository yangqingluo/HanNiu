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

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createRemoteCommandCenter];
    }
    return self;
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

#pragma mark - 锁屏界面开启和监控远程控制事件
- (void)createRemoteCommandCenter {
    //官方文档：https://developer.apple.com/documentation/mediaplayer/mpremotecommandcenter
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    // MPFeedbackCommand对象反映了当前App所播放的反馈状态. MPRemoteCommandCenter对象提供feedback对象用于对媒体文件进行喜欢, 不喜欢, 标记的操作. 效果类似于网易云音乐锁屏时的效果
    
    //    //添加喜欢按钮
    //    MPFeedbackCommand *likeCommand = commandCenter.likeCommand;
    //    likeCommand.enabled = YES;
    //    likeCommand.localizedTitle = @"喜欢";
    //    [likeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
    //        NSLog(@"喜欢");
    //        return MPRemoteCommandHandlerStatusSuccess;
    //    }];
    
    //    //添加不喜欢按钮，这里用作“下一首”
    //    MPFeedbackCommand *dislikeCommand = commandCenter.dislikeCommand;
    //    dislikeCommand.enabled = YES;
    //    dislikeCommand.localizedTitle = @"下一首";
    //    [dislikeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
    //        NSLog(@"下一首");
    //        [self nextButtonAction:nil];
    //        return MPRemoteCommandHandlerStatusSuccess;
    //    }];
    
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self.player pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self.player play];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    //    // 远程控制上一曲
    //    [commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
    //        NSLog(@"上一曲");
    //        return MPRemoteCommandHandlerStatusSuccess;
    //    }];
    //
    //    // 远程控制下一曲
    //    [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
    //        NSLog(@"下一曲");
    //        [self nextButtonAction:nil];
    //        return MPRemoteCommandHandlerStatusSuccess;
    //    }];
    //
    //
    //    //快进
    //    MPSkipIntervalCommand *skipBackwardIntervalCommand = commandCenter.skipForwardCommand;
    //    skipBackwardIntervalCommand.preferredIntervals = @[@(54)];
    //    skipBackwardIntervalCommand.enabled = YES;
    //    [skipBackwardIntervalCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
    //
    //        NSLog(@"你按了快进按键！");
    //
    //        // 歌曲总时间
    //        CMTime duration = musicPlayer.player.currentItem.asset.duration;
    //        Float64 completeTime = CMTimeGetSeconds(duration);
    //
    //        // 快进10秒
    //        _songSlider.value = _songSlider.value + 10 / completeTime;
    //
    //        // 计算快进后当前播放时间
    //        Float64 currentTime = (Float64)(_songSlider.value) * completeTime;
    //
    //        // 播放器定位到对应的位置
    //        CMTime targetTime = CMTimeMake((int64_t)(currentTime), 1);
    //        [musicPlayer.player seekToTime:targetTime];
    //
    //        return MPRemoteCommandHandlerStatusSuccess;
    //    }];
    
    //在控制台拖动进度条调节进度（仿QQ音乐的效果）
    [commandCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        CMTime totlaTime = self.player.currentItem.duration;
        MPChangePlaybackPositionCommandEvent * playbackPositionEvent = (MPChangePlaybackPositionCommandEvent *)event;
        [self.player seekToTime:CMTimeMake(totlaTime.value * playbackPositionEvent.positionTime / CMTimeGetSeconds(totlaTime), totlaTime.timescale) completionHandler:^(BOOL finished) {
        }];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    
}

@end
