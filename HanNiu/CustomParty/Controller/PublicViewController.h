//
//  PublicViewController.h
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+KGViewExtend.h"

@interface PublicViewController : UIViewController

@property (weak, nonatomic) PublicViewController *parentVC;
@property (copy,   nonatomic) AppDoneBlock doneBlock;
@property (assign, nonatomic) BOOL needRefresh;

- (void)createNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem;
- (void)dismissKeyboard;
- (void)needRefreshNotification:(NSNotification *)notification;
- (void)doShowHintFunction:(NSString *)hint;
- (void)doShowHudFunction;
- (void)doShowHudFunction:(NSString *)hint;
- (void)doHideHudFunction;

- (void)doPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)showFromVC:(PublicViewController *)fromVC;
- (UIViewController *)doPopViewControllerAnimated:(BOOL)animated;
- (NSArray<__kindof UIViewController *> *)doPopToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (NSArray<__kindof UIViewController *> *)doPopToLastViewControllerSkip:(NSUInteger)skip animated:(BOOL)animated;

- (void)cancelButtonAction;
- (void)goBackWithDone:(BOOL)done;
- (void)doDoneAction;

@end
