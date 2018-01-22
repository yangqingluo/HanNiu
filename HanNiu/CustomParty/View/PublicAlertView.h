//
//  PublicAlertView.h
//  HanNiu
//
//  Created by 7kers on 2018/1/22.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicAlertView : UIView

typedef void(^ActionAlertBlock)(PublicAlertView *view, NSInteger index);

@property (strong, nonatomic) ActionAlertBlock block;

- (instancetype)initWithContentView:(UIView *)contentView;
- (void)show;
- (void)dismiss;

@end
