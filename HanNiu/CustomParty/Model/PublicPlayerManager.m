//
//  PublicMusicPlayerManager.m
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <notify.h>
#import "SDImageCache.h"
#import "PublicPlayerManager.h"

@interface PublicPlayerManager () {
    BOOL firstWhenOpenApp;
}

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) id playerTimeObserver;

@end

@implementation PublicPlayerManager

static PublicPlayerManager *_sharedManager = nil;
+ (PublicPlayerManager *)getInstance {
    @synchronized([PublicPlayerManager class]){
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
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSDictionary *data = [ud objectForKey:kUserPlayCurrent];
        if (data) {
            firstWhenOpenApp = YES;
            [self saveCurrentData:[AppBasicMusicDetailInfo mj_objectWithKeyValues:data]];
        }
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
    self.playerItem = [[AVPlayerItem alloc] initWithURL:fileURLWithPID(self.currentPlay.Music.Url)];
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
    
    [commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self playLast];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self playNext];
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
    [songDict setObject:self.currentPlay.Music.Name forKey:MPMediaItemPropertyTitle];
    //设置歌手名
    [songDict setObject:self.currentPlay.showMediaItemPropertyArtist forKey:MPMediaItemPropertyArtist];
    //设置专辑名
    [songDict setObject:self.currentPlay.showMediaItemPropertyAlbumTitle forKey:MPMediaItemPropertyAlbumTitle];
    //设置歌曲时长
    [songDict setObject:[NSNumber numberWithDouble:totalTime]  forKey:MPMediaItemPropertyPlaybackDuration];
    //设置已经播放时长
    [songDict setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    UIImage *m_image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:fileURLStringWithPID(self.currentPlay.University.Image)];
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

- (void)playLast {
    if (self.userPlayList.count > 1) {
        NSInteger index = self.playIndex;
        index--;
        if (index < 0) {
            index = self.userPlayList.count - 1;
        }
        AppBasicMusicDetailInfo *item = self.userPlayList[index];
        if (item.Music.Url) {
            [self saveCurrentData:item];
        }
    }
}

- (void)playNext {
    if (self.userPlayList.count > 1) {
        NSInteger index = self.playIndex;
        index++;
        if (index >= self.userPlayList.count) {
            index = 0;
        }
        AppBasicMusicDetailInfo *item = self.userPlayList[index];
        if (item.Music.Url) {
            [self saveCurrentData:item];
        }
    }
}

- (void)stop {
    [self pause];
    [self clearPlayerTimeObserver];
}

- (void)seekToTime:(CMTime)time {
    [self.player seekToTime:time];
}

//保存当前播放数据
- (void)saveCurrentData:(AppBasicMusicDetailInfo *)data {
    BOOL needSwitch = NO;
    if (data.Music.Url) {
        if (![data.Music.Id isEqualToString:self.currentPlay.Music.Id]) {
            needSwitch = YES;
        }
        else if (!self.currentPlay.Music.Url) {
            needSwitch = YES;
        }
    }
    _currentPlay = data;
    if (_currentPlay) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:[_currentPlay mj_keyValues] forKey:kUserPlayCurrent];
    }
    [self resetPlayIndex];
    [self postNotificationName:kNotifi_Play_DataRefresh object:nil];
    if (needSwitch) {
        [self resetPlay];
    }
    else {
        firstWhenOpenApp = NO;
    }
}

//保存用户播放列表
- (void)savePlayList:(NSArray *)array {
    [self.userPlayList removeAllObjects];
    [self.userPlayList addObjectsFromArray:array];
    if (_userPlayList) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:[AppBasicMusicDetailInfo mj_keyValuesArrayWithObjectArray:_userPlayList] forKey:kUserPlayList];
    }
}

- (void)resetPlay {
    if (self.state == PlayerManagerStatePlaying || self.state == PlayerManagerStatePause) {
        [self stop];
    }
    [self resetPlayState:PlayerManagerStateDefault];
    [self clearPlayerItem];
    [self clearPlayer];
    if (self.isAutoPlay) {
        if (firstWhenOpenApp) {
            firstWhenOpenApp = NO;
            if ([[AppPublic getInstance].isAutoPlayWhenOpen boolValue]) {
                [self prepare];
            }
        }
        else {
            [self prepare];
        }
    }
}

- (void)resetPlayIndex {
    _playIndex = -1;
    for (NSInteger i = 0; i < self.userPlayList.count; i++) {
        AppBasicMusicDetailInfo *item = self.userPlayList[i];
        if ([item.Music.Id isEqualToString:self.currentPlay.Music.Id]) {
            _playIndex = i;
            break;
        }
    }
}

#pragma mark - getter
- (BOOL)isAutoPlay {
    BOOL yn = NO;
    switch ([[AppPublic getInstance].internetReachability currentReachabilityStatus]) {
        case NotReachable:{
            NSLog(@"**********未连接");
        }
            break;
            
        case ReachableViaWiFi:{
            NSLog(@"***********wifi");
            yn = YES;
        }
            break;
            
        case ReachableViaWWAN:{
            NSLog(@"*********蜂窝网络");
            yn = [[AppPublic getInstance].isAutoPlayOnWWAN boolValue];
        }
            break;
            
        default:
            break;
    }
    
    return yn;
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

- (NSMutableArray *)userPlayList {
    if (!_userPlayList) {
        _userPlayList = [NSMutableArray new];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSArray *data = [ud objectForKey:kUserPlayList];
        if (data.count) {
            [_userPlayList addObjectsFromArray:[AppBasicMusicDetailInfo mj_objectArrayWithKeyValuesArray:data]];
        }
    }
    return _userPlayList;
}

//- (AppBasicMusicDetailInfo *)currentPlay {
//    if (!_currentPlay) {
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        NSDictionary *data = [ud objectForKey:kUserPlayCurrent];
//        if (data) {
//            _currentPlay = [AppBasicMusicDetailInfo mj_objectWithKeyValues:data];
//        }
//    }
//    return _currentPlay;
//}

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
