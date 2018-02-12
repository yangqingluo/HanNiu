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

NSString *stringWithBoolValue(BOOL yn) {
    return yn ? @"true" : @"false";
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

- (NSString *)showItemKey {
    if (self.Qualities.count) {
        return musicKeyQualities;
    }
    if (self.Universitys.count) {
        return musicKeyUniversitys;
    }
    if (self.Schools.count) {
        return musicKeySchools;
    }
    if (self.Majors.count) {
        return musicKeyMajors;
    }
    return nil;
}

- (AppItemInfo *)showItem {
    NSString *key = self.showItemKey;
    if (key) {
        return [self valueForKey:key][0];
    }
    return self;
}


@end


@implementation AppBasicMusicInfo

@end

@implementation AppQualityInfo

- (NSString *)showMediaItemPropertyAlbumTitle {
    NSString *m_string = @"";
    if (self.University) {
        m_string = self.University.Name;
    }
    else if (self.College) {
        m_string = self.College.Name;
    }
    return m_string;
}

- (NSString *)showMediaItemPropertyArtist {
    NSString *m_string = @"";
    if (self.Institute) {
        m_string = self.Institute.Name;
    }
    else if (self.Name) {
        m_string = self.Name;
    }
    return m_string;
}

- (NSString *)showMediaItemPropertyAuthor {
    NSMutableString *m_string = [NSMutableString new];
    if (self.showMediaItemPropertyAlbumTitle.length) {
        if (m_string.length) {
            [m_string appendString:@"-"];
        }
        [m_string appendString:self.showMediaItemPropertyAlbumTitle];
    }
    if (self.showMediaItemPropertyArtist.length) {
        if (m_string.length) {
            [m_string appendString:@"-"];
        }
        [m_string appendString:self.showMediaItemPropertyArtist];
    }
    return m_string;
}

- (NSString *)showMediaDetailTitle {
    NSMutableString *m_string = [[NSMutableString alloc] initWithString:self.showMediaItemPropertyAuthor];
    if (self.Music) {
        if (m_string.length) {
            [m_string appendString:@"-"];
        }
        [m_string appendString:self.Music.Name];
    }
    return m_string;
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

@implementation AppMajorMusicInfo

@end

@implementation AppCommentInfo

- (NSString *)showStringForContent {
    NSString *m_string = @"";
    if (self.ToUser) {
        m_string = [NSString stringWithFormat:@"@%@：", self.ToUser.Name];
    }
    if (self.Content) {
        m_string = [NSString stringWithFormat:@"%@%@", m_string, self.Content];
    }
    
    return m_string;
}

- (NSString *)showStringPrefixForRemind {
    return [NSString stringWithFormat:@"@%@：", self.User.Name];
}

@end

