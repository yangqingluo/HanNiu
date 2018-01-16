//
//  PublicViewController.m
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicViewController.h"

@interface PublicViewController ()

@end

@implementation PublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = appLightWhiteColor;
}

#pragma mark - public
- (void)doPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.parentVC) {
        [self.parentVC.navigationController pushViewController:viewController animated:animated];
    }
    else {
        [self.navigationController pushViewController:viewController animated:animated];
    }
}
- (void)showFromVC:(PublicViewController *)fromVC {
    [fromVC doPushViewController:self animated:YES];
}
- (UIViewController *)doPopViewControllerAnimated:(BOOL)animated {
    if (self.parentVC) {
        return [self.parentVC.navigationController popViewControllerAnimated:animated];
    }
    else {
        return [self.navigationController popViewControllerAnimated:animated];
    }
}
- (NSArray<__kindof UIViewController *> *)doPopToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.parentVC) {
        return [self.parentVC.navigationController popToViewController:viewController animated:animated];
    }
    else {
        return [self.navigationController popToViewController:viewController animated:animated];
    }
}
- (NSArray<__kindof UIViewController *> *)doPopToLastViewControllerSkip:(NSUInteger)skip animated:(BOOL)animated {
    return [self doPopToLastViewControllerSkip:skip animated:animated fromViewController:self.parentVC ? self.parentVC : self];
}

- (NSArray<__kindof UIViewController *> *)doPopToLastViewControllerSkip:(NSUInteger)skip animated:(BOOL)animated fromViewController:(UIViewController *)viewController {
    NSArray *m_array = viewController.navigationController.viewControllers;
    NSUInteger count = m_array.count;
    if (skip > 0 && skip <= count - 1) {
        UIViewController *VC = m_array[count - 1 - skip];
        return [viewController.navigationController popToViewController:VC animated:animated];
    }
    else {
        return nil;
    }
}

@end
