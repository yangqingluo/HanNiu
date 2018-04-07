//
//  AppActivity.h
//  One2Ten2Hundred
//
//  Created by yangqingluo on 16/4/28.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppActivity : UIView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;

- (void)showInView:(UIView *)view;

@property (nonatomic,strong) UITextView *textView;

@end

@protocol AppActivityDelegate <NSObject>

@optional
- (void)didClickOnCancelButton:(AppActivity *)activity;
- (void)didClickOnOtherButton:(AppActivity *)activity;

@end