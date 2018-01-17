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
#import "BlockAlertView.h"
#import "AppType.h"
#import "MJExtension.h"
#import "AppNetwork.h"


@interface AppPublic : NSObject

+ (AppPublic *)getInstance;

/*!
 @brief 检查版本是否第一次使用
 */
BOOL isFirstUsing();

/*!
 @brief 检查字符串是否是手机号码
 */
BOOL isMobilePhone(NSString *string);

/*!
 @brief 检查字符串是否是邮件地址
 */
BOOL isEmailAdress(NSString *string);

/*!
 @brief sha1加密
 */
NSString *sha1(NSString *string);

/*!
 @brief 替换空字符串
 */
NSString *notNilString(NSString *string, NSString *placeString);

/*!
 @brief 字典转中文字符串
 */
+ (NSString *)logDic:(NSDictionary *)dic;

//判断是否是全数字
BOOL stringIsNumberString(NSString *string, BOOL withPoint);

//图像压缩
NSData *dataOfImageCompression(UIImage *image, BOOL isHead);

//生成视图
UIButton *NewBackButton(UIColor *color);
UIButton *NewRightButton(UIImage *image, UIColor *color);
UIButton *NewTextButton(NSString *title, UIColor *textColor);
UIButton *NewButton(CGRect frame, NSString *title, UIColor *textColor, UIFont *font);
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


- (void)logout;
- (void)loginDoneWithUserData:(NSDictionary *)data username:(NSString *)username password:(NSString *)password;

- (void)goToMainVC;
- (void)goToLoginCompletion:(void (^)(void))completion;

@end
