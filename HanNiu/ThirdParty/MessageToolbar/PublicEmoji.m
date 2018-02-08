//
//  QKEmoji.m
//  SmartTeaching
//
//  Created by yangqingluo on 15/10/22.
//  Copyright © 2015年 yangqingluo. All rights reserved.
//

#import "PublicEmoji.h"

@implementation PublicEmoji

+ (NSArray *)allEmoji {
    NSDictionary *emojiPlistDic = [[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Emoji" ofType:@"plist"]];
    NSArray *keyArray = [emojiPlistDic allKeys];
    
    NSArray *sortedKeyArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
        NSString *value1 = [emojiPlistDic objectForKey:key1];
        
         NSString *value2 = [emojiPlistDic objectForKey:key2];
        
        return ee_int(value1) > ee_int(value2);
    }];
    
    NSMutableArray *arrayOnlyEE = [NSMutableArray new];
    for (NSString *key in sortedKeyArray) {
        NSString *value = [emojiPlistDic objectForKey:key];
        if ([value hasPrefix:@"ee_"]) {
            [arrayOnlyEE addObject:key];
        }
    }

    return arrayOnlyEE;
}

int ee_int(NSString *string){
    if ([string hasPrefix:@"ee_"]) {
        string = [string substringFromIndex:3];
        return [string intValue];
    }
    
    return 0;
}

@end
