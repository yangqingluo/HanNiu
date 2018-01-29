//
//  MusicDetailVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <notify.h>
#import "MusicDetailVC.h"
#import "MusicCommentVC.h"

#import "PublicPlayView.h"

#import "PublicMusicPlayerManager.h"
#import "SDImageCache.h"

PublicMusicPlayerManager *musicPlayer;
@interface MusicDetailVC ()<UITextFieldDelegate>

@property (strong, nonatomic) PublicPlayView *playView;
@property (strong, nonatomic) UITextView *textView;

@end

@implementation MusicDetailVC

- (instancetype)init {
    self = [super init];
    if (self) {
        musicPlayer = [PublicMusicPlayerManager getInstance];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@-%@-%@", self.data.University.Name, self.data.Institute.Name, self.data.Music.Name];
    [self.view addSubview:self.playView];
    
    [self.view addSubview:self.textView];
    self.textView.text = self.data.Introduce;
    
    [self resetPlayer:YES];
//    [self pullBaseListData:YES];
}

- (void)initializeNavigationBar {
    [self createNavWithTitle:self.title createMenuItem:^UIView *(int nIndex) {
        if (nIndex == 0) {
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1) {
            UIButton *btn = NewRightButton([UIImage imageNamed:@"icon_back_to_mainview"], nil);
            btn.frame = CGRectMake(screen_width - 44, 0, 44, DEFAULT_BAR_HEIGHT);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            return btn;
        }
        else if (nIndex == 2) {
            UIButton *btn = NewRightButton([UIImage imageNamed:@"icon_share"], nil);
            btn.frame = CGRectMake(screen_width - 2 * 44, 0, 44, DEFAULT_BAR_HEIGHT);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
            return btn;
        }
        return nil;
    }];
}

- (void)playButtonAction:(UIButton *)button {
    if (musicPlayer.player.rate == 0) {
        button.selected = YES;
        [musicPlayer startPlay];
    }
    else {
        button.selected = NO;
        [musicPlayer stopPlay];
    }
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"id" : self.data.Music.Id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Music/Detail" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
//            [weakself updateSubviews];
        }
    }];
}

- (void)resetPlayer:(BOOL)autoPlay {
    if (!self.data.Music.Url) {
        return;
    }
    
    if (_playerTimeObserver) {
        [musicPlayer.player removeTimeObserver:_playerTimeObserver];
        _playerTimeObserver = nil;
        [musicPlayer.player.currentItem cancelPendingSeeks];
        [musicPlayer.player.currentItem.asset cancelLoading];
    }
//    self.playView.playBtn.selected = YES;
    
    // 播放设置
    [musicPlayer resetPlayItem:fileURLStringWithPID(self.data.Music.Url)];
    [musicPlayer resetPlayer];
    
    // 播放结束通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:musicPlayer.player.currentItem];
    
    // 设置Observer更新播放进度
    _playerTimeObserver = [musicPlayer.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CGFloat currentTime = CMTimeGetSeconds(time);
        CMTime total = musicPlayer.player.currentItem.duration;
        CGFloat totalTime = CMTimeGetSeconds(total);
        
        // 当前播放时间
        self.playView.startLabel.text = stringWithTimeInterval(currentTime);
        // 总时间
        self.playView.endLabel.text = stringWithTimeInterval(totalTime);
        // 进度条
        self.playView.progressSlider.value = (float) ( currentTime / totalTime );

        //监听锁屏状态 lock = 1则为锁屏状态
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
        // NSLog(@"screenLight=%llu locked=%llu",screenLight,locked);
        if (screenLight == 0 && locked == 1) {
            //点亮且锁屏时
            isShowLyricsPoster = YES;
        }
        else if(screenLight) {
            return;
        }
        
        //展示锁屏歌曲信息，上面监听屏幕锁屏和点亮状态的目的是为了提高效率
        [self showLockScreenTotaltime:totalTime andCurrentTime:currentTime andLyricsPoster:isShowLyricsPoster];
    }];
}

#pragma mark - 锁屏播放设置
//展示锁屏歌曲信息：图片、歌词、进度、演唱者
- (void)showLockScreenTotaltime:(float)totalTime andCurrentTime:(float)currentTime andLyricsPoster:(BOOL)isShow {
    NSMutableDictionary * songDict = [[NSMutableDictionary alloc] init];
    //设置歌曲题目
    [songDict setObject:self.data.Name forKey:MPMediaItemPropertyTitle];
    //设置歌手名
    [songDict setObject:self.data.Institute.Name forKey:MPMediaItemPropertyArtist];
    //设置专辑名
    [songDict setObject:self.data.University.Name forKey:MPMediaItemPropertyAlbumTitle];
    //设置歌曲时长
    [songDict setObject:[NSNumber numberWithDouble:totalTime]  forKey:MPMediaItemPropertyPlaybackDuration];
    //设置已经播放时长
    [songDict setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    UIImage *m_image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:fileURLStringWithPID(self.data.University.Image)];
    if (m_image) {
        //设置显示的海报图片
        [songDict setObject:[[MPMediaItemArtwork alloc] initWithImage:m_image] forKey:MPMediaItemPropertyArtwork];
    }
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
}

#pragma mark - getter
- (PublicPlayView *)playView {
    if (!_playView) {
        _playView = [PublicPlayView new];
        _playView.bottom = self.view.height;
        [_playView.playBtn addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_playView.progressSlider addTarget:self action:@selector(playbackSliderValueChanged) forControlEvents:UIControlEventValueChanged];
        _playView.textField.delegate = self;
    }
    return _playView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.bottom, self.view.width, self.playView.top - kEdge - self.navigationBarView.bottom)];
        _textView.editable = NO;
        _textView.textColor = [UIColor grayColor];
        _textView.font = [AppPublic appFontOfSize: appLabelFontSizeSmall];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textContainerInset = UIEdgeInsetsMake(kEdge, kEdge, kEdge, 0);
        _textView.scrollIndicatorInsets = UIEdgeInsetsMake(kEdge, 0, kEdge, 0);
    }
    return _textView;
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    MusicCommentVC *vc = [MusicCommentVC new];
    [self doPushViewController:vc animated:YES];
    return NO;
}

#pragma mark - UISlider
- (void)playbackSliderValueChanged {
    [self updateTime];
    //如果当前时暂停状态，则自动播放
    if (musicPlayer.player.timeControlStatus == AVPlayerTimeControlStatusPaused) {
        [musicPlayer startPlay];
    }
}

#pragma mark - 更新播放时间
- (void)updateTime {
    CMTime duration = musicPlayer.player.currentItem.asset.duration;
    
    // 歌曲总时间和当前时间
    Float64 completeTime = CMTimeGetSeconds(duration);
    Float64 currentTime = (Float64)(self.playView.progressSlider.value) * completeTime;
    
    //播放器定位到对应的位置
    CMTime targetTime = CMTimeMake((int64_t)(currentTime), 1);
    [musicPlayer.player seekToTime:targetTime];
}

@end
