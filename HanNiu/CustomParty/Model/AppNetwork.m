//
//  AppNetwork.m
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AppNetwork.h"
#import "NSData+HTTPRequest.h"

@interface AppNetwork ()

@property (strong, nonatomic) UIAlertView *loginErrorAlert;

@end

@implementation AppNetwork
+ (AppNetwork *)getInstance {
    static AppNetwork *sharedNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkSingleton = [[self alloc] init];
    });
    return sharedNetworkSingleton;
}

- (AFHTTPSessionManager *)baseHttpRequestWithParm:(NSDictionary *)parm andSuffix:(NSString *)suffix{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    for (NSString *key in parm.allKeys) {
        if (parm[key]) {
            [manager.requestSerializer setValue:parm[key] forHTTPHeaderField:key];
        }
    }
    [manager.requestSerializer setValue:[NSString stringWithFormat:@" HAuth %@", notNilString([UserPublic getInstance].userData.Token, @"null")] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    return manager;
}

NSString *urlStringWithService(NSString *service) {
    return [NSString stringWithFormat:@"%@%@", appUrlAddress, service];
}

NSString *fileURLStringWithPID(NSString *pID) {
    return urlStringWithService([NSString stringWithFormat:@"File/?pid=%@", pID]);
}

NSURL *fileURLWithPID(NSString *pID) {
    return [NSURL URLWithString:fileURLStringWithPID(pID)];
}

NSString *httpRespString(NSError *error, NSObject *object){
    NSString *noticeString = @"出错";
    if (error) {
        noticeString = @"网络出错";
    }
    else {
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)object;
            if (dic[@"msg"]) {
                noticeString = dic[@"msg"];
            }
            else if (dic[@"State"]) {
                NSString *State = [NSString stringWithFormat:@"%@", dic[@"State"]];
                NSDictionary *m_dic = [AppNetwork getInstance].httpRespCodeDic;
                NSString *m_string = m_dic[State];
                noticeString = m_string.length ? m_string : [NSString stringWithFormat:@"错误码：%@", dic[@"State"]];
            }
        }
    }
    return noticeString;
}

NSString *generateUuidString(){
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    // release the UUID
    CFRelease(uuid);
    return uuidString;
}

#pragma mark - getter
- (NSDictionary *)httpRespCodeDic {
    if (!_httpRespCodeDic) {
        _httpRespCodeDic = @{[NSString stringWithFormat:@"%d", 0x10000] : @"成功(目前版本中不保证该结果的正确性)",
        @"3" : @"成功(重复提交:之前已受理过此请求,因此未执行,或单位时间内执行次数超出限额)",
        @"1" : @"执行成功(分页：只返回部分结果)",
        @"0" : @"成功",
        @"-1" : @"数据库错误",
        @"-2" : @"未登录",
        @"-3" : @"找不到此用户",
        @"-4" : @"用户名或密码错误",
        @"-5" : @"非法参数",
        @"-6" : @"数据冲突",
        @"-7" : @"没有权限",
        @"-8" : @"验证码错误",
        @"-9" : @"从远程服务器读取数据出错",
        @"-10" : @"远程服务器连接失败",
        @"-11" : @"远程服务器未找到",
        @"-12" : @"未找到指定对象",
//        @"-13" : @"保留",
        @"-14" : @"IO错误",
        @"-15" : @"账号异地登录",
        @"-16" : @"数据过期",
        @"-17" : @"用户名已存在",
        @"-18" : @"发送验证码失败",
        @"-19" : @"找不到家庭",
        @"-20" : @"在黑名单中",
        @"-21" : @"不再受支持",
        @"-22" : @"未实现",
        @"-23" : @"触发业务流控限制",
        @"-24" : @"需要提供验证码(或验证码失效)",
        @"-25" : @"被禁用",
        @"-26" : @"二维码过期",
        [NSString stringWithFormat:@"%d", 0xff] : @"未知错误",
                             };
    }
    return _httpRespCodeDic;
}

#pragma mark - public
//Get
- (void)Get:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlFooter completion:(AppNetworkBlock)completion {
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:parm andSuffix:urlFooter];
    NSString *urlStr = [urlStringWithService(urlFooter) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    QKWEAKSELF;
    [manager GET:urlStr parameters:userInfo progress:^(NSProgress * _Nonnull progress){
        
    } success:^(NSURLSessionDataTask *task, id responseObject){
        [weakself doResponseCompletion:responseObject block:completion];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        [weakself doResponseCompletion:nil block:completion];
    }];
}

//Post
- (void)Post:(id)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlFooter completion:(AppNetworkBlock)completion {
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:parm andSuffix:urlFooter];
    NSString *urlStr = [urlStringWithService(urlFooter) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    QKWEAKSELF;
    [manager POST:urlStr parameters:userInfo progress:^(NSProgress * _Nonnull progress){
        
    } success:^(NSURLSessionDataTask *task, id responseObject){
        [weakself doResponseCompletion:responseObject block:completion];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        [weakself doResponseCompletion:nil block:completion];
    }];
}

- (void)Post:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlFooter constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block completion:(AppNetworkBlock)completion {
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:parm andSuffix:urlFooter];
    NSString *urlStr = [urlStringWithService(urlFooter) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    QKWEAKSELF;
    [manager POST:urlStr parameters:userInfo constructingBodyWithBlock:block progress:^(NSProgress * _Nonnull Progress){
        
    } success:^(NSURLSessionDataTask *task, id responseObject){
        [weakself doResponseCompletion:responseObject block:completion];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        [weakself doResponseCompletion:nil block:completion];
    }];
}

//Put
- (void)Put:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlFooter completion:(AppNetworkBlock)completion {
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:parm andSuffix:urlFooter];
    NSString *urlStr = [urlStringWithService(urlFooter) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    QKWEAKSELF;
    [manager PUT:urlStr parameters:userInfo success:^(NSURLSessionDataTask *task, id responseObject){
        [weakself doResponseCompletion:responseObject block:completion];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        [weakself doResponseCompletion:nil block:completion];
    }];
}

//Delete
- (void)Delete:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlFooter completion:(AppNetworkBlock)completion {
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:parm andSuffix:urlFooter];
    NSString *urlStr = [urlStringWithService(urlFooter) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    QKWEAKSELF;
    [manager DELETE:urlStr parameters:userInfo success:^(NSURLSessionDataTask *task, id responseObject){
        [weakself doResponseCompletion:responseObject block:completion];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        [weakself doResponseCompletion:nil block:completion];
    }];
}

//pushImages
- (void)PushImages:(NSArray *)imageDataArray completion:(AppNetworkBlock)completion withUpLoadProgress:(Progress)progress {
    NSString *urlFooter = @"File";
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:nil andSuffix:urlFooter];
    NSString *urlStr = [urlStringWithService(urlFooter) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    QKWEAKSELF;
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSData *imageData in imageDataArray) {
            NSString *imageExtension = [imageData getImageType];
            NSString *fileName = [NSString stringWithFormat:@"%@.%@",generateUuidString(),imageExtension];
            /*
             此方法参数
             1. 要上传的[二进制数据]
             2. 对应网站上[upload.php中]处理文件的[字段"file"]
             3. 要保存在服务器上的[文件名]
             4. 上传文件的[mimeType]
             */
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:[NSString stringWithFormat:@"image/%@",imageExtension]];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress){
        progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask *task, id responseObject){
        [weakself doResponseCompletion:responseObject block:completion];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        [weakself doResponseCompletion:nil block:completion];
    }];
}

//Login
- (void)loginWithID:(NSString *)username Password:(NSString *)password completion:(AppNetworkBlock)completion {
    NSMutableDictionary *m_dic = [[NSMutableDictionary alloc]initWithDictionary:@{@"ClientId":@"2", @"PwdMode":@"0", @"Name":username}];
    if (password) {
        [m_dic setObject:password forKey:@"CurPwd"];
    }
    [self Post:m_dic HeadParm:nil URLFooter:@"Token?v=2&misc=userinfo&misc=Exp" completion:^(id responseBody, NSError *error){
        if (!error) {
            [[AppPublic getInstance] loginDoneWithUserData:responseBody[@"Data"] username:username password:password];
        }
        completion(responseBody, error);
    }];
}

#pragma mark - private
- (BOOL)occuredRemoteLogin:(id)object {
    if ([object isKindOfClass:[NSDictionary class]]) {
        switch ([object[@"State"] integerValue]) {
            case HTTP_REMOTE_LOGIN:{
                [[AFHTTPSessionManager manager] invalidateSessionCancelingTasks:NO];
                if (!_loginErrorAlert) {
                    [[AppPublic getInstance] logout];
                    _loginErrorAlert = [[BlockAlertView alloc] initWithTitle:nil message:@"登录信息无效，请重新登录" cancelButtonTitle:@"确定" callBlock:^(UIAlertView *view, NSInteger buttonIndex) {
                        _loginErrorAlert = nil;
                    } otherButtonTitles:nil];
                    [_loginErrorAlert show];
                }
                return YES;
            }
                break;
                
            default:
                break;
        }
    }
    
    return NO;
}

- (void)doResponseCompletion:(id)responseBody block:(AppNetworkBlock)completion {
    NSString *message = @"出错";
    NSInteger code = 0;
    id completionObject = nil;
    if (!responseBody) {
        message = @"网络出错";
    }
    else if ([responseBody isKindOfClass:[NSData class]]) {
        message = @"数据出错";
        id responseObject = nil;
        NSError *serializationError = nil;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseBody options:NSJSONReadingAllowFragments error:&serializationError];
        if (!serializationError && [responseObject isKindOfClass:[NSDictionary class]]) {
            if (responseObject[@"State"]) {
                code = [responseObject[@"State"] integerValue];
                if (code >= HTTP_SUCCESS) {
                    completionObject = responseObject;
                }
                else {
                    message = httpRespString(nil, responseObject);
                    if ([self occuredRemoteLogin:responseObject]) {
                        return;
                    }
                }
            }
        }
    }
    
    if (completionObject) {
        completion(completionObject, nil);
    }
    else {
        completion(nil, [NSError errorWithDomain:@"www.hanniu.com" code:code userInfo:@{appHttpMessage : message}]);
    }
}

@end
