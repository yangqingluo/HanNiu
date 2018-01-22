//
//  PublicInputView.m
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicInputView.h"

@implementation PublicInputView

PublicInputView *NewPublicInputView(CGRect frame, NSString *placeHolder, NSString *leftImageName) {
    PublicInputView *inputView = [[PublicInputView alloc] initWithFrame:frame];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, inputView.width - 2 * 30, inputView.height)];
    textField.placeholder = placeHolder;
    textField.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
//    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.textColor = [UIColor whiteColor];
    [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [inputView addSubview:textField];
    inputView.textField = textField;
    
    [inputView addTextField:textField imageName:leftImageName];
    
    inputView.lineView = NewSeparatorLine(CGRectMake(0, inputView.height - 1, inputView.width, 1));
    [inputView addSubview:inputView.lineView];
    return inputView;
}

- (void)addTextField:(UITextField *)textField imageName:(NSString *)imageName {
    if (!imageName.length) {
        return;
    }
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MIN(self.height, 30), self.height)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.centerY = 0.5 * leftView.height;
    [leftView addSubview:imageView];
    
    leftView.centerY = 0.5 * self.height;
    [self addSubview:leftView];
    self.leftView = leftView;
//    textField.leftView = leftView;
//    textField.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - getter
- (NSString *)text {
    return self.textField.text;
}

@end
