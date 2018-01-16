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

- (void)doPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)showFromVC:(PublicViewController *)fromVC;
- (UIViewController *)doPopViewControllerAnimated:(BOOL)animated;
- (NSArray<__kindof UIViewController *> *)doPopToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (NSArray<__kindof UIViewController *> *)doPopToLastViewControllerSkip:(NSUInteger)skip animated:(BOOL)animated;

@end
