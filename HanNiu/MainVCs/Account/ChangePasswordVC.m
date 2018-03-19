//
//  ChangePasswordVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/14.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "ChangePasswordVC.h"

#import "PublicInputView.h"

@interface ChangePasswordVC ()<UITextFieldDelegate>

@property (strong, nonatomic) PublicInputView *oldPsdInputView;
@property (strong, nonatomic) PublicInputView *changePsdInputView;

@end

@implementation ChangePasswordVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_login_fragment"]];
    
    self.oldPsdInputView = NewPublicInputView(CGRectMake(kEdgeToScreen, 120, screen_width - 2 * kEdgeToScreen, 44), @"请输入旧密码", @"icon_login_password");
    self.oldPsdInputView.textField.textAlignment = NSTextAlignmentCenter;
    self.oldPsdInputView.textField.secureTextEntry = YES;
    self.oldPsdInputView.textField.delegate = self;
    [self.view addSubview:self.oldPsdInputView];
    
    self.changePsdInputView = NewPublicInputView(self.oldPsdInputView.frame, @"请输入新密码", @"icon_login_password");
    self.changePsdInputView.top = self.oldPsdInputView.bottom + 40;
    self.changePsdInputView.textField.textAlignment = NSTextAlignmentCenter;
    self.changePsdInputView.textField.secureTextEntry = YES;
    self.changePsdInputView.textField.delegate = self;
    [self.view addSubview:self.changePsdInputView];
    
    UIButton *sureBtn = NewTextButton(@"确定", appMainColor);
    sureBtn.frame = self.oldPsdInputView.frame;
    sureBtn.top = self.changePsdInputView.bottom + 50;
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"back_login_btn"] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"back_login_btn"] forState:UIControlStateHighlighted];
    [self.view addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initializeNavigationBar {
    [super initializeNavigationBar];
    self.navigationBarView.image = nil;
}

- (void)sureButtonAction {
    [self dismissKeyboard];
    if (self.oldPsdInputView.text.length < kPasswordLengthMin || self.changePsdInputView.text.length < kPasswordLengthMin) {
        [self doShowHintFunction:@"密码为6-16位字母数字组合"];
        return;
    }
    
    UserParam *parm = [UserParam new];
    parm.CurPwd = self.oldPsdInputView.text;
    parm.NewPwd = self.changePsdInputView.text;
//    parm.PwdMode = @"0";
    parm.Role = @"0";
    parm.ClientId = @"2";
    
    NSDictionary *m_dic = [parm mj_keyValues];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Post:m_dic HeadParm:nil URLFooter:@"Account/Pwd/Mod" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself doShowHintFunction:@"修改成功"];
        }
    }];
}

@end
