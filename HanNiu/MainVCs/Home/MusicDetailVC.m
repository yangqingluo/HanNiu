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
#import "PublicAlertView.h"

#import "PublicPlayerManager.h"
#import "SDImageCache.h"

extern PublicPlayerManager *musicPlayer;
@interface MusicDetailVC ()<UITextFieldDelegate>

@property (strong, nonatomic) AppBasicMusicDetailInfo *data;
@property (strong, nonatomic) PublicPlayView *playView;
@property (strong, nonatomic) UITextView *textView;

@end

@implementation MusicDetailVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [PublicPlayerManager getInstance].currentPlay;
    
    self.title = self.data.showMediaDetailTitle;
    [self.view addSubview:self.playView];
    
    [self.view addSubview:self.textView];
    [self updateSubviews];
    [self pullBaseListData:YES];
    if (!self.data.Music.Url) {
        PublicAlertShowMusicBuyView *alert = [PublicAlertShowMusicBuyView new];
        alert.nameView.titleLabel.text = self.data.Music.Name;
        alert.nameView.subTitleLabel.text = [NSString stringWithFormat:@"%d M币", self.data.Price];
        alert.priceView.titleLabel.text = @"实支付";
        alert.priceView.subTitleLabel.text = [NSString stringWithFormat:@"%d M币", self.data.Music.Price];
        alert.balanceView.titleLabel.text = @"余额";
        alert.balanceView.subTitleLabel.text = [NSString stringWithFormat:@"%d M币", [UserPublic getInstance].userData.Extra.userinfo.Coin];
        alert.block = ^(PublicAlertView *view, NSInteger index) {
            if (index == 1) {
                [self doMusicBuyFunction];
            }
            else if (index == 0) {
                [self doPopViewControllerAnimated:YES];
            }
        };
        [alert show];
    }
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
            [btn addTarget:self action:@selector(homeButtonAction) forControlEvents:UIControlEventTouchUpInside];
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
            weakself.data.Music = [AppMusicInfo mj_objectWithKeyValues:responseBody[@"Data"]];
            [weakself updateSubviews];
        }
    }];
}

- (void)doMusicCollectionFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"id" : self.data.Music.Id, @"like" : stringWithBoolValue(!self.data.Music.IsInCollect)}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Post:m_dic HeadParm:nil URLFooter:[NSString stringWithFormat:@"Music/Collection?%@", AFQueryStringFromParameters(m_dic)] completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            self.data.Music.IsInCollect = !self.data.Music.IsInCollect;
        }
        [weakself updateSubviews];
    }];
}

- (void)doMusicBuyFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"id" : self.data.Music.Id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Post:m_dic HeadParm:nil URLFooter:[NSString stringWithFormat:@"Music/Buy?%@", AFQueryStringFromParameters(m_dic)] completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            weakself.data = [AppBasicMusicDetailInfo mj_objectWithKeyValues:responseBody[@"Data"]];
            [weakself doShowHintFunction:@"购买成功"];
        }
        [weakself updateSubviews];
    }];
}

- (void)updateSubviews {
    self.textView.text = notNilString(self.data.Introduce, @"暂无简介");
    [self.playView updateFavorButtonInCollection:self.data.Music.IsInCollect];
}

- (void)favorButtonAction {
    [self doMusicCollectionFunction];
}

- (void)listButtonAction {
    PublicAlertMusicListView *alert = [PublicAlertMusicListView new];
    [alert show];
}

#pragma mark - getter
- (PublicPlayView *)playView {
    if (!_playView) {
        _playView = [PublicPlayView new];
        _playView.bottom = self.view.height;
        _playView.textField.delegate = self;
        [_playView.favorBtn addTarget:self action:@selector(favorButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_playView.listBtn addTarget:self action:@selector(listButtonAction) forControlEvents:UIControlEventTouchUpInside];
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
    vc.musicId = self.data.Music.Id;
    [self doPushViewController:vc animated:YES];
    return NO;
}

@end
