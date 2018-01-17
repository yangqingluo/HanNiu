//
//  LoginViewController.m
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "LoginViewController.h"

#import "PublicInputView.h"
#import "UILabel+YBAttributeTextTapAction.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) PublicInputView *usernameInputView;
@property (strong, nonatomic) PublicInputView *passwordInputView;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated{
    //如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar_back"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_login_fragment"]];
    
    self.usernameInputView = NewPublicInputView(CGRectMake(kEdgeToScreen, 120, screen_width - 2 * kEdgeToScreen, 44), @"请输入手机号", @"icon_login_username");
    self.usernameInputView.textField.textAlignment = NSTextAlignmentCenter;
    self.usernameInputView.textField.keyboardType = UIKeyboardTypePhonePad;
    self.usernameInputView.textField.delegate = self;
    [self.view addSubview:self.usernameInputView];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.usernameInputView.textField.text = [ud objectForKey:kUserName];
    
    self.passwordInputView = NewPublicInputView(self.usernameInputView.frame, @"请输入密码", @"icon_login_password");
    self.passwordInputView.top = self.usernameInputView.bottom + 40;
    self.passwordInputView.textField.textAlignment = NSTextAlignmentCenter;
    self.passwordInputView.textField.secureTextEntry = YES;
    self.passwordInputView.textField.delegate = self;
    [self.view addSubview:self.passwordInputView];
    
    UIButton *loginBtn = NewTextButton(@"登录", RGBA(0xff, 0x4f, 0x6e, 1.0));
    loginBtn.frame = self.usernameInputView.frame;
    loginBtn.top = self.passwordInputView.bottom + 50;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"back_login_btn"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"back_login_btn"] forState:UIControlStateHighlighted];
    [self.view addSubview:loginBtn];
    
    UIView *lineView = NewSeparatorLine(CGRectMake(0, screen_height - 80 - 30, 1, 24));
    lineView.centerX = 0.5 * screen_width;
    [self.view addSubview:lineView];
    
    UIButton *forgetBtn = NewButton(CGRectMake(0, 0, 80, lineView.height), @"忘记密码", [UIColor whiteColor], [AppPublic appFontOfSize:appButtonTitleFontSizeSmall]);
    forgetBtn.centerY = lineView.centerY;
    forgetBtn.right = lineView.left;
    [self.view addSubview:forgetBtn];
    
    UIButton *registBtn = NewButton(forgetBtn.bounds, @"用户注册", [UIColor whiteColor], [AppPublic appFontOfSize:appButtonTitleFontSizeSmall]);
    registBtn.centerY = lineView.centerY;
    registBtn.left = lineView.right;
    [self.view addSubview:registBtn];
    
    [loginBtn addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn addTarget:self action:@selector(forgetButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [registBtn addTarget:self action:@selector(registButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *agreementString = @"服务条款";
    NSDictionary *dic1 = @{NSForegroundColorAttributeName : appTextLightColor};
    NSDictionary *dic2 = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    NSMutableAttributedString *m_string = [NSMutableAttributedString new];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:@"登录即代表阅读并同意  " attributes:dic1]];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:agreementString attributes:dic2]];
    NSMutableParagraphStyle *m_style = [NSMutableParagraphStyle new];
    m_style.alignment = NSTextAlignmentCenter;
    m_style.lineSpacing = 0;
    [m_string addAttribute:NSParagraphStyleAttributeName value:m_style range:NSMakeRange(0, m_string.length)];
    
    UILabel *agreementLabel = NewLabel(CGRectMake(0, lineView.bottom + kEdgeMiddle, screen_width, 40), appTextLightColor, [AppPublic appFontOfSize:appLabelFontSizeLittle], NSTextAlignmentCenter);
    agreementLabel.attributedText = m_string;
    [self.view addSubview:agreementLabel];
    
    QKWEAKSELF;
    [agreementLabel yb_addAttributeTapActionWithStrings:@[agreementString] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        [weakself agreeButtonAction];
    }];
}

- (void)loginButtonAction {
    [self dismissKeyboard];
    if (!isMobilePhone(self.usernameInputView.text)) {
        [self showHint:@"请输入正确的手机号"];
        return;
    }
    else if (self.passwordInputView.text.length < kPasswordLengthMin) {
        [self showHint:@"密码为6-16位字母数字组合"];
        return;
    }
    
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] loginWithID:self.usernameInputView.text Password:self.passwordInputView.text completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself showHint:error.userInfo[@"message"]];
        }
    }];
}

- (void)forgetButtonAction {
    [self doShowHintFunction:@"忘记"];
}

- (void)registButtonAction {
    [self doShowHintFunction:@"注册"];
}

- (void)agreeButtonAction {
    [self doShowHintFunction:@"服务条款"];
}




@end
