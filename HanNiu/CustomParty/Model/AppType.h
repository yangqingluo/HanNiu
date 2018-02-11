//
//  AppType.h
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppType : NSObject

NSString *stringWithBoolValue(BOOL yn);

@end

@interface AppTime : NSObject

@property (assign, nonatomic) CGFloat totalTime;//总时长
@property (assign, nonatomic) CGFloat currentTime;//当前时间

@end

@interface AppItemInfo : AppType

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) NSString *Image;

@property (strong, nonatomic) NSString *Pics;
- (NSArray *)picsAddressListForPics;

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


@interface AppBasicMusicInfo : AppItemInfo

@property (strong, nonatomic) NSString *Introduce;
@property (strong, nonatomic) NSString *CreateTime;
@property (strong, nonatomic) NSString *UpdateTime;
@property (strong, nonatomic) AppMusicInfo *Music;
@property (strong, nonatomic) NSString *Status;
@property (assign, nonatomic) int TotalPlayTimes;
@property (strong, nonatomic) NSString *TotalComment;
@property (strong, nonatomic) NSString *TotalDuration;

@end

@interface AppQualityInfo : AppBasicMusicInfo

@property (strong, nonatomic) NSString *Price;
@property (strong, nonatomic) AppItemInfo *University;
@property (strong, nonatomic) AppItemInfo *Institute;
@property (strong, nonatomic) AppItemInfo *College;

- (NSString *)showMediaItemPropertyAlbumTitle;
- (NSString *)showMediaItemPropertyArtist;
- (NSString *)showMediaDetailTitle;


@end


@interface AppMusicDetailInfo : AppMusicInfo

@property (strong, nonatomic) NSArray *Qualities;
@property (strong, nonatomic) NSArray *Schools;
@property (strong, nonatomic) NSArray *Universitys;
@property (strong, nonatomic) NSArray *Majors;

@end

@interface AppCompanyInfo : AppItemInfo

@property (strong, nonatomic) NSString *Area;
@property (strong, nonatomic) NSString *Edu;
@property (strong, nonatomic) NSString *Exp;
@property (strong, nonatomic) NSString *Introduce;
@property (strong, nonatomic) NSString *Salary;
@property (strong, nonatomic) NSString *Status;
@property (strong, nonatomic) NSString *Tags;

@end

@interface AppJobInfo : AppItemInfo

@property (strong, nonatomic) NSString *Area;
@property (strong, nonatomic) AppCompanyInfo *Company;
@property (strong, nonatomic) NSString *Edu;
@property (strong, nonatomic) NSString *Exp;
@property (strong, nonatomic) NSString *Introduce;
@property (strong, nonatomic) NSString *Salary;
@property (strong, nonatomic) NSString *Status;

- (NSString *)showStringForAddr;

@end


@interface AppCollegeInfo : AppBasicMusicInfo

@property (strong, nonatomic) NSString *Addr;//阿里地址库ID
@property (strong, nonatomic) NSString *Tags;
@property (strong, nonatomic) NSString *Web;//不可出现非外链图片, 同DetailHtml?
@property (strong, nonatomic) NSString *DetailHtml;//
@property (strong, nonatomic) NSString *DetailFiles;//

- (NSString *)showStringForTags;
- (NSString *)showStringForAddr;

@end

@interface AppMajorInfo : AppItemInfo

@property (strong, nonatomic) NSString *Type;//第几级
@property (strong, nonatomic) NSString *Grade;//第0级类型->专科:0, 本科:1, 硕士:2
@property (strong, nonatomic) NSString *FirstTag;//第1级类型

@end

@interface AppMajorDetailInfo : AppMajorInfo

@property (strong, nonatomic) NSArray *subMajors;
@property (strong, nonatomic) NSString *SecondTag;//第2级类型名称
@property (strong, nonatomic) NSString *ThirdTag;//第3级类型名称
@property (strong, nonatomic) NSString *ThirdTagImage;

@end

@interface AppMajorMusicInfo : AppQualityInfo

@property (strong, nonatomic) AppMajorDetailInfo *CommonMajor;
@property (strong, nonatomic) NSString *Grade;

@end


@interface AppCommentInfo : AppItemInfo

@property (strong, nonatomic) NSString *UserId;//评论人ID(上传)
@property (strong, nonatomic) NSString *ToUserId;//被评论人ID
@property (strong, nonatomic) AppItemInfo *User;//评论人信息
@property (strong, nonatomic) AppItemInfo *ToUser;//被评论人信息
@property (strong, nonatomic) NSString *MusicId;//所属Music的ID
@property (strong, nonatomic) NSString *Content;//正文
@property (strong, nonatomic) NSString *CreateTime;
@property (strong, nonatomic) NSString *UpdateTime;
@property (assign, nonatomic) int LikeCount;//点赞数
@property (assign, nonatomic) BOOL HasMakeGood;//自己是否点赞(未登录情况下始终为false)
@property (strong, nonatomic) AppCommentInfo *ToComment;//不含子层级, 不含ToUser,LikeCount,HasMakeGood

- (NSString *)showStringForContent;
- (NSString *)showStringPrefixForRemind;

@end

