//
//  PublicMusicPlayerManager.m
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <notify.h>
#import "SDImageCache.h"
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
    [self pause];
    [self clearPlayer];
    [self clearPlayerItem];
    [self clearPlayerTimeObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)postNotificationName:(NSString *)name object:(id)anObject{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:anObject];
    });
}

- (void)resetPlayState:(PlayerManagerState)state {
    if (_state != state) {
        _state = state;
        [self postNotificationName:kNotifi_Play_StateRefresh object:nil];
    }
}

- (void)clearPlayer {
    if (self.player) {
        @try {
            [self.player removeObserver:self forKeyPath:@"rate"];
        } @catch(id anException) {
        }
        self.player = nil;
    }
}

- (void)clearPlayerItem {
    if (self.playerItem) {
        @try {
            [self.playerItem removeObserver:self forKeyPath:@"state"];
        } @catch(id anException) {
        }
        [self.playerItem cancelPendingSeeks];
        [self.playerItem.asset cancelLoading];
        self.playerItem = nil;
    }
}

- (void)clearPlayerTimeObserver {
    if (self.playerTimeObserver) {
        @try {
            [self.player removeTimeObserver:self.playerTimeObserver];
            self.playerTimeObserver = nil;
        } @catch(id anException) {
            
        }
    }
}

- (void)prepare {
    [self resetPlayState:PlayerManagerStatePreparing];
    
    [self clearPlayerItem];
    self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:fileURLStringWithPID(self.currentQulity.Music.Url)]];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [self clearPlayer];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 锁屏界面开启和监控远程控制事件
- (void)createRemoteCommandCenter {
    //官方文档：https://developer.apple.com/documentation/mediaplayer/mpremotecommandcenter
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];

    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self.player pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self.player play];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        CMTime totlaTime = self.player.currentItem.duration;
        MPChangePlaybackPositionCommandEvent * playbackPositionEvent = (MPChangePlaybackPositionCommandEvent *)event;
        [self.player seekToTime:CMTimeMake(totlaTime.value * playbackPositionEvent.positionTime / CMTimeGetSeconds(totlaTime), totlaTime.timescale) completionHandler:^(BOOL finished) {
        }];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
}

#pragma mark - 锁屏播放设置和展示信息
- (void)showLockScreenTotaltime:(float)totalTime andCurrentTime:(float)currentTime andLyricsPoster:(BOOL)isShow {
    NSMutableDictionary * songDict = [[NSMutableDictionary alloc] init];
    //设置歌曲题目
    [songDict setObject:self.currentQulity.Name forKey:MPMediaItemPropertyTitle];
    //设置歌手名
    [songDict setObject:self.currentQulity.Institute.Name forKey:MPMediaItemPropertyArtist];
    //设置专辑名
    [songDict setObject:self.currentQulity.University.Name forKey:MPMediaItemPropertyAlbumTitle];
    //设置歌曲时长
    [songDict setObject:[NSNumber numberWithDouble:totalTime]  forKey:MPMediaItemPropertyPlaybackDuration];
    //设置已经播放时长
    [songDict setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    UIImage *m_image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:fileURLStringWithPID(self.currentQulity.University.Image)];
    if (m_image) {
        //设置显示的海报图片
        [songDict setObject:[[MPMediaItemArtwork alloc] initWithImage:m_image] forKey:MPMediaItemPropertyArtwork];
    }
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
}

#pragma mark - public
- (void)play {
    if (self.state == PlayerManagerStatePause || self.state == PlayerManagerStatePrepared) {
        [self.player play];
        if (!self.playerTimeObserver) {
            // 设置Observer更新播放进度
            QKWEAKSELF;
            self.playerTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                CMTime total = weakself.player.currentItem.duration;
                AppTime *m_time = [AppTime new];
                m_time.totalTime = CMTimeGetSeconds(total);
                m_time.currentTime = CMTimeGetSeconds(time);
                [weakself postNotificationName:kNotifi_Play_TimeObserver object:m_time];
                
                //监听锁屏状态 lock=1则为锁屏状态
                uint64_t locked;
                __block int token = 0;
                notify_register_dispatch(kAppleSBLockstate, &token, dispatch_get_main_queue(), ^(int t){
                });
                notify_get_state(token, &locked);
                
                //监听屏幕点亮状态 screenLight = 1则为变暗关闭状态
                uint64_t screenLight;
                __block int lightToken = 0;
                notify_register_dispatch(kAppleSBHasBlankedScreen, &lightToken, dispatch_get_main_queue(), ^(int t){
                });
                notify_get_state(lightToken, &screenLight);
                
                BOOL isShowLyricsPoster = NO;
                if (screenLight == 0 && locked == 1) {
                    //点亮且锁屏时
                    isShowLyricsPoster = YES;
                }
                else if(screenLight) {
                    return;
                }
                [weakself showLockScreenTotaltime:m_time.totalTime andCurrentTime:m_time.currentTime andLyricsPoster:isShowLyricsPoster];
            }];
        }
    }
    else if (self.state == PlayerManagerStateEnd) {
        CMTime targetTime = CMTimeMake(0, 1);
        [self seekToTime:targetTime];
    }
    else if (self.state == PlayerManagerStateDefault || self.state == PlayerManagerStateFailed) {
        [self prepare];
    }
}

- (void)pause {
    [self.player pause];
}

- (void)stop {
    [self pause];
    [self clearPlayerTimeObserver];
}

- (void)seekToTime:(CMTime)time {
    [self.player seekToTime:time];
}

- (void)resetData:(AppQualityInfo *)quality {
    if (!quality.Music.Url) {
        return;
    }
    if (![quality.Music.Id isEqualToString:self.currentQulity.Music.Id]) {
        if (self.state == PlayerManagerStatePlaying || self.state == PlayerManagerStatePause) {
            [self stop];
        }
        [self resetPlayState:PlayerManagerStateDefault];
        _currentQulity = quality;
        [self postNotificationName:kNotifi_Play_DataRefresh object:nil];
        [self clearPlayerItem];
        [self clearPlayer];
        if (self.isAutoPlay) {
            [self prepare];
        }
    }
}

#pragma mark - getter
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
    [self resetPlayState:PlayerManagerStateEnd];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        if ([keyPath isEqualToString:@"status"]) {
            switch (self.playerItem.status) {
                case AVPlayerItemStatusReadyToPlay:{
                    if (self.state == PlayerManagerStatePreparing) {
                        [self resetPlayState:PlayerManagerStatePrepared];
                        [self play];
                    }
                }
                    break;
                    
                case AVPlayerItemStatusUnknown:
                    NSLog(@"AVPlayerItemStatusUnknown");
                    break;
                    
                case AVPlayerItemStatusFailed: {
                    NSLog(@"AVPlayerItemStatusFailed");
                    [self resetPlayState:PlayerManagerStateFailed];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
    }
    else if ([object isKindOfClass:[AVPlayer class]]) {
        if ([keyPath isEqualToString:@"rate"]) {
            AVPlayer *player = (AVPlayer *)object;
            if (player.rate == 0) {
                [self resetPlayState:PlayerManagerStatePause];
            }
            else if (player.rate == 1) {
                [self resetPlayState:PlayerManagerStatePlaying];
            }
        }
    }
}

@end
