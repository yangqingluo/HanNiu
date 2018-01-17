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
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    for (NSString *key in parm.allKeys) {
        if (parm[key]) {
            [manager.requestSerializer setValue:parm[key] forHTTPHeaderField:key];
        }
    }
    if ([UserPublic getInstance].userData.Token) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@" CAuth %@",[UserPublic getInstance].userData.Token] forHTTPHeaderField:@"Authorization"];
    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    return manager;
}

NSString *urlStringWithService(NSString *service){
    return [NSString stringWithFormat:@"%@%@", appUrlAddress, service];
}

#pragma mark - public
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

- (void)loginWithID:(NSString *)username Password:(NSString *)password completion:(AppNetworkBlock)completion {
    NSMutableDictionary *m_dic = [[NSMutableDictionary alloc]initWithDictionary:@{@"ClientId":@"2", @"PwdMode":@"0", @"Name":username}];
    if (password) {
        [m_dic setObject:password forKey:@"CurPwd"];
    }
    [self Post:m_dic HeadParm:nil URLFooter:@"Token?v=2&misc=userinfo&misc=GroupInfoList&misc=GroupMember" completion:^(id responseBody, NSError *error){
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
            case -20100002:{
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
            completionObject = responseObject;
            if ([self occuredRemoteLogin:responseObject]) {
                return;
            }
        }
    }
    
    if (completionObject) {
        completion(completionObject, nil);
    }
    else {
        completion(nil, [NSError errorWithDomain:@"www.hanniu.com" code:code userInfo:@{@"message" : message}]);
    }
}
@end
