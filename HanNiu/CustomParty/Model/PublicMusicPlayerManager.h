//
//  PublicMusicPlayerManager.h
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#define kNotifi_Play_DataRefresh       @"kNn_Play_DataRefresh"//播放数据变化
#define kNotifi_Play_StateRefresh      @"kNn_Play_StateRefresh"//播放状态变化
#define kNotifi_Play_TimeObserver      @"kNn_Play_TimeObserver"//播放过程监听

typedef enum : NSUInteger {
    PlayerManagerStateDefault,
    PlayerManagerStatePreparing,
    PlayerManagerStatePrepared,
    PlayerManagerStatePlaying,
    PlayerManagerStatePause,
    PlayerManagerStateFailed,
    PlayerManagerStateEnd,
} PlayerManagerState;

typedef enum : NSUInteger {
    RepeatPlayMode,
    RepeatOnlyOnePlayMode,
    ShufflePlayMode,
} ShuffleAndRepeatState;

@interface PublicMusicPlayerManager : NSObject

+ (PublicMusicPlayerManager *)getInstance;

@property (strong, nonatomic) AppTime *currentTime;
@property (assign, nonatomic) BOOL isAutoPlay;
@property (assign, nonatomic, readonly) PlayerManagerState state;
@property (strong, nonatomic, readonly) AppBasicMusicDetailInfo *currentQulity;
//@property (assign, nonatomic) ShuffleAndRepeatState shuffleAndRepeatState;
//@property (assign, nonatomic) NSInteger playingIndex;

- (void)play;
- (void)pause;
- (void)seekToTime:(CMTime)time;
- (void)resetData:(AppBasicMusicDetailInfo *)quality;

@end
