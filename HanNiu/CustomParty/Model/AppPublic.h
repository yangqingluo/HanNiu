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
#import "UIView+KGViewExtend.h"
#import "AppType.h"
#import "MJExtension.h"
#import "AppType.h"

@interface AppPublic : NSObject

+ (AppPublic *)getInstance;

//判断是否是全数字
BOOL stringIsNumberString(NSString *string, BOOL withPoint);

//图像压缩
NSData *dataOfImageCompression(UIImage *image, BOOL isHead);

//生成视图
UIButton *NewBackButton(UIColor *color);
UIButton *NewRightButton(UIImage *image, UIColor *color);
UIButton *NewTextButton(NSString *title, UIColor *textColor);
UILabel *NewLabel(CGRect frame, UIColor *textColor, UIFont *font, NSTextAlignment alignment);
UIView *NewSeparatorLine(CGRect frame);

//日期-文本转换
NSDate *dateFromString(NSString *dateString, NSString *format);
NSString *stringFromDate(NSDate *date, NSString *format);
NSString *dateStringWithTimeString(NSString *string);
NSDate *dateWithPriousorLaterDate(NSDate *date, int month);

//文本尺寸
+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantWidth:(CGFloat)width;
+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantHeight:(CGFloat)height;
+ (void)adjustLabelWidth:(UILabel *)label;
+ (void)adjustLabelHeight:(UILabel *)label;
+ (UIFont *)appFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldAppFontOfSize:(CGFloat)fontSize;
+ (UIFont *)appFontOfPxSize:(CGFloat)pxSize;

@end
