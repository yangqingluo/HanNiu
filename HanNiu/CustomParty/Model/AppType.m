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

@implementation AppTime

@end

@implementation AppItemInfo

- (NSArray *)picsAddressListForPics {
    NSArray *m_array = [self.Pics componentsSeparatedByString:@"|"];
    NSMutableArray *addressList = [NSMutableArray arrayWithCapacity:m_array.count];
    for (NSString *pID in m_array) {
        [addressList addObject:fileURLStringWithPID(pID)];
    }
    return addressList;
}

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


@implementation AppBasicMusicInfo

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

@implementation AppCompanyInfo

@end

@implementation AppJobInfo

- (NSString *)showStringForAddr {
    NSString *m_string = @"";
    if (self.Area.length == 6) {
        NSString *key_province = [self.Area stringByReplacingCharactersInRange:NSMakeRange(2, 4) withString:@"0000"];
        NSString *province = [UserPublic getInstance].provinceMapDic[key_province];
        if (province.length) {
            m_string = province;
        }
        
        NSString *key_city = [self.Area stringByReplacingCharactersInRange:NSMakeRange(4, 2) withString:@""];
        NSString *city = [UserPublic getInstance].cityMapDic[key_city];
        if (city.length) {
            m_string = [NSString stringWithFormat:@"%@%@", m_string, city];
        }
    }
    return m_string;
}

@end


@implementation AppCollegeInfo

- (NSString *)showStringForTags {
    NSArray *m_array = [self.Tags componentsSeparatedByString:@"|"];
    return [m_array componentsJoinedByString:@"\t"];
}

- (NSString *)showStringForAddr {
    NSString *m_string = @"";
    if (self.Addr.length == 6) {
        NSString *key_province = [self.Addr stringByReplacingCharactersInRange:NSMakeRange(2, 4) withString:@"0000"];
        NSString *province = [UserPublic getInstance].provinceMapDic[key_province];
        if (province.length) {
            m_string = province;
        }
        
        NSString *key_city = [self.Addr stringByReplacingCharactersInRange:NSMakeRange(4, 2) withString:@""];
        NSString *city = [UserPublic getInstance].cityMapDic[key_city];
        if (city.length) {
            m_string = [NSString stringWithFormat:@"%@%@", m_string, city];
        }
    }
    return m_string;
}

@end


@implementation AppMajorInfo

@end

@implementation AppMajorDetailInfo

@end

