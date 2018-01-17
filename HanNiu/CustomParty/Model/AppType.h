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

@interface AppUserInfo : AppType

@property (strong, nonatomic) NSString *Coin;
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) NSString *NickName;
@property (strong, nonatomic) NSString *Status;
@property (strong, nonatomic) NSString *Type;

@end

@interface AppExtra : AppType

@property (strong, nonatomic) AppUserInfo *userinfo;

@end

@interface AppSecureModel : AppType

@property (strong, nonatomic) NSString *Token;//用户鉴权(单点登录)
@property (strong, nonatomic) NSString *FileToken;//文件鉴权信息
@property (strong, nonatomic) AppExtra *Extra;//扩展信息(超管或普通管理员登录时字典存有key为UserInfo的UserManageInfo对象)

@end


