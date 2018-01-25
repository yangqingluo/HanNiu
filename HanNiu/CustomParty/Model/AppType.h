//
//  AppType.h
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppType : NSObject

@end

@interface AppItemInfo : AppType

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) NSString *Image;

@end

@interface AppUserInfo : AppType

@property (strong, nonatomic) NSString *Coin;
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) NSString *NickName;
@property (strong, nonatomic) NSString *Status;
@property (strong, nonatomic) NSString *Type;
@property (strong, nonatomic) NSString *Image;

@end

@interface AppExtra : AppType

@property (strong, nonatomic) AppUserInfo *userinfo;

@end

@interface AppSecureModel : AppType

@property (strong, nonatomic) NSString *Token;//用户鉴权(单点登录)
@property (strong, nonatomic) NSString *FileToken;//文件鉴权信息
@property (strong, nonatomic) AppExtra *Extra;//扩展信息(超管或普通管理员登录时字典存有key为UserInfo的UserManageInfo对象)

@end

//密码相关参数类
@interface UserParam : AppType

@property (strong, nonatomic) NSString *Name;//用户名, 第三方登录时为三方openId
@property (strong, nonatomic) NSString *LoginType;//验证码的获取途径->{2:手机} 登录账号类型->{0:自动,1:用户名,2:手机}
@property (strong, nonatomic) NSString *CurPwd;//当前密码, 重置密码和注册时可不传, PwdMode=2时不传; 第三方登录channel->{1: QQ, 2:微信}
@property (strong, nonatomic) NSString *NewPwd;//新密码
@property (strong, nonatomic) NSString *PwdMode;//密码加密模式->{0: 不加密, 1: MD5, 2: 短信验证码(自动登录或注册), 3: 三方登录[用户名为三方openId, 当前密码为三方channel]}
@property (strong, nonatomic) NSString *Role;//角色->{128:超级管理员, 64:普通管理员, 1:普通用户}, 默认0(不检查角色或由后台控制); PwdMode=2或3时角色可不传(由后台控制哪些角色允许登录)，如传值角色只能是普通用户
@property (strong, nonatomic) NSString *ClientId;//客户端类型, 1:Android, 2:IOS, 3:Web, 4:Test, 5:Weixin
@property (strong, nonatomic) NSString *VerifyCode;//验证码, GBK(6字节)

@end

@interface AppMusicInfo : AppItemInfo

@property (strong, nonatomic) NSString *Url;//地址(未购买时为null)
@property (assign, nonatomic) int TrackNumber;//***未知, -1***
@property (assign, nonatomic) int TotolTrackCount;//***未知, -1***
@property (assign, nonatomic) int Duration;//
@property (assign, nonatomic) int Collect;//收藏数
@property (assign, nonatomic) BOOL IsInCollect;//自己是否收藏(未登录情况下始终为false)
@property (assign, nonatomic) int Comment;//评论数
@property (assign, nonatomic) int PlayTimes;//播放次数(总购买次数)
@property (assign, nonatomic) int Price;//价格,单位为内购金币

@end


@interface AppQualityInfo : AppItemInfo

@property (strong, nonatomic) NSString *Price;
@property (strong, nonatomic) AppItemInfo *University;
@property (strong, nonatomic) AppItemInfo *Institute;
@property (strong, nonatomic) NSString *Introduce;
@property (strong, nonatomic) NSString *TotalPlayTimes;
@property (strong, nonatomic) NSString *CreateTime;
@property (strong, nonatomic) NSString *UpdateTime;
@property (strong, nonatomic) AppMusicInfo *Music;
@property (strong, nonatomic) NSString *Status;

@end


@interface AppMusicBuyInfo : AppMusicInfo

@property (strong, nonatomic) NSArray *Qualities;
@property (strong, nonatomic) NSArray *Schools;
@property (strong, nonatomic) NSArray *Universitys;
@property (strong, nonatomic) NSArray *Majors;

@end
