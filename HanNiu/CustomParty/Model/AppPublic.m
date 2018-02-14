//
//  AppPublic.m
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AppPublic.h"
#import <CommonCrypto/CommonDigest.h>
#import "PublicPlayerManager.h"

#import "LoginViewController.h"
#import "MusicDetailVC.h"

@interface AppPublic()

@end

@implementation AppPublic

__strong static AppPublic  *_singleManger = nil;
+ (AppPublic *)getInstance {
    static dispatch_once_t pred = 0;
    
    dispatch_once(&pred, ^{
        _singleManger = [[AppPublic alloc] init];
    });
    return _singleManger;
}

- (instancetype)init {
    if (_singleManger) {
        return _singleManger;
    }
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - public
//检查该版本是否第一次使用
BOOL isFirstUsing() {
    //#if DEBUG
    //    NSString *key = @"CFBundleVersion";
    //#else
    NSString *key = @"CFBundleShortVersionString";
    //#endif
    
    // 1.当前版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    
    // 2.从沙盒中取出上次存储的版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    // 3.写入本次版本号
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return ![version isEqualToString:saveVersion];
}

BOOL isMobilePhone(NSString *string) {
    if (!string || string.length == 0) {
        return NO;
    }
    
    NSMutableAttributedString *parsedOutput = [[NSMutableAttributedString alloc]initWithString:string attributes:nil];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^1\\d{10}$" options:0 error:nil];
    NSArray* matches = [regex matchesInString:[parsedOutput string]
                                      options:NSMatchingWithoutAnchoringBounds
                                        range:NSMakeRange(0, parsedOutput.length)];
    
    return matches.count > 0;
}

BOOL isEmailAdress(NSString *string) {
    if (!string || string.length == 0) {
        return NO;
    }
    
    //匹配Email地址
    NSMutableAttributedString *parsedOutput = [[NSMutableAttributedString alloc]initWithString:string attributes:nil];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*.\\w+([-.]\\w+)*" options:0 error:nil];
    NSArray* matches = [regex matchesInString:[parsedOutput string]
                                      options:NSMatchingWithoutAnchoringBounds
                                        range:NSMakeRange(0, parsedOutput.length)];
    
    return matches.count > 0;
}

NSString *sha1(NSString *string) {
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *outputStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [outputStr appendFormat:@"%02x", digest[i]];
    }
    
    return outputStr;
}

/*!
 @brief 替换空字符串
 */
NSString *notNilString(NSString *string, NSString *placeString) {
    return string.length ? string : (placeString ? placeString : @"");
}

// 字典转中文字符串 log NSSet with UTF8
// if not ,log will be \Uxxx
+ (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 = [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                                      withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if (!str) {
        str = tempStr3;
    }
    return str;
}

//判断是否是全数字
BOOL stringIsNumberString(NSString *string, BOOL withPoint) {
    NSCharacterSet *notNumber=[[NSCharacterSet characterSetWithCharactersInString:withPoint ? appNumberWithPoint : appNumberWithoutPoint] invertedSet];
    NSString *string1 = [[string componentsSeparatedByCharactersInSet:notNumber] componentsJoinedByString:@""];
    return [string isEqualToString:string1];
}

//图像压缩
NSData *dataOfImageCompression(UIImage *image, BOOL isHead) {
    //头像图片
    if (isHead) {
        //调整分辨率
        if (image.size.width > kHeadImageSizeMax || image.size.height > kHeadImageSizeMax) {
            //压缩图片
            CGSize newSize = CGSizeMake(image.size.width, image.size.height);
            
            CGFloat tempHeight = newSize.height / kHeadImageSizeMax;
            CGFloat tempWidth = newSize.width / kHeadImageSizeMax;
            
            if (tempWidth > 1.0 && tempWidth > tempHeight) {
                newSize = CGSizeMake(image.size.width / tempWidth, image.size.height / tempWidth);
            }
            else if (tempHeight > 1.0 && tempWidth < tempHeight){
                newSize = CGSizeMake(image.size.width / tempHeight, image.size.height / tempHeight);
            }
            
            UIGraphicsBeginImageContext(newSize);
            [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    
    //调整大小
    CGFloat scale = 1.0;
    NSData *imageData;
    
    do {
        if (imageData) {
            scale *= (kImageDataMax / imageData.length);
        }
        imageData = UIImageJPEGRepresentation(image, scale);
    } while (imageData.length > kImageDataMax);
    
    return imageData;
}

//生成视图
UIButton *NewBackButton(UIColor *color) {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *i = [UIImage imageNamed:@"icon_go_back"];
    if (color) {
        i = [i imageWithColor:color];
    }
    [btn setImage:i forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 64, 44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    return btn;
}

UIButton *NewRightButton(UIImage *image, UIColor *color) {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(screen_width - 64, 0, 64, DEFAULT_BAR_HEIGHT)];
    if (color) {
        image = [image imageWithColor:color];
    }
    [btn setImage:image forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    return btn;
}

UIButton *NewTextButton(NSString *title, UIColor *textColor) {
    return NewButton(CGRectMake(screen_width - 64, 0, 64, DEFAULT_BAR_HEIGHT), title, textColor, nil);
}

UIButton *NewButton(CGRect frame, NSString *title, UIColor *textColor, UIFont *font) {
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:textColor ? textColor : appTextColor forState:UIControlStateNormal];
    btn.titleLabel.font = font ? font : [AppPublic appFontOfSize:appButtonTitleFontSize];
    return btn;
}

UILabel *NewLabel(CGRect frame, UIColor *textColor, UIFont *font, NSTextAlignment alignment) {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = textColor ? textColor : appTextColor;
    label.font = font ? font : [AppPublic appFontOfSize:appLabelFontSize];
    label.textAlignment = alignment;
    return label;
}

UIView *NewSeparatorLine(CGRect frame) {
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = appSeparatorColor;
    return lineView;
}

//日期-文本转换
NSDate *dateFromString(NSString *dateString, NSString *format) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    return destDate;
}

NSString *stringFromDate(NSDate *date, NSString *format) {
    if (!format) {
        format = defaultDateFormat;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

NSString *dateStringWithTimeString(NSString *string){
    NSDate *date = dateFromString(string, @"yyyy-MM-dd HH:mm:ss");
    if (date) {
        return stringFromDate(date, @"yyyy-MM-dd");
    }
    
    return string.length ? string : @"--";
}

NSDate *dateWithPriousorLaterDate(NSDate *date, int month) {
    //正数是以后n个月，负数是前n个月；
    NSDateComponents *comps = [NSDateComponents new];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

NSString *stringWithTimeInterval(NSTimeInterval interval) {
    NSInteger minutes = interval / 60;
    NSInteger seconds = (NSInteger)interval % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
}

//文本尺寸
+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantWidth:(CGFloat)width {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = 0;
    
    NSStringDrawingOptions drawOptions = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attibutes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    
    return [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:drawOptions attributes:attibutes context:nil].size;
}

+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantHeight:(CGFloat)height {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = 0;
    
    NSStringDrawingOptions drawOptions = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attibutes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:drawOptions attributes:attibutes context:nil].size;
}

+ (void)adjustLabelWidth:(UILabel *)label {
    label.width = ceil([AppPublic textSizeWithString:label.text font:label.font constantHeight:label.height].width);//根据苹果官方文档介绍，计算出来的值比实际需要的值略小，故需要对其向上取整，这样子获取的高度才是我们所需要的。
}

+ (void)adjustLabelHeight:(UILabel *)label {
    label.height = ceil([AppPublic textSizeWithString:label.text font:label.font constantWidth:label.width].height);
}

+ (CGFloat )systemFontOfPXSize:(CGFloat)pxSize {
    CGFloat pt = (pxSize / 96) * 72;
    return pt;
}

+ (UIFont *)appFontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)boldAppFontOfSize:(CGFloat)fontSize {
    return [UIFont boldSystemFontOfSize:fontSize];
}

+ (UIFont *)appFontOfPxSize:(CGFloat)pxSize {
    return [UIFont systemFontOfSize:[AppPublic systemFontOfPXSize:pxSize]];
}

//切圆角
+ (void)roundCornerRadius:(UIView *)view {
    [AppPublic roundCornerRadius:view cornerRadius:0.5 * MIN(view.width, view.height)];
}

+ (void)roundCornerRadius:(UIView *)view cornerRadius:(CGFloat)radius {
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}



- (void)logout {
    [[UserPublic getInstance] clearUserData];
}

- (void)loginDoneWithUserData:(NSDictionary *)data username:(NSString *)username password:(NSString *)password {
    if (!data || !username) {
        return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:username forKey:kUserName];
    
    [[UserPublic getInstance] saveUserData:[AppSecureModel mj_objectWithKeyValues:data]];
//    [self goToMainVC];
}

- (void)goToMainVC {
    
}

- (void)goToLoginCompletion:(void (^)(void))completion {
    LoginViewController *vc = [LoginViewController new];
    [self.topViewController.navigationController pushViewController:vc animated:YES];
    if (completion) {
        completion();
    }
}

- (void)goToMusicVC:(AppBasicMusicDetailInfo *)data list:(NSArray *)list type:(PublicMusicDetailType)type {
    if ([UserPublic getInstance].userData) {
        if (type != PublicMusicDetailFromBar) {
            [[PublicPlayerManager getInstance] savePlayList:list];
            [[PublicPlayerManager getInstance] saveCurrentData:data];
        }
        
        if ([PublicPlayerManager getInstance].currentPlay) {
            MusicDetailVC *vc = [MusicDetailVC new];
            [self.topViewController.navigationController pushViewController:vc animated:YES];
        }
    }
    else {
        [self goToLoginCompletion:nil];
    }
}

#pragma mark - getter
- (NSString *)appName {
    if (!_appName) {
        _appName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
    }
    return _appName;
}

- (NSString *)appVersion {
    if (!_appVersion) {
        _appVersion = [NSBundle mainBundle].infoDictionary [@"CFBundleShortVersionString"];
    }
    return _appVersion;
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
