//
//  MusicDetailVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "MusicDetailVC.h"

#import "PublicPlayView.h"

#import "PublicMusicPlayerManager.h"

PublicMusicPlayerManager *musicPlayer;
@interface MusicDetailVC ()

@property (strong, nonatomic) PublicPlayView *playView;

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
    
    [self resetPlayer];
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

- (void)resetPlayer {
    if (self.data.Music.Url) {
        [musicPlayer resetPlayItem:fileURLStringWithPID(self.data.Music.Url)];
        [musicPlayer resetPlayer];
    }
}

#pragma mark - getter
- (PublicPlayView *)playView {
    if (!_playView) {
        _playView = [PublicPlayView new];
        _playView.bottom = self.view.height;
        [_playView.playBtn addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playView;
}

@end
