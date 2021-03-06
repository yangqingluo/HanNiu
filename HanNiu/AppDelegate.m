//
//  AppDelegate.m
//  HanNiu
//
//  Created by 7kers on 2018/1/15.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <notify.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 后台播放音频设置
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 设置接受远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
//    if (@available(iOS 11.0, *)) {
//        UITableView.appearance.estimatedRowHeight = 0;
//        UITableView.appearance.estimatedSectionHeaderHeight = 0;
//        UITableView.appearance.estimatedSectionFooterHeight = 0;
//        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
    
    //注册微信
    [WXApi registerApp:@"wx4bcd3ee13599fc9d"];
    
    [AppPublic getInstance];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"WillResignActive.");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"Background.");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"Foreground.");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"Active.");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application {
    [AppPublic getInstance].screenLock = NO;
}

- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application {
    [AppPublic getInstance].screenLock = YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[AppPublic getInstance] doReceiveAlipayResult:resultDic];
        }];
    }
    else if ([[NSString stringWithFormat:@"%@",url] hasPrefix:@"wx"]) {
        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    NSLog(@"***%@", url.host);
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[AppPublic getInstance] doReceiveAlipayResult:resultDic];
        }];
    }
    else if ([[NSString stringWithFormat:@"%@",url] hasPrefix:@"wx"]) {
        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}

@end
