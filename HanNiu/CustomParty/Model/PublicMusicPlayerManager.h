//
//  PublicMusicPlayerManager.h
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    RepeatPlayMode,
    RepeatOnlyOnePlayMode,
    ShufflePlayMode,
} ShuffleAndRepeatState;

@interface PublicMusicPlayerManager : NSObject

+ (PublicMusicPlayerManager *)getInstance;

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playItem;
@property (assign, nonatomic) ShuffleAndRepeatState shuffleAndRepeatState;
@property (assign, nonatomic) NSInteger playingIndex;

- (void)resetPlayItem:(NSString *)songURLString;
- (void)resetPlayer;
- (void)startPlay;
- (void)stopPlay;
- (void)play:(NSString *)songURLString;

@end
