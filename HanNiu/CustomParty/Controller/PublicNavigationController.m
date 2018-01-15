//
//  PublicNavigationController.m
//  HanNiu
//
//  Created by 7kers on 2018/1/15.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicNavigationController.h"

@interface PublicNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation PublicNavigationController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initInteractivePopGestureRecognizer];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self initInteractivePopGestureRecognizer];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initInteractivePopGestureRecognizer];
}

- (void)initInteractivePopGestureRecognizer {
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.childViewControllers.count > 1;
}


@end
