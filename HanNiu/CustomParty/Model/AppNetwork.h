//
//  AppNetwork.h
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define appUrlAddress       @"http://101.201.51.208:9528/api/"
#define APP_HTTP_SUCCESS                     1    //成功

#define HTTP_SUCCESS_NOT_SUPPORT        0x10000//成功, 但该功能在当前版本中不受支持, 将不保证返回结果的正确性
#define HTTP_SUCCESS_DUP                3//成功, 但之前已受理过此请求因此未执行或单位时间内执行次数超出限额(重复提交)
#define HTTP_SUCCESS_PARTLY             1//执行成功, 但只返回部分结果(分页)
#define HTTP_SUCCESS                    0//成功
#define HTTP_DB_ERR                    -1//数据库错误
#define HTTP_NOT_LOGIN                 -2//未登录
#define HTTP_NO_USER                   -3//找不到此用户(出现此情况时http状态码可能为401 Unauthorized, 从错误流中读取正文)
#define HTTP_PASS_ERR                  -4//用户名或密码错误
#define HTTP_INV_ARGS                  -5//非法参数
#define HTTP_DATA_CONFLICT             -6//数据冲突, 当请求不满足预先设定的某些约束时出现(请求超限)
#define HTTP_PERM_DENY                 -7//没有权限, 企图获取或设置不属于当前用户的对象信息时会提示此错误
#define HTTP_VFY_ERR                   -8//验证码错误
#define HTTP_ERR_REMOTE_SERV_ERR       -9//从远程服务器读取数据出错
#define HTTP_ERR_REMOTE_SERV_CONN_FAIL -10//远程服务器连接失败
#define HTTP_ERR_REMOTE_SERV_NOT_FOUND -11//远程服务器未找到
#define HTTP_ERR_NOT_FOUND             -12//未找到指定对象(视使用环境而定)
//--    --    -13    保留
#define HTTP_IO_ERR                    -14//IO错误
#define HTTP_REMOTE_LOGIN              -15//账号异地登录
#define HTTP_DATA_OVERDUE        -16    //数据过期
#define HTTP_HAS_USER        -17    //用户名已存在
#define HTTP_SEND_VFR_ERRO        -18    //发送验证码失败
#define HTTP_NO_Group        -19    //(自0.4.0, Android 1.0.7.74暂未使用)找不到群组
#define HTTP_ERR_IN_BLACK        -20    //在黑名单中
#define HTTP_ERR_NOT_SUPPORT        -21    //不再受支持
#define HTTP_ERR_NOT_IMPLEMENT        -22    //未实现
#define HTTP_UNKNOWN_ERR        -0xff    //未知错误
//#define HTTP_HTTP_ERR        -0x10000|Errcode    HTTP错误

typedef void(^AppNetworkBlock)(id responseBody, NSError *error);
typedef void(^Progress)(float progress);

@interface AppNetwork : NSObject

+ (AppNetwork *)getInstance;


//Post
- (void)Post:(id)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlFooter completion:(AppNetworkBlock)completion;

//login
- (void)loginWithID:(NSString *)username Password:(NSString *)password completion:(AppNetworkBlock)completion;

@end
