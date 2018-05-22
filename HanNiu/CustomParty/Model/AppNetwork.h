//
//  AppNetwork.h
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define appUrlAddress       @"http://39.105.12.231:9528/api/"
//#define appUrlAddress       @"http://101.201.51.208:9528/api/"//开发服务器
#define appHttpMessage      @"message"

#define HTTP_SUCCESS_NOT_SUPPORT        0x10000//成功, 但该功能在当前版本中不受支持, 将不保证返回结果的正确性
#define HTTP_SUCCESS_DUP                3//成功, 但之前已受理过此请求因此未执行或单位时间内执行次数超出限额(重复提交)
#define HTTP_SUCCESS_PARTLY             1//执行成功, 但只返回部分结果(分页)
#define HTTP_SUCCESS                    0//成功
#define HTTP_DATA_CONFLICT             -6//数据冲突（购买音频时即为余额不足）
#define HTTP_REMOTE_LOGIN              -15//账号异地登录
#define HTTP_ERR_NEED_VFY              -24//需要提供验证码(或验证码失效)

typedef void(^AppNetworkBlock)(id responseBody, NSError *error);
typedef void(^Progress)(float progress);

@interface AppNetwork : NSObject

+ (AppNetwork *)getInstance;

//http码字典数据
@property (strong, nonatomic) NSDictionary *httpRespCodeDic;

NSString *urlStringWithService(NSString *service);
NSString *fileURLStringWithPID(NSString *pID);
NSURL *fileURLWithPID(NSString *pID);
NSString *httpRespString(NSError *error, NSObject *object);

//Get
- (void)Get:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlFooter completion:(AppNetworkBlock)completion;

//Post
- (void)Post:(id)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlFooter completion:(AppNetworkBlock)completion;
- (void)Post:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlFooter constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block completion:(AppNetworkBlock)completion;

//Put
- (void)Put:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlFooter completion:(AppNetworkBlock)completion;

//Delete
- (void)Delete:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlFooter completion:(AppNetworkBlock)completion;

//pushImages
- (void)PushImages:(NSArray *)imageDataArray completion:(AppNetworkBlock)completion withUpLoadProgress:(Progress)progress;

//login
- (void)loginWithID:(NSString *)username Password:(NSString *)password completion:(AppNetworkBlock)completion;
- (void)visitorLoginCompletion:(AppNetworkBlock)completion;

@end
