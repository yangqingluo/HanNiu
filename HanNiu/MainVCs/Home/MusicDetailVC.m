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
#import "AccountCoinVC.h"

#import "PublicPlayView.h"
#import "PublicAlertView.h"
#import "CollegeIntroduceHeaderView.h"
#import "PublicImageTagTitleCell.h"
#import "PublicCollectionHeaderTitleView.h"

#import "PublicPlayerManager.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

extern PublicPlayerManager *musicPlayer;
@interface MusicDetailVC ()<UITextFieldDelegate>

@property (copy, nonatomic) AppBasicMusicDetailInfo *data;
@property (strong, nonatomic) PublicPlayView *playView;
@property (strong, nonatomic) PublicPlayMessageView *messageView;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) SchoolIntroduceHeaderView *introduceView;
@property (strong, nonatomic) PublicAlertShowMusicBuyView *alertShowBuyView;

@end

@implementation MusicDetailVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDataRefreshNotification:) name:kNotifi_Play_DataRefresh object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRefreshNotification:) name:kNotifi_Comment_Refresh object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.needRefresh) {
        [self beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetPlayData];
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.bottom, screen_width, screen_width * appImageScale)];
    [self.view addSubview:self.headerImageView];
    
    self.playView.top = self.headerImageView.bottom - 0.5 * self.playView.progressSlider.height;
    [self.view addSubview:self.playView];
    
    self.messageView.bottom = self.view.height;
    [self.view addSubview:self.messageView];
    
    self.tableView.frame = CGRectMake(0, self.playView.bottom + kEdge, screen_width, self.messageView.top - self.playView.bottom - kEdge);
    self.tableView.tableHeaderView = self.introduceView;
    [self updateTableViewHeader];
    [self beginRefreshing];
    
    [self updateSubviews];
    if (!self.data.Music.Url) {
        self.alertShowBuyView.data = [self.data copy];
        [self.alertShowBuyView show];
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
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"musicId" : self.data.Music.Id}];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Music/Comment/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:[AppCommentInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
            [weakself updateSubviews];
        }
    }];
}

- (void)doGetDetailDataFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    NSString *urlFooter = @"";
    if (self.data.CommonMajor) {
        urlFooter = @"University/Major/Detail";
        [m_dic setObject:self.data.CommonMajor.Id forKey:@"id"];
    }
    else if (self.data.Institute) {
        urlFooter = @"University/School/Detail";
        [m_dic setObject:self.data.Institute.Id forKey:@"id"];
    }
    else if (self.data.University) {
        urlFooter = @"University/Detail";
        [m_dic setObject:self.data.University.Id forKey:@"id"];
    }
    else if (self.data.College) {
        urlFooter = @"University/Detail";
        [m_dic setObject:self.data.College.Id forKey:@"id"];
    }
    else {
        urlFooter = @"Quality/Detail";
        [m_dic setObject:self.data.Id forKey:@"id"];
    }
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:urlFooter completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            AppBasicMusicDetailInfo *m_data = [AppBasicMusicDetailInfo mj_objectWithKeyValues:responseBody[@"Data"]];
            if (m_data.Introduce) {
                weakself.data.Introduce = [m_data.Introduce copy];
                [weakself updateSubviews];
            }
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
            [weakself.alertShowBuyView show];
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            AppMusicInfo *music = [AppMusicInfo mj_objectWithKeyValues:responseBody[@"Data"]];
            [PublicPlayerManager getInstance].currentPlay.Music = music;
            [[PublicPlayerManager getInstance] saveCurrentData:[PublicPlayerManager getInstance].currentPlay];
            [weakself resetPlayData];
            [weakself doShowHintFunction:@"购买成功"];
        }
        [weakself updateSubviews];
    }];
}

- (void)resetPlayData {
    self.data = [[PublicPlayerManager getInstance].currentPlay copy];
    if (!self.data.Introduce.length) {
        [self doGetDetailDataFunction];
    }
}

- (void)updateSubviews {
    [super updateSubviews];
    self.title = self.data.showMediaDetailTitle;
    [self.headerImageView sd_setImageWithURL:fileURLWithPID(self.data.Music.Image) placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    self.introduceView.tagLabel.text = notNilString(self.data.Introduce, @"暂无简介");
    [self.introduceView adjustTagLabelHeight:self.introduceView.tagLabel.numberOfLines];
    
    [self.messageView.messageBtn setTitle:[NSString stringWithFormat:@"%d", self.data.Music.Comment] forState:UIControlStateNormal];
    [self.playView updateFavorButtonInCollection:self.data.Music.IsInCollect];
}

- (void)favorButtonAction {
    [self doMusicCollectionFunction];
}

- (void)listButtonAction {
    PublicAlertMusicListView *alert = [PublicAlertMusicListView new];
    [alert show];
}

- (void)alertSureButtonAction {
    if ([UserPublic getInstance].userData.Extra.userinfo.Coin >= self.data.Music.Price) {
        [self doMusicBuyFunction];
        [self.alertShowBuyView dismiss];
    }
    else {
        AccountCoinVC *vc = [AccountCoinVC new];
        vc.doneBlock = ^(id object){
            self.alertShowBuyView.data = [self.data copy];
            [self.alertShowBuyView show];
        };
        [self doPushViewController:vc animated:YES];
    }
}

- (void)foldButtonAction:(UIButton *)button {
    if (self.introduceView.tagLabel.numberOfLines == 3) {
        [self.introduceView adjustTagLabelHeight:0];
    }
    else {
        [self.introduceView adjustTagLabelHeight:3];
    }
    [self.tableView reloadData];
}

- (void)goToCommentVCAction {
    MusicCommentVC *vc = [MusicCommentVC new];
    vc.musicId = self.data.Music.Id;
    [self doPushViewController:vc animated:YES];
}

#pragma mark - getter
- (PublicPlayView *)playView {
    if (!_playView) {
        _playView = [PublicPlayView new];
        [_playView.favorBtn addTarget:self action:@selector(favorButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_playView.listBtn addTarget:self action:@selector(listButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playView;
}

- (PublicPlayMessageView *)messageView {
    if (!_messageView) {
        _messageView = [PublicPlayMessageView new];
        _messageView.textField.delegate = self;
    }
    return _messageView;
}

- (SchoolIntroduceHeaderView *)introduceView {
    if (!_introduceView) {
        _introduceView = [SchoolIntroduceHeaderView new];
        [_introduceView.foldBtn addTarget:self action:@selector(foldButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _introduceView;
}

- (PublicAlertShowMusicBuyView *)alertShowBuyView {
    if (!_alertShowBuyView) {
        QKWEAKSELF;
        _alertShowBuyView = [PublicAlertShowMusicBuyView new];
        _alertShowBuyView.block = ^(PublicAlertView *view, NSInteger index) {
            if (index == 1) {
                [weakself alertSureButtonAction];
            }
            else if (index == 0) {
                [weakself doPopViewControllerAnimated:YES];
            }
        };
    }
    return _alertShowBuyView;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppCommentInfo *item = self.dataSource[indexPath.row];
    return [MusicCommentCell tableView:tableView heightForRowAtIndexPath:indexPath andSubTitle:item.showStringForContent];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kCellHeight + kEdge;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PublicCollectionHeaderTitleView *m_view = [[PublicCollectionHeaderTitleView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeight)];
    m_view.titleLabel.text = @"听众点评";
    m_view.subTitleLabel.text = @"";
    m_view.rightImageView.hidden = YES;
    [m_view addSubview:NewSeparatorLine(CGRectMake(0, 0, m_view.width, appSeparaterLineSize))];
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, m_view.width, m_view.height + kEdge)];
    m_view.bottom = baseView.height;
    [baseView addSubview:m_view];
    return baseView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    MusicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MusicCommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.likeBtn removeFromSuperview];
    }
    cell.data = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self goToCommentVCAction];
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self goToCommentVCAction];
    return NO;
}

#pragma mark - NSNotification
- (void)playerDataRefreshNotification:(NSNotification *)notification {
    [self resetPlayData];
    [self updateSubviews];
}

@end
