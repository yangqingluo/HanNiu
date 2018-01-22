//
//  PublicAlertShowGraphView.m
//  HanNiu
//
//  Created by 7kers on 2018/1/22.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicAlertShowGraphView.h"

@interface PublicAlertShowGraphView ()

@property (strong, nonatomic) UIView *baseView;

@end

@implementation PublicAlertShowGraphView

- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeHuge, 0, self.width - 2 * kEdgeHuge, 280)];
        _baseView.backgroundColor = [UIColor whiteColor];
        [AppPublic roundCornerRadius:_baseView cornerRadius:appViewCornerRadiusBig];
        _baseView.centerY = 0.4 * self.height;
        [self addSubview:_baseView];
        
        UILabel *titleLabel = NewLabel(CGRectMake(0, 0, _baseView.width, 80), appTextColor, [AppPublic boldAppFontOfSize:appButtonTitleFontSize], NSTextAlignmentCenter);
        titleLabel.text = @"图形验证码";
        [_baseView addSubview:titleLabel];
        
        [_baseView addSubview:NewSeparatorLine(CGRectMake(kEdgeHuge, titleLabel.bottom, _baseView.width - 2 * kEdgeHuge, appSeparaterLineSize))];
        
        _graphView = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + kEdgeBig, 110, 40)];
        _graphView.centerX = 0.5 * _baseView.width;
        [_baseView addSubview:_graphView];
        
        _inputView = NewPublicInputView(CGRectMake(kEdgeHuge, _graphView.bottom + kEdgeSmall, _baseView.width - 2 * kEdgeHuge, 44), @"请输入图片中算式的结果", nil);
        _inputView.lineView.backgroundColor = appMainColor;
        _inputView.textField.textAlignment = NSTextAlignmentCenter;
        _inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
        _inputView.textField.returnKeyType = UIReturnKeyDone;
        _inputView.textField.textColor = appTextColor;
        [_inputView.textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        _inputView.lineView.bottom -= kEdge;
        _inputView.lineView.left = _inputView.textField.left;
        _inputView.lineView.width = _inputView.textField.width;
        [_baseView addSubview:_inputView];
        
        UIButton *sureBtn = NewButton(CGRectMake(kEdgeToScreen, _inputView.bottom + kEdgeBig, _baseView.width - 2 * kEdgeToScreen, 44), @"确定", [UIColor whiteColor], nil);
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"back_dialog_confirm_btn"] forState:UIControlStateNormal];
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"back_dialog_confirm_btn"] forState:UIControlStateHighlighted];
        [_baseView addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancelBtn = NewButton(CGRectMake(0, 0, 30, 30), nil, nil, nil);
        [cancelBtn setImage:[UIImage imageNamed:@"icon_close_dialog"] forState:UIControlStateNormal];
        cancelBtn.bottom = self.height - kEdgeHuge;
        cancelBtn.centerX = 0.5 * self.width;
        [self addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
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
    [self.inputView.textField resignFirstResponder];
    if (!self.inputView.text.length) {
        [[AppPublic getInstance].topViewController showHint:@"请输入图片中算式的结果"];
        return;
    }
    
    if (self.block) {
        [self dismiss];
        self.block(self, 1);
    }
}

@end
