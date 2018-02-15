//
//  AccountEditPropertyVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/15.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AccountEditPropertyVC.h"

#import "PublicInputView.h"

@interface AccountEditPropertyVC ()<UITextFieldDelegate>

@property (strong, nonatomic) PublicInputView *nickNameInputView;

@end

@implementation AccountEditPropertyVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
//
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_login_fragment"]];
    
    self.nickNameInputView = NewPublicInputView(CGRectMake(kEdgeHuge, 120, screen_width - 2 * kEdgeHuge, 44), notNilString(self.userData.NickName, @"请输入昵称"), nil);
    self.nickNameInputView.textField.textAlignment = NSTextAlignmentCenter;
    self.nickNameInputView.textField.textColor = appTextColor;
    [self.nickNameInputView.textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.nickNameInputView.textField.delegate = self;
    self.nickNameInputView.lineView.backgroundColor = appMainColor;
    [self.view addSubview:self.nickNameInputView];
    
    UIButton *sureBtn = NewTextButton(@"确定", [UIColor whiteColor]);
    sureBtn.frame = self.nickNameInputView.frame;
    sureBtn.top = self.nickNameInputView.bottom + 50;
    sureBtn.backgroundColor = appMainColor;
    [AppPublic roundCornerRadius:sureBtn];
    [self.view addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doUpdateUserNickNameFunction:(NSString *)nickName {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:self.userData.mj_keyValues];
    [m_dic setObject:nickName forKey:@"NickName"];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Post:m_dic HeadParm:nil URLFooter:@"UserInfo?v=1" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [UserPublic getInstance].userData.Extra.userinfo = [AppUserInfo mj_objectWithKeyValues:responseBody[@"Data"]];
            [[UserPublic getInstance] saveUserData:nil];
            weakself.userData = nil;
            [weakself goBackWithDone:YES];
        }
    }];
}

- (void)sureButtonAction {
    [self dismissKeyboard];
    if (!self.nickNameInputView.text.length) {
        [self doShowHintFunction:@"请输入要修改的昵称"];
        return;
    }
    [self doUpdateUserNickNameFunction:self.nickNameInputView.text];
}
@end
