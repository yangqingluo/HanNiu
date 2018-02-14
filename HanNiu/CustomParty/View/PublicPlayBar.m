//
//  PublicPlayBar.m
//  HanNiu
//
//  Created by 7kers on 2018/1/25.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicPlayBar.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Rotate.h"
#import "PublicAlertView.h"

PublicPlayerManager *musicPlayer;
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
        musicPlayer = [PublicPlayerManager getInstance];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStateRefreshNotification:) name:kNotifi_Play_StateRefresh object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDataRefreshNotification:) name:kNotifi_Play_DataRefresh object:nil];
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barButtonAction)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupSubviews {
    CGFloat radius = 0.8 * self.height;
    _playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kEdgeMiddle, 0, radius, radius)];
    [AppPublic roundCornerRadius:_playImageView];
    _playImageView.centerY = 0.5 * self.height;
    _playImageView.image = [UIImage imageNamed:defaultDownloadPlaceImageName];
    _playImageView.backgroundColor = appLightWhiteColor;
    [self addSubview:_playImageView];
    
    _listBtn = NewButton(CGRectMake(0, 0, radius, radius), nil, nil, nil);
    _listBtn.centerY = 0.5 * self.height;
    _listBtn.right = self.width - kEdgeMiddle;
    [_listBtn setImage:[UIImage imageNamed:@"icon_play_list_colorful"] forState:UIControlStateNormal];
    [self addSubview:_listBtn];
    [_listBtn addTarget:self action:@selector(listButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    _playBtn = NewButton(CGRectMake(0, 0, radius, radius), nil, nil, nil);
    _playBtn.centerY = 0.5 * self.height;
    _playBtn.right = _listBtn.left - kEdge;
    [_playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    [self addSubview:_playBtn];
    [_playBtn addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    _songName = NewLabel(CGRectMake(_playImageView.right + kEdge, _playImageView.top, _playBtn.left - _playImageView.right - 2 * kEdge, 0.5 * radius), appTextColor, [AppPublic appFontOfSize:appLabelFontSizeLittle], NSTextAlignmentLeft);
    [self addSubview:_songName];
    
    _singerName = NewLabel(_songName.frame, [UIColor grayColor], _songName.font, _songName.textAlignment);
    _singerName.top = _songName.bottom;
    [self addSubview:_singerName];
}

- (void)playButtonAction {
    if (musicPlayer.state == PlayerManagerStatePlaying) {
        [musicPlayer pause];
    }
    else {
        [musicPlayer play];
    }
}

- (void)listButtonAction {
    PublicAlertMusicListView *alert = [PublicAlertMusicListView new];
    [alert show];
}

- (void)barButtonAction {
    [[AppPublic getInstance] goToMusicVC:nil list:nil type:PublicMusicDetailFromBar];
}

- (void)updateSubviewsWithState:(PlayerManagerState)state {
    if (state == PlayerManagerStatePlaying) {
        [self.playBtn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
        [self.playImageView startRotating];
    }
    else {
        [self.playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
        [self.playImageView stopRotating];
    }
}

- (void)updateSubviewsWithData:(AppBasicMusicDetailInfo *)data {
    [self.playImageView recoverRotating];
    [self.playImageView sd_setImageWithURL:fileURLWithPID(data.Image) placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    self.songName.text = notNilString(data.Music.Name, @"未知");
    self.singerName.text = notNilString(data.showMediaItemPropertyAuthor, @"");
}

#pragma mark - NSNotification
- (void)playerStateRefreshNotification:(NSNotification *)notification {
    [self updateSubviewsWithState:musicPlayer.state];
}

- (void)playerDataRefreshNotification:(NSNotification *)notification {
    [self updateSubviewsWithData:musicPlayer.currentPlay];
}

@end
