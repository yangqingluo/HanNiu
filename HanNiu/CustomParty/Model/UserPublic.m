//
//  UserPublic.m
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "UserPublic.h"

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

- (NSMutableDictionary *)dataMapDic {
    if (!_dataMapDic) {
        _dataMapDic = [NSMutableDictionary new];
        NSArray *m_array = @[@"province"];
        for (NSString *key in m_array) {
            NSString *path = [[NSBundle mainBundle] pathForResource:key ofType:@"txt"];
            if (path) {
                NSArray *keyValuesArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:nil];
//                NSArray *objectArray = [AppDataDictionary mj_objectArrayWithKeyValuesArray:keyValuesArray];
                if (keyValuesArray) {
                    [_dataMapDic setObject:keyValuesArray forKey:key];
                }
            }
        }
    }
    return _dataMapDic;
}

@end
