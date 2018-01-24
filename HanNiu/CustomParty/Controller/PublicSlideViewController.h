//
//  PublicSlideViewController.h
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicViewController.h"

#import "QCSlideSwitchView.h"

@interface PublicSlideViewController : PublicViewController<QCSlideSwitchViewDelegate>

@property (strong, nonatomic) QCSlideSwitchView *slidePageView;
@property (strong, nonatomic) NSMutableArray *viewArray;

- (void)addViewController:(NSString *)title vc:(PublicViewController *)vc;

@end
