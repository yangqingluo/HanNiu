//
//  PublicMusicPlayerManager.m
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <notify.h>
#import "PublicMusicPlayerManager.h"

@interface PublicMusicPlayerManager ()

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) id playerTimeObserver;

@end

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
        // 播放结束通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlayToEndTime) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [self createRemoteCommandCenter];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)postNotificationName:(NSString *)name object:(id)anObject{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:anObject];
    });
}

- (void)clearPlayerTimeObserver {
    if (_playerTimeObserver) {
        @try {
            [_player removeTimeObserver:_playerTimeObserver];
            _playerTimeObserver = nil;
        } @catch(id anException) {
            
        }

        [_player.currentItem cancelPendingSeeks];
        [_player.currentItem.asset cancelLoading];
    }
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

#pragma mark - public
- (void)startPlay {
    [_player play];
    [self clearPlayerTimeObserver];
    
    // 设置Observer更新播放进度
    QKWEAKSELF;
    _playerTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CMTime total = weakself.player.currentItem.duration;
        AppTime *m_time = [AppTime new];
        m_time.totalTime = CMTimeGetSeconds(total);
        m_time.currentTime = CMTimeGetSeconds(time);
        [weakself postNotificationName:kNotifi_Play_TimeObserver object:m_time];
    }];
}

- (void)stopPlay {
    [_player pause];
    [self clearPlayerTimeObserver];
}

- (void)resetPlay:(AppQualityInfo *)quality {
    if (!quality.Music.Id) {
        return;
    }
    if (_playerItem) {
        [_playerItem removeObserver:self forKeyPath:@"status"];
    }
    _playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:fileURLStringWithPID(quality.Music.Url)]];
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    _player = [[AVPlayer alloc] initWithPlayerItem:_playerItem];
}

#pragma mark - getter
- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}

- (AppTime *)currentTime {
    AppTime *m_time = nil;
    if (self.player.currentItem) {
        m_time = [AppTime new];
        m_time.totalTime = CMTimeGetSeconds(self.player.currentItem.duration);
        m_time.currentTime = CMTimeGetSeconds(self.player.currentItem.currentTime);
    }
    return m_time;
}

#pragma mark - NSNotification
- (void)playerDidPlayToEndTime {
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        if ([keyPath isEqualToString:@"status"]) {
            switch (_playerItem.status) {
                case AVPlayerItemStatusReadyToPlay:{
                    [self startPlay];
                }
                    break;
                    
                case AVPlayerItemStatusUnknown:
                    NSLog(@"AVPlayerItemStatusUnknown");
                    break;
                    
                case AVPlayerItemStatusFailed:
                    NSLog(@"AVPlayerItemStatusFailed");
                    break;
                    
                default:
                    break;
            }
            
        }
    }
}

@end
