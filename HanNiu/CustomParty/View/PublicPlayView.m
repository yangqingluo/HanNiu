//
//  PublicPlayView.m
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicPlayView.h"
#import "UIButton+ImageAndText.h"

@implementation PublicPlayView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, screen_width, 140)];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStateRefreshNotification:) name:kNotifi_Play_StateRefresh object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerTimeObserverNotification:) name:kNotifi_Play_TimeObserver object:nil];
        self.backgroundColor = [UIColor clearColor];
        
        [self setupSubviews];
        [self updateSubviewsWithState:[PublicMusicPlayerManager getInstance].state];
        [self updateSubviewsWithTime:[PublicMusicPlayerManager getInstance].currentTime];
    }
    return self;
}

- (void)setupSubviews {
    _progressSlider = [[PublicSlider alloc] initWithFrame:CGRectMake(0, 0 , self.width, 20)];
    [_progressSlider setThumbImage:[UIImage imageNamed:@"icon_seekbar_thumb"] forState:UIControlStateNormal];
    _progressSlider.tintColor = appMainColor;
    [self addSubview:_progressSlider];
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.progressSlider.centerY, self.width, self.height - self.progressSlider.centerY)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self insertSubview:_baseView belowSubview:self.progressSlider];
    
    _playBtn = NewButton(CGRectMake(0, kEdgeHuge, 40, 40), nil, nil, nil);
    _playBtn.centerX = 0.5 * self.baseView.width;
    [self.baseView addSubview:_playBtn];
    
    _lastBtn = NewButton(CGRectMake(0, 0, 30, 30), nil, nil, nil);
    _lastBtn.centerY = _playBtn.centerY;
    _lastBtn.right = _playBtn.left - kEdgeMiddle;
    [_lastBtn setImage:[UIImage imageNamed:@"icon_prev_music"] forState:UIControlStateNormal];
    [self.baseView addSubview:_lastBtn];
    
    _nextBtn = NewButton(_lastBtn.frame, nil, nil, nil);
    _nextBtn.left = _playBtn.right + kEdgeMiddle;
    [_nextBtn setImage:[UIImage imageNamed:@"icon_next_music"] forState:UIControlStateNormal];
    [self.baseView addSubview:_nextBtn];
    
    CGFloat m_edge = 2.0;
    _listBtn = NewButton(CGRectMake(0, 0, 40, 40), @"列表", [UIColor grayColor], [AppPublic appFontOfSize:8.0]);
    _listBtn.centerY = _playBtn.centerY + kEdgeSmall;
    _listBtn.left = kEdgeBig;
    [_listBtn setImage:[UIImage imageNamed:@"icon_play_list_gray"] forState:UIControlStateNormal];
    [self.baseView addSubview:_listBtn];
    [_listBtn verticalImageAndTitle:m_edge];
    
    _favorBtn = NewButton(_listBtn.frame, @"收藏", _listBtn.titleLabel.textColor, _listBtn.titleLabel.font);
    _favorBtn.centerY = _listBtn.centerY;
    _favorBtn.right = self.baseView.width - kEdgeBig;
    [_favorBtn setImage:[UIImage imageNamed:@"icon_not_collect"] forState:UIControlStateNormal];
    [self.baseView addSubview:_favorBtn];
    [_favorBtn verticalImageAndTitle:m_edge];
    
    _startLabel = NewLabel(CGRectMake(kEdgeSmall, 0.5 * self.progressSlider.height, 40, 10), [UIColor grayColor], [AppPublic appFontOfSize:8.0], NSTextAlignmentLeft);
    [self.baseView addSubview:_startLabel];
    
    _endLabel = NewLabel(_startLabel.frame, _startLabel.textColor, _startLabel.font, NSTextAlignmentRight);
    _endLabel.right = self.baseView.width - _startLabel.left;
    [self.baseView addSubview:_endLabel];
    
    _messageBtn = NewButton(_listBtn.bounds, @"0", _listBtn.titleLabel.textColor, _listBtn.titleLabel.font);
    _messageBtn.left = kEdgeSmall;
    _messageBtn.bottom = self.baseView.height;
    [_messageBtn setImage:[UIImage imageNamed:@"icon_make_comment"] forState:UIControlStateNormal];
    [self.baseView addSubview:_messageBtn];
    [_messageBtn verticalImageAndTitle:m_edge];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(_messageBtn.right + kEdgeSmall, 0, self.baseView.width - kEdgeSmall - (_messageBtn.right + kEdgeSmall), 30)];
    _textField.backgroundColor = appLightWhiteColor;
    _textField.placeholder = @"\t\t期待您的神评论";
    _textField.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.layer.cornerRadius = 0.5 * _textField.bounds.size.height;
    _textField.centerY = self.messageBtn.centerY;
    [self.baseView addSubview:_textField];
}

- (void)updateSubviewsWithTime:(AppTime *)m_time {
    if (m_time) {
        // 当前播放时间
        self.startLabel.text = stringWithTimeInterval(m_time.currentTime);
        // 总时间
        self.endLabel.text = stringWithTimeInterval(m_time.totalTime);
        // 进度条
        self.progressSlider.value = (float) (m_time.currentTime / m_time.totalTime );
    }
    else {
        self.startLabel.text = @"00:00";
        self.endLabel.text = @"00:00";
        self.progressSlider.value = 0.0f;
    }
}

- (void)updateSubviewsWithState:(PlayerManagerState)state {
    if (state == PlayerManagerStatePlaying) {
        [self.playBtn setImage:[UIImage imageNamed:@"icon_pause_big"] forState:UIControlStateNormal];
    }
    else {
        [self.playBtn setImage:[UIImage imageNamed:@"icon_play_big"] forState:UIControlStateNormal];
    }
}

#pragma mark - NSNotification
- (void)playerStateRefreshNotification:(NSNotification *)notification {
    [self updateSubviewsWithState:[PublicMusicPlayerManager getInstance].state];
    if ([PublicMusicPlayerManager getInstance].state == PlayerManagerStateDefault) {
        [self updateSubviewsWithTime:[PublicMusicPlayerManager getInstance].currentTime];
    }
}

- (void)playerTimeObserverNotification:(NSNotification *)notification {
    [self updateSubviewsWithTime:notification.object];
}

@end
