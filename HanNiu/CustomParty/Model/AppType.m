//
//  AppType.m
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AppType.h"

@implementation AppType

- (instancetype)copyWithZone:(NSZone *)zone {
    //to fix 此种方式copy后，NSDate类型如果为nil，copy后会new为当前时间
    return [[self class] mj_objectWithKeyValues:[self mj_keyValues]];
}

@end

@implementation AppItemInfo

@end

@implementation AppUserInfo


@end

@implementation AppExtra


@end

@implementation AppSecureModel


@end


@implementation UserParam


@end


@implementation AppMusicInfo

@end


@implementation AppQualityInfo

@end


@implementation AppMusicBuyInfo

- (instancetype)init{
    self = [super init];
    if (self) {
        [[self class] mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"Qualities" : [AppItemInfo class],
                     @"Schools" : [AppItemInfo class],
                     @"Universitys" : [AppItemInfo class],
                     @"Majors" : [AppItemInfo class],
                     };
        }];
    }
    
    
    return self;
}

@end
