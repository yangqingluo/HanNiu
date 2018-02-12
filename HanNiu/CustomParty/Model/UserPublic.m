//
//  UserPublic.m
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "UserPublic.h"
#import "AppXMLParse.h"

@implementation UserPublic
__strong static UserPublic *_singleManger = nil;
+ (UserPublic *)getInstance {
    _singleManger = [[UserPublic alloc] init];
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
//保存用户数据
- (void)saveUserData:(AppSecureModel *)data{
    if (data) {
        _userData = data;
    }
    if (_userData) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:[_userData mj_keyValues] forKey:kUserData];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_Login_StateRefresh object:nil];
}
//清除用户数据
- (void)clearUserData {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kUserData];
    
    _singleManger = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_Login_StateRefresh object:nil];
}

//保存用户播放列表
- (void)savePlayList:(NSArray *)array {
    [self.userPlayList removeAllObjects];
    [self.userPlayList addObjectsFromArray:array];
}
//保存用户当前播放数据
- (void)savePlayingData:(AppQualityInfo *)data {
    self.playingData = data;
}

#pragma mark - getter
- (AppSecureModel *)userData{
    if (!_userData) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSDictionary *data = [ud objectForKey:kUserData];
        if (data) {
            _userData = [AppSecureModel mj_objectWithKeyValues:data];
        }
    }
    return _userData;
}

- (NSMutableArray *)userPlayList {
    if (!_userPlayList) {
        _userPlayList = [NSMutableArray new];
    }
    return _userPlayList;
}

- (AppQualityInfo *)playingData {
    if (!_playingData) {
        
    }
    return _playingData;
}


- (NSMutableDictionary *)dataMapDic {
    if (!_dataMapDic) {
        _dataMapDic = [NSMutableDictionary new];
        NSArray *m_array = @[@"province", @"college_title", @"college_level", @"college_major"];
        for (NSString *key in m_array) {
            NSString *path = [[NSBundle mainBundle] pathForResource:key ofType:@"txt"];
            if (path) {
                NSArray *keyValuesArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:nil];
                NSArray *objectArray = [AppItemInfo mj_objectArrayWithKeyValuesArray:keyValuesArray];
                if (keyValuesArray) {
                    [_dataMapDic setObject:objectArray forKey:key];
                }
            }
        }
    }
    return _dataMapDic;
}

- (NSMutableDictionary *)provinceMapDic {
    if (!_provinceMapDic) {
        _provinceMapDic = [NSMutableDictionary new];
        NSArray *provinceArray = self.dataMapDic[@"province"];
        for (AppItemInfo *item in provinceArray) {
            [_provinceMapDic setObject:item.Name forKey:item.Id];
        }
    }
    return _provinceMapDic;
}

- (NSMutableDictionary *)cityMapDic {
    if (!_cityMapDic) {
        _cityMapDic = [NSMutableDictionary new];
        NSString *city_id_path = [[NSBundle mainBundle] pathForResource:@"city_id" ofType:@"txt"];
        NSArray *cityIDArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:city_id_path] options:kNilOptions error:nil];
        
        NSString *city_name_path = [[NSBundle mainBundle] pathForResource:@"city_name" ofType:@"xml"];
        NSString *courseString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:city_name_path] encoding:NSUTF8StringEncoding];
        if ([[AppXMLParse getInstance] parseWithString:courseString]) {
            NSArray *cityNameArray = [AppXMLParse getInstance].parseDic[@"city_name"];
            if (cityIDArray.count == cityNameArray.count) {
                for (NSUInteger i = 0; i < cityIDArray.count; i++) {
                    [_cityMapDic setObject:cityNameArray[i] forKey:[NSString stringWithFormat:@"%@", cityIDArray[i]]];
                }
            }
        }
    }
    return _cityMapDic;
}

- (NSMutableDictionary *)msgFromMusicMapDic {
    if (!_msgFromMusicMapDic) {
        _msgFromMusicMapDic = [NSMutableDictionary new];
    }
    return _msgFromMusicMapDic;
}

@end
