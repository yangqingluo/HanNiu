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

#define kNotifi_Play_StateRefresh      @"kNn_Play_StateRefresh"//播放状态变化
#define kNotifi_Play_TimeObserver      @"kNn_Play_TimeObserver"//播放过程监听

typedef enum : NSUInteger {
    RepeatPlayMode,
    RepeatOnlyOnePlayMode,
    ShufflePlayMode,
} ShuffleAndRepeatState;

@interface PublicMusicPlayerManager : NSObject

+ (PublicMusicPlayerManager *)getInstance;

@property (strong, nonatomic) AppTime *currentTime;
@property (assign, nonatomic) ShuffleAndRepeatState shuffleAndRepeatState;
@property (assign, nonatomic) NSInteger playingIndex;

- (void)startPlay;
- (void)stopPlay;
- (void)resetPlay:(AppQualityInfo *)quality;

@end
