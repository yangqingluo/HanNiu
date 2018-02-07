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

extern PublicMusicPlayerManager *musicPlayer;
@interface MusicDetailVC ()<UITextFieldDelegate>

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
    self.title = [NSString stringWithFormat:@"%@-%@-%@", self.data.University.Name, self.data.Institute.Name, self.data.Music.Name];
    [self.view addSubview:self.playView];
    
    [self.view addSubview:self.textView];
    self.textView.text = self.data.Introduce;
    [musicPlayer resetData:self.data];
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

#pragma mark - getter
- (PublicPlayView *)playView {
    if (!_playView) {
        _playView = [PublicPlayView new];
        _playView.bottom = self.view.height;
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
    vc.data = self.data.Music;
    [self doPushViewController:vc animated:YES];
    return NO;
}

@end
