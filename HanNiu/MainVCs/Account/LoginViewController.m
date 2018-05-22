//
//  LoginViewController.m
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetViewController.h"
#import "RegistViewController.h"

#import "PublicInputView.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "AppActivity.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) PublicInputView *usernameInputView;
@property (strong, nonatomic) PublicInputView *passwordInputView;

@property (strong, nonatomic) NSString *courseString;

@end

@implementation LoginViewController

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    //设置导航栏背景图片为一个空的image，这样就透明了
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    //去掉透明后导航栏下边的黑边
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    NSArray *m_array = self.navigationController.viewControllers;
//    if (m_array.count > 1 && [m_array objectAtIndex:m_array.count - 2] == self) {
//        //当前视图控制器在栈中，故为push操作
//        NSLog(@"push");
//    } else if ([m_array indexOfObject:self] == NSNotFound) {
//        //当前视图控制器不在栈中，故为pop操作
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar_back"] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:nil];
//    }
//}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    self.usernameInputView = NewPublicInputView(CGRectMake(kEdgeToScreen, 120, screen_width - 2 * kEdgeToScreen, 44), @"请输入手机号", @"icon_login_username");
    self.usernameInputView.textField.textAlignment = NSTextAlignmentCenter;
    self.usernameInputView.textField.keyboardType = UIKeyboardTypePhonePad;
    self.usernameInputView.textField.delegate = self;
    [self.view addSubview:self.usernameInputView];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:kUserName];
    if (isMobilePhone(username)) {
        self.usernameInputView.textField.text = username;
    }
    
    self.passwordInputView = NewPublicInputView(self.usernameInputView.frame, @"请输入密码", @"icon_login_password");
    self.passwordInputView.top = self.usernameInputView.bottom + 40;
    self.passwordInputView.textField.textAlignment = NSTextAlignmentCenter;
    self.passwordInputView.textField.secureTextEntry = YES;
    self.passwordInputView.textField.delegate = self;
    [self.view addSubview:self.passwordInputView];
    
    UIButton *loginBtn = NewTextButton(@"登录", appMainColor);
    loginBtn.frame = self.usernameInputView.frame;
    loginBtn.top = self.passwordInputView.bottom + 50;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"back_login_btn"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"back_login_btn"] forState:UIControlStateHighlighted];
    [self.view addSubview:loginBtn];
    
    UIView *lineView = NewSeparatorLine(CGRectMake(0, screen_height - 80 - 30, 1, 24));
    lineView.centerX = 0.5 * screen_width;
    [self.view addSubview:lineView];
    
    UIButton *forgetBtn = NewButton(CGRectMake(0, 0, 80, 30), @"忘记密码", [UIColor whiteColor], [AppPublic appFontOfSize:appButtonTitleFontSizeSmall]);
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
    UILabel *agreementLabel = [self createAttributeTapLabel:agreementString noteString:@"登录即代表阅读并同意  " frame:CGRectMake(0, lineView.bottom + kEdgeMiddle, screen_width, 20)];
    [self.view addSubview:agreementLabel];
    
    QKWEAKSELF;
    [agreementLabel yb_addAttributeTapActionWithStrings:@[agreementString] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        [weakself agreeButtonAction];
    }];
    
    NSString *visitorString = @"游客登录";
    UILabel *visitorLabel = [self createAttributeTapLabel:visitorString noteString:@"随便看看可以  " frame:CGRectMake(0, agreementLabel.bottom + kEdge, screen_width, 20)];
    [self.view addSubview:visitorLabel];
    
    [visitorLabel yb_addAttributeTapActionWithStrings:@[visitorString] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        [weakself visitButtonAction];
    }];
}

- (UILabel *)createAttributeTapLabel:(NSString *)tabString noteString:(NSString *)noteString frame:(CGRect)frame {
    NSDictionary *dic1 = @{NSForegroundColorAttributeName : appTextLightColor};
    NSDictionary *dic2 = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    NSMutableAttributedString *m_string = [NSMutableAttributedString new];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:noteString attributes:dic1]];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:tabString attributes:dic2]];
    NSMutableParagraphStyle *m_style = [NSMutableParagraphStyle new];
    m_style.alignment = NSTextAlignmentCenter;
    m_style.lineSpacing = 0;
    [m_string addAttribute:NSParagraphStyleAttributeName value:m_style range:NSMakeRange(0, m_string.length)];
    
    UILabel *label = NewLabel(frame, appTextLightColor, [AppPublic appFontOfSize:appLabelFontSizeLittle], NSTextAlignmentCenter);
    label.attributedText = m_string;
    return label;
}

- (void)loginButtonAction {
    [self dismissKeyboard];
    if (!isMobilePhone(self.usernameInputView.text)) {
        [self doShowHintFunction:@"请输入正确的手机号"];
        return;
    }
    else if (self.passwordInputView.text.length < kPasswordLengthMin) {
        [self doShowHintFunction:@"密码为6-16位字母数字组合"];
        return;
    }
    
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] loginWithID:self.usernameInputView.text Password:self.passwordInputView.text completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself goBackWithDone:NO];
        }
    }];
}

- (void)forgetButtonAction {
    ForgetViewController *vc = [ForgetViewController new];
    [self doPushViewController:vc animated:YES];
}

- (void)registButtonAction {
    RegistViewController *vc = [RegistViewController new];
    [self doPushViewController:vc animated:YES];
}

- (void)agreeButtonAction {
    AppActivity *activity = [[AppActivity alloc]initWithTitle:@"服务条款" message:self.courseString delegate:self cancelButtonTitle:@"取消" otherButtonTitle:@"确认"];
    [activity showInView:self.view];
}

- (void)visitButtonAction {
    QKWEAKSELF;
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"游客登录" message:@"游客登录后购买记录等用户数据可能会丢失，请谨慎使用" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakself doVisitorLoginFunction];
        }
    } otherButtonTitles:@"游客登录", nil];
    [alert show];
}

- (void)doVisitorLoginFunction {
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] visitorLoginCompletion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself goBackWithDone:NO];
        }
    }];
}

#pragma mark - getter
- (NSString *)courseString {
    if (!_courseString) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"agreement" ofType:@"txt"];
        NSData *courseData = [NSData dataWithContentsOfFile:path];
        NSStringEncoding strEncode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        _courseString = [[NSString alloc]initWithData:courseData encoding:strEncode];
    }
    
    return _courseString;
}

@end
