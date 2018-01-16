//
//  AppPublic.m
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AppPublic.h"

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

@end
