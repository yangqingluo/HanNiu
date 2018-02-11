//
//  MusicCommentVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/25.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "MusicCommentVC.h"

#import "PublicImageTagTitleCell.h"
#import "PublicMessageToolBar.h"

#import "IQKeyboardManager.h"

@interface MusicCommentVC ()<PublicMessageToolBarDelegate>

@property (strong, nonatomic) PublicMessageToolBar *messageBar;
@property (strong, nonatomic) AppCommentInfo *remindOne;

@end

@implementation MusicCommentVC

- (void)dealloc {
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    self.title = @"所有评论";
    [self configMessageToolBar];
    self.tableView.height = self.view.height - self.messageBar.height - self.navigationBarView.bottom;
    [self updateTableViewHeader];
    [self beginRefreshing];
}

- (void)configMessageToolBar {
    [self.view addSubview:self.messageBar];
    self.messageBar.inputTextView.placeHolder = @"期待您的神评论";
    self.messageBar.inputTextView.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
    self.messageBar.inputTextView.backgroundColor = appLightWhiteColor;
    self.messageBar.inputTextView.contentInset = UIEdgeInsetsMake(0, kEdgeMiddle, 0, kInputTextViewMinHeight);
    self.messageBar.inputTextView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, self.messageBar.inputTextView.contentInset.right);
    [AppPublic roundCornerRadius:self.messageBar.inputTextView];
    
    UIButton *sendBtn = NewButton(CGRectMake(0, 0, kInputTextViewMinHeight, kInputTextViewMinHeight), nil, nil, nil);
    [sendBtn setImage:[UIImage imageNamed:@"icon_send_comment"] forState:UIControlStateNormal];
    sendBtn.right = self.messageBar.inputTextView.right;
    sendBtn.centerY = self.messageBar.inputTextView.centerY;
    [sendBtn addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.messageBar addSubview:sendBtn];
    
    [self.messageBar addSubview:NewSeparatorLine(CGRectMake(0, 0, self.messageBar.width, appSeparaterLineSize))];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"musicId" : self.musicId}];
    //    [self doShowHudFunction];
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

- (void)doCommentPublishFunction:(NSString *)content {
    if (!content.length) {
        return;
    }
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"MusicId" : self.musicId, @"UserId" : [UserPublic getInstance].userData.Extra.userinfo.ID}];
    if (self.remindOne) {
        [m_dic setObject:self.remindOne.Id forKey:@"CommentId"];
        [m_dic setObject:self.remindOne.User.Id forKey:@"ToUserId"];
        
        NSString *prefix = self.remindOne.showStringPrefixForRemind;
        if ([content hasPrefix:prefix]) {
            [m_dic setObject:[content substringFromIndex:prefix.length] forKey:@"Content"];
        }
        else {
            [m_dic setObject:content forKey:@"Content"];
        }
        
    }
    else {
        [m_dic setObject:content forKey:@"Content"];
    }
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Post:m_dic HeadParm:nil URLFooter:@"Music/Comment" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            weakself.messageBar.inputTextView.text = @"";
            AppCommentInfo *item = [AppCommentInfo mj_objectWithKeyValues:responseBody[@"Data"]];
            item.User.Name = [[UserPublic getInstance].userData.Extra.userinfo.NickName copy];
            item.User.Image = [[UserPublic getInstance].userData.Extra.userinfo.Image copy];
            if (weakself.remindOne) {
                item.ToUser = [weakself.remindOne.User copy];
                weakself.remindOne = nil;
            }
            [weakself.dataSource addObject:item];
            [weakself updateSubviews];
//            [weakself scrollViewToBottom:NO];
        }
    }];
}

- (void)doCommentLikeFunction:(NSInteger)row {
    if (row > self.dataSource.count - 1) {
        return;
    }
    AppCommentInfo *item = self.dataSource[row];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"id" : item.Id, @"like" : stringWithBoolValue(!item.HasMakeGood)}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Post:nil HeadParm:nil URLFooter:[NSString stringWithFormat:@"Music/Comment/Like?%@", AFQueryStringFromParameters(m_dic)] completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            item.HasMakeGood = !item.HasMakeGood;
            if (item.HasMakeGood) {
                item.LikeCount++;
            }
            else {
                item.LikeCount--;
            }
            [weakself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)sendButtonAction:(UIButton *)button {
    [self doCommentPublishFunction:self.messageBar.inputTextView.text];
}

- (void)likeButtonAction:(UIButton *)button {
    [self doCommentLikeFunction:button.tag];
}

- (void)scrollViewToBottom:(BOOL)animated{
    if (self.tableView.contentSize.height > self.tableView.height){
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

- (void)removeInputCurrentRemindUserName {
    if (!self.remindOne) {
        return;
    }
    NSString *prefix = self.remindOne.showStringPrefixForRemind;
    if ([self.messageBar.inputTextView.text hasPrefix:prefix]) {
        self.messageBar.inputTextView.text = [self.messageBar.inputTextView.text substringFromIndex:prefix.length];
    }
    self.remindOne = nil;
}

- (void)addInputCurrentRemindUserName {
    NSString *prefix = self.remindOne.showStringPrefixForRemind;
    self.messageBar.inputTextView.text = [NSString stringWithFormat:@"%@%@", prefix, self.messageBar.inputTextView.text];
}

#pragma mark - getter
- (PublicMessageToolBar *)messageBar {
    if (!_messageBar) {
        _messageBar = [[PublicMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.height - [PublicMessageToolBar defaultHeight], screen_width, [PublicMessageToolBar defaultHeight]) type:ToolButtonTypeSendOnly];
        _messageBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _messageBar.delegate = self;
    }
    return _messageBar;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppCommentInfo *item = self.dataSource[indexPath.row];
    return [MusicCommentCell tableView:tableView heightForRowAtIndexPath:indexPath andSubTitle:item.showStringForContent];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    MusicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MusicCommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.likeBtn addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.data = self.dataSource[indexPath.row];
    cell.likeBtn.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppCommentInfo *item = self.dataSource[indexPath.row];
    if (![item.Id isEqualToString:self.remindOne.Id]) {
        [self removeInputCurrentRemindUserName];
        self.remindOne = item;
        [self addInputCurrentRemindUserName];
    }
}

#pragma mark - PublicMessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(PublicMessageTextView *)messageInputTextView {
    //    [_menuController setMenuItems:nil];
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = self.navigationBarView.bottom;
        rect.size.height = self.view.frame.size.height - self.navigationBarView.bottom - toHeight;
        self.tableView.frame = rect;
    }];
}

- (void)didSendText:(NSString *)text {
    if (text && text.length > 0) {
        [self doCommentPublishFunction:text];
    }
}

- (BOOL)inputTextView:(PublicMessageTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.remindOne) {
        NSString *prefix = [NSString stringWithFormat:@"@%@：", self.remindOne.User.Name];
        if ([text isEqualToString:@""]) {
            if (range.location + range.length <= prefix.length) {
                [self removeInputCurrentRemindUserName];
                return NO;
            }
        }
        else {
            if (range.location + range.length < prefix.length) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)inputTextViewDidChange:(PublicMessageTextView *)messageInputTextView {
    if (messageInputTextView.text.length > kInputLengthMax){
        messageInputTextView.text = [messageInputTextView.text substringToIndex:kInputLengthMax];
    }
}

@end
