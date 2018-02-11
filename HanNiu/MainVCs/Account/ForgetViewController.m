//
//  ForgetViewController.m
//  HanNiu
//
//  Created by 7kers on 2018/1/17.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "ForgetViewController.h"

#import "PublicInputView.h"
#import "PublicAlertView.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface ForgetViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) PublicInputView *phoneInputView;
@property (strong, nonatomic) PublicInputView *vcodeInputView;
@property (strong, nonatomic) PublicInputView *passwordInputView;
@property (strong, nonatomic) UIButton *vcodeBtn;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_login_fragment"]];
    
    self.phoneInputView = NewPublicInputView(CGRectMake(kEdgeToScreen, 120, screen_width - 2 * kEdgeToScreen, 44), @"手机号", @"icon_phone");
    self.phoneInputView.textField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneInputView.textField.delegate = self;
    [self.view addSubview:self.phoneInputView];
    
    self.vcodeInputView = NewPublicInputView(self.phoneInputView.frame, @"请输入短信验证码", @"icon_verify_code");
    self.vcodeInputView.textField.keyboardType = UIKeyboardTypePhonePad;
    self.vcodeInputView.textField.delegate = self;
    self.vcodeInputView.top = self.phoneInputView.bottom + 40;
    [self.view addSubview:self.vcodeInputView];
    
    self.passwordInputView = NewPublicInputView(self.phoneInputView.frame, @"新密码", @"icon_login_password");
    self.passwordInputView.textField.secureTextEntry = YES;
    self.passwordInputView.textField.delegate = self;
    self.passwordInputView.top = self.vcodeInputView.bottom + 30;
    [self.view addSubview:self.passwordInputView];
    
    self.vcodeBtn = NewButton(CGRectMake(0, 0, 70, 28), @"获取验证码", [UIColor whiteColor], [AppPublic appFontOfSize:appLabelFontSizeTiny]);
    [self.vcodeBtn setBackgroundImage:[UIImage imageNamed:@"back_register_btn"] forState:UIControlStateNormal];
    [self.vcodeBtn setBackgroundImage:[UIImage imageNamed:@"back_register_btn"] forState:UIControlStateHighlighted];
    self.vcodeBtn.right = self.vcodeInputView.width;
    self.vcodeBtn.centerY = self.vcodeInputView.textField.centerY;
    self.vcodeInputView.textField.width -= (self.vcodeBtn.width + kEdge);
    [self.vcodeInputView addSubview:self.vcodeBtn];
    
    UIButton *sureBtn = NewTextButton(@"确定", appMainColor);
    sureBtn.frame = self.passwordInputView.frame;
    sureBtn.top = self.passwordInputView.bottom + 50;
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"back_login_btn"] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"back_login_btn"] forState:UIControlStateHighlighted];
    [self.view addSubview:sureBtn];
    
    [sureBtn addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_vcodeBtn addTarget:self action:@selector(vcodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initializeNavigationBar {
    [super initializeNavigationBar];
    self.navigationBarView.image = nil;
}

- (void)waitForGettingCodeAgain:(NSNumber *)timeToGetCodeAgain{
    if ([timeToGetCodeAgain intValue]) {
        self.vcodeBtn.enabled = NO;
        [self.vcodeBtn setTitle:[NSString stringWithFormat:@"%@s",timeToGetCodeAgain] forState:UIControlStateDisabled];
        timeToGetCodeAgain = [NSNumber numberWithInt:([timeToGetCodeAgain intValue] - 1)];
        [self performSelector:@selector(waitForGettingCodeAgain:) withObject:timeToGetCodeAgain afterDelay:1.0];
    }
    else{
        self.vcodeBtn.enabled = YES;
    }
}

- (void)sureButtonAction {
    [self dismissKeyboard];
    if (!isMobilePhone(self.phoneInputView.text)) {
        [self doShowHintFunction:@"请输入正确的手机号"];
    }
    else if (self.vcodeInputView.text.length != kVCodeNumberLength){
        [self doShowHintFunction:@"请输入正确的验证码"];
    }
    else if (self.passwordInputView.text.length < kPasswordLengthMin){
        [self doShowHintFunction:@"密码长度不正确"];
    }
    else {
        [self doResetPasswordFunction];
    }
}

- (void)vcodeButtonAction {
    [self dismissKeyboard];
    if (!isMobilePhone(self.phoneInputView.text)) {
        [self doShowHintFunction:@"请输入正确的手机号"];
        return;
    }
    [self doGetVCodeFunction:nil];
//    [self doVfyGetGphFunction];
}

- (void)doGetVCodeFunction:(NSString *)gphCode {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"Username" : self.phoneInputView.text, @"Type" : @1}];
    if (gphCode.length) {
        [m_dic setObject:gphCode forKey:@"gphCode"];
    }
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Post:m_dic HeadParm:nil URLFooter:@"Account/Vfy/SendSms" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            if (error.code == HTTP_ERR_NEED_VFY) {
                [weakself doVfyGetGphFunction];
            }
            else {
                [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
            }
        }
        else {
            [weakself waitForGettingCodeAgain:@120];
        }
    }];
}

- (void)doResetPasswordFunction {
    UserParam *parm = [UserParam new];
    parm.Name = self.phoneInputView.text;
    parm.NewPwd = self.passwordInputView.text;
    parm.VerifyCode = self.vcodeInputView.text;
    parm.PwdMode = @"0";
    parm.Role = @"0";
    parm.ClientId = @"2";
    
    NSDictionary *m_dic = [parm mj_keyValues];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Post:m_dic HeadParm:nil URLFooter:@"Account/Pwd/Rst" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself doShowHintFunction:@"重置密码成功"];
            [weakself goBackWithDone:NO];
        }
    }];
}

- (void)doVfyGetGphFunction {
    NSString *key = urlStringWithService([NSString stringWithFormat:@"Account/Vfy/GetGph?username=%@", self.phoneInputView.text]);
    PublicAlertShowGraphView *alert = [PublicAlertShowGraphView new];
    [alert.graphView sd_setImageWithURL:[NSURL URLWithString:key] placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        [[SDImageCache sharedImageCache] removeImageForKey:key];
    }];
    
    QKWEAKSELF;
    alert.block = ^(PublicAlertView *view, NSInteger index) {
        if (index == 1) {
            [weakself doGetVCodeFunction:((PublicAlertShowGraphView *)view).inputView.text];
        }
    };
    [alert show];
}

#pragma mark - getter

#pragma mark - TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSInteger length = kInputLengthMax;
    BOOL m_bool = YES;
    if ([textField isEqual:self.phoneInputView.text]) {
        NSCharacterSet *notNumber = [[NSCharacterSet characterSetWithCharactersInString:appNumberWithoutPoint] invertedSet];
        NSString *string1 = [[string componentsSeparatedByCharactersInSet:notNumber]componentsJoinedByString:@""];
        m_bool = [string isEqualToString:string1];
        length = kPhoneNumberLength;
    }
    else if ([textField isEqual:self.passwordInputView.text]) {
        length = kPasswordLengthMax;
    }
    else if ([textField isEqual:self.vcodeInputView.text]) {
        length = kVCodeNumberLength;
    }
    return m_bool && (range.location < length);
}

@end
