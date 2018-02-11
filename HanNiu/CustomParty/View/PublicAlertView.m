//
//  PublicAlertView.m
//  HanNiu
//
//  Created by 7kers on 2018/1/22.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicAlertView.h"

@interface PublicAlertView ()

@end

@implementation PublicAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.6);
    }
    return self;
}

- (instancetype)initWithContentView:(UIView *)contentView {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        //        self.userInteractionEnabled = YES;
        //        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        //        [self addGestureRecognizer:tapGesture];
        [self addSubview:contentView];
    }
    return self;
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)show {
    [[AppPublic getInstance].topViewController.view addSubview:self];
}

@end


@implementation PublicAlertShowView

- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeHuge, 0, self.width - 2 * kEdgeHuge, 280)];
        _baseView.backgroundColor = [UIColor whiteColor];
        [AppPublic roundCornerRadius:_baseView cornerRadius:appViewCornerRadiusBig];
        _baseView.centerY = 0.4 * self.height;
        [self addSubview:_baseView];
        
        _titleLabel = NewLabel(CGRectMake(0, 0, self.baseView.width, 80), appTextColor, [AppPublic boldAppFontOfSize:appButtonTitleFontSize], NSTextAlignmentCenter);
        [self.baseView addSubview:_titleLabel];
        
        UIButton *sureBtn = NewButton(CGRectMake(kEdgeToScreen, 200, _baseView.width - 2 * kEdgeToScreen, 44), @"确定", [UIColor whiteColor], nil);
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"back_dialog_confirm_btn"] forState:UIControlStateNormal];
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"back_dialog_confirm_btn"] forState:UIControlStateHighlighted];
        [self.baseView addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancelBtn = NewButton(CGRectMake(0, 0, 30, 30), nil, nil, nil);
        [cancelBtn setImage:[UIImage imageNamed:@"icon_close_dialog"] forState:UIControlStateNormal];
        cancelBtn.bottom = self.height - kEdgeHuge;
        cancelBtn.centerX = 0.5 * self.width;
        [self addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.sureButton = sureBtn;
        self.cancelButton = cancelBtn;
    }
    return self;
}

- (void)cancelButtonAction {
    if (self.block) {
        [self dismiss];
        self.block(self, 0);
    }
}

- (void)sureButtonAction {
    if (self.block) {
        [self dismiss];
        self.block(self, 1);
    }
}

@end

@implementation PublicAlertShowGraphView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleLabel.text = @"图形验证码";
        _graphView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.titleLabel.bottom + kEdgeBig, 110, 40)];
        _graphView.centerX = 0.5 * self.baseView.width;
        [self.baseView addSubview:_graphView];
        
        _inputView = NewPublicInputView(CGRectMake(kEdgeHuge, _graphView.bottom + kEdgeSmall, self.baseView.width - 2 * kEdgeHuge, 44), @"请输入图片中算式的结果", nil);
        _inputView.lineView.backgroundColor = appMainColor;
        _inputView.textField.textAlignment = NSTextAlignmentCenter;
        _inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
        _inputView.textField.returnKeyType = UIReturnKeyDone;
        _inputView.textField.textColor = appTextColor;
        [_inputView.textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        _inputView.lineView.bottom -= kEdge;
        _inputView.lineView.left = _inputView.textField.left;
        _inputView.lineView.width = _inputView.textField.width;
        [self.baseView addSubview:_inputView];
    }
    return self;
}

- (void)sureButtonAction {
    [self.inputView.textField resignFirstResponder];
    if (!self.inputView.text.length) {
        [[AppPublic getInstance].topViewController showHint:@"请输入图片中算式的结果"];
        return;
    }
    [super sureButtonAction];
}

@end


@implementation PublicAlertShowMusicBuyView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleLabel.text = @"支付购买";
        
        self.nameView = [[PublicSubTitleView alloc] initWithFrame:CGRectMake(kEdgeHuge, self.titleLabel.bottom, self.baseView.width - 2 * kEdgeHuge, 30)];
        [self.baseView addSubview:self.nameView];
        [self.baseView addSubview:NewSeparatorLine(CGRectMake(self.nameView.left, self.nameView.bottom, self.nameView.width, appSeparaterLineSize))];
        
        self.priceView = [[PublicSubTitleView alloc] initWithFrame:CGRectMake(self.nameView.left, self.nameView.bottom + kEdgeBig, self.nameView.width, 20)];
        self.priceView.subTitleLabel.textColor = appMainColor;
        [self.baseView addSubview:self.priceView];
        
        self.balanceView = [[PublicSubTitleView alloc] initWithFrame:CGRectMake(self.priceView.left, self.priceView.bottom + kEdgeMiddle, self.priceView.width, self.priceView.height)];
        [self.baseView addSubview:self.balanceView];
        
        [self.sureButton setTitle:@"确定购买" forState:UIControlStateNormal];
        self.sureButton.bottom = self.baseView.height - 30;
    }
    return self;
}

@end


