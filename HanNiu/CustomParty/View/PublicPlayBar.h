//
//  PublicPlayBar.h
//  HanNiu
//
//  Created by 7kers on 2018/1/25.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicPlayBar : UIView

+ (PublicPlayBar *)getInstance;

@property (strong, nonatomic) UIButton *playBtn;

@end
