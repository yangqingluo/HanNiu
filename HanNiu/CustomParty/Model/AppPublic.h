//
//  AppPublic.h
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+Color.h"
#import "UIViewController+HUD.h"
#import "AppType.h"
#import "MJExtension.h"
#import "AppType.h"

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

#define QKWEAKSELF typeof(self) __weak weakself = self;

#define RGBA(R, G, B, A) [UIColor colorWithRed:R / 255.f green:G / 255.f blue:B / 255.f alpha:A]

#define appMainColor                    RGBA(0x00, 0xbc, 0xd4, 1.0)
#define appRedColor                     RGBA(0xd9, 0x55, 0x55, 1.0)
#define appLightWhiteColor              RGBA(0xf8, 0xf8, 0xf8, 1.0)

@interface AppPublic : NSObject

+ (AppPublic *)getInstance;


@end
