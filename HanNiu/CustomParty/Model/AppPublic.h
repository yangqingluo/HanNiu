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

#define iosVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

#define QKWEAKSELF typeof(self) __weak weakself = self;

#define RGBA(R, G, B, A) [UIColor colorWithRed:R / 255.f green:G / 255.f blue:B / 255.f alpha:A]

#define appMainColor                    RGBA(0xff, 0x4f, 0x6e, 1.0)
#define appSeparatorColor               RGBA(0xdb, 0xdb, 0xdb, 1.0)
#define appTextColor                    RGBA(0x21, 0x21, 0x21, 1.0)
#define appTextLightColor               RGBA(0xf2, 0xb4, 0xa9, 1.0)
#define appRedColor                     RGBA(0xd9, 0x55, 0x55, 1.0)
#define appLightWhiteColor              RGBA(0xf2, 0xf2, 0xf2, 1.0)

#define STATUS_HEIGHT                   20.0
#define STATUS_BAR_HEIGHT               64.0
#define TAB_BAR_HEIGHT                  49.0
#define DEFAULT_BAR_HEIGHT              44.0

#define appRefreshTime                  24 * 60 * 60//自动刷新间隔时间
#define appButtonCornerRadius           4.0
#define appViewCornerRadius             4.0
#define appViewCornerRadiusBig          12.0

#define kImageDataMax                   100 * 1024//图像大小上限
#define kHeadImageSizeMax               96//头像图像 宽/高 大小上限

#define kCellHeightSmall                32.0
#define kCellHeight                     44.0
#define kCellHeightFilter               50.0
#define kCellHeightMiddle               60.0
#define kCellHeightBig                  80.0
#define kCellHeightHuge                 100.0

#define kEdgeSmall                      4.0
#define kEdge                           8.0
#define kEdgeMiddle                     12.0
#define kEdgeBig                        16.0
#define kEdgeHuge                       28.0
#define kEdgeToScreen                   60

#define appButtonTitleFontSizeLittle    12.0
#define appButtonTitleFontSizeSmall     14.0
#define appButtonTitleFontSize          16.0
#define appLabelFontSizeLittle          12.0
#define appLabelFontSizeSmall           14.0
#define appLabelFontSize                16.0
#define appLabelFontSizeMiddle          18.0
#define appSeparaterLineSize            0.5//分割线尺寸
#define appPageSize                     10//获取分页数据时分页size

#define kPhoneNumberLength              0x0b
#define kVCodeNumberLength              0x06
#define kPasswordLengthMin              0x03
#define kPasswordLengthMax              0x10
#define kNameLengthMax                  0x20
#define kNumberLengthMax                0x09
#define kPriceLengthMax                 0x06
#define kInputLengthMax                 0x30
#define kIDLengthMax                    0x12//18位身份证号码

#define appNumberWithoutPoint           @"0123456789"
#define appNumberWithPoint              @"0123456789."
#define appNumberWithDash               @"0123456789-"

#define defaultDateFormat               @"yyyy-MM-dd"
#define defaultHeadPlaceImageName       @"placeholder_user_portrait"
#define defaultDownloadPlaceImageName   @"download_image_default"
#define defaultNoticeNotComplete        @"精彩功能，敬请期待"

#define kUserName                       @"username_HanNiu"
#define kUserData                       @"userdata_HanNiu"
#define kUserZone                       @"userzone_HanNiu"

#define kNotification_Login_StateRefresh @"kNotification_Login_StateRefresh"//登录状态变化

typedef void(^AppDoneBlock)(id object);

@interface AppPublic : NSObject

+ (AppPublic *)getInstance;

//应用名称
@property (strong, nonatomic) NSString *appName;
//应用版本
@property (strong, nonatomic) NSString *appVersion;
//栈顶视图控制器
@property (strong, nonatomic) UIViewController *topViewController;

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
NSString *stringWithTimeInterval(NSTimeInterval interval);

//文本尺寸
+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantWidth:(CGFloat)width;
+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantHeight:(CGFloat)height;
+ (void)adjustLabelWidth:(UILabel *)label;
+ (void)adjustLabelHeight:(UILabel *)label;
+ (UIFont *)appFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldAppFontOfSize:(CGFloat)fontSize;
+ (UIFont *)appFontOfPxSize:(CGFloat)pxSize;

//切圆角
+ (void)roundCornerRadius:(UIView *)view;
+ (void)roundCornerRadius:(UIView *)view cornerRadius:(CGFloat)radius;


- (void)logout;
- (void)loginDoneWithUserData:(NSDictionary *)data username:(NSString *)username password:(NSString *)password;

- (void)goToMainVC;
- (void)goToLoginCompletion:(void (^)(void))completion;

@end
