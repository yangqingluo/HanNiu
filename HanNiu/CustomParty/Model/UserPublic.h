//
//  UserPublic.h
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPublic : NSObject

+ (UserPublic *)getInstance;

//用户登陆数据
@property (strong, nonatomic) AppSecureModel *userData;
//用户播放列表
@property (strong, nonatomic) NSMutableArray *userPlayList;
//用户当前播放数据
@property (strong, nonatomic) AppBasicMusicDetailInfo *playingData;


//数据字典数据
@property (strong, nonatomic) NSMutableDictionary *dataMapDic;
//省份字典数据
@property (strong, nonatomic) NSMutableDictionary *provinceMapDic;
//城市字典数据
@property (strong, nonatomic) NSMutableDictionary *cityMapDic;
//消息-发出的-音乐数据
@property (strong, nonatomic) NSMutableDictionary *msgFromMusicMapDic;

//保存用户数据
- (void)saveUserData:(AppSecureModel *)data;
//清除用户数据
- (void)clearUserData;


//保存用户播放列表
- (void)savePlayList:(NSArray *)array;
//保存用户当前播放数据
- (void)savePlayingData:(AppBasicMusicDetailInfo *)data;


@end
