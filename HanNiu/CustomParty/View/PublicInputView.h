//
//  PublicInputView.h
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicInputView : UIView

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) NSString *text;

PublicInputView *NewPublicInputView(CGRect frame, NSString *placeHolder, NSString *leftImageName);

@end
