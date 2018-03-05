//
//  AppPurchases.m
//  HanNiu
//
//  Created by 7kers on 2018/3/5.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AppPurchases.h"
#import <StoreKit/StoreKit.h>
#import "NSData+HTTPRequest.h"

@interface AppPurchases ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic,copy) NSString *currentProId;

@end

@implementation AppPurchases

__strong static AppPurchases  *_singleManger = nil;
+ (AppPurchases *)getInstance{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _singleManger = [[AppPurchases alloc] init];
    });
    return _singleManger;
}

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (instancetype)init{
    if (_singleManger) {
        return _singleManger;
    }
    
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    
    return self;
}

//去苹果服务器请求商品
- (void)requestProductData:(NSString *)type{
    if (!type) {
        return;
    }
    
    NSLog(@"-------------请求对应的产品信息----------------");
    _currentProId = [type copy];
//    [SVProgressHUD showWithStatus:nil];
    
    NSArray *product = [[NSArray alloc] initWithObjects:type,nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSArray *product = response.products;
    if([product count] == 0){
//        [SVProgressHUD dismiss];
//        [[AppPublic getInstance].mainTabNav showHint:@"购买信息无效"];
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
        if([pro.productIdentifier isEqualToString:_currentProId]){
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
//    [SVProgressHUD showErrorWithStatus:@"支付失败"];
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
}
//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
/**
 *  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
 *
 */
-(void)verifyPurchaseWithPaymentTransaction {
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //创建请求到苹果官方进行购买验证
    NSURL *url=[NSURL URLWithString:SANDBOX];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
    //创建连接并发送同步请求
    NSError *error=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",dic);
    if([dic[@"status"] intValue]==0){
        NSLog(@"购买成功！");
        NSDictionary *dicReceipt= dic[@"receipt"];
        NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
        NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
        //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        if ([productIdentifier isEqualToString:@"123"]) {
            int purchasedCount = [defaults integerForKey:productIdentifier];//已购买数量
            [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount + 1) forKey:productIdentifier];
        }else{
            [defaults setBool:YES forKey:productIdentifier];
        }
        //在此处对购买记录进行存储，可以存储到开发商的服务器端
    }else{
        NSLog(@"购买失败，未通过验证！");
    }
}

//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                NSLog(@"交易完成");
//                [SVProgressHUD dismiss];
                [self completeTransaction:tran];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
            }
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"用户正在购买");
                
                break;
            case SKPaymentTransactionStateRestored:{
                NSLog(@"已经购买过商品");
//                [SVProgressHUD dismiss];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
//                [SVProgressHUD showErrorWithStatus:@"重复购买"];
            }
                break;
            case SKPaymentTransactionStateFailed:{
                NSLog(@"交易失败");
//                [SVProgressHUD dismiss];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
//                [SVProgressHUD showErrorWithStatus:@"购买失败"];
            }
                break;
                
            case SKPaymentTransactionStateDeferred:{
                NSLog(@"最终状态未确定");
            }
                break;
            default:
                break;
        }
    }
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    
//    [SVProgressHUD dismiss];
    
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    
    if ([receiptString length] > 0) {
        // 向自己的服务器验证购买凭证
//        [SVProgressHUD showWithStatus:@"验证订单..."];
        
        NSDictionary *m_dic = @{@"Data" : receiptString,
                                @"Channel" : @"3",
                                @"IsSuccess" : stringWithBoolValue(YES)
                                };
        [[AppNetwork getInstance] Put:m_dic HeadParm:nil URLFooter:@"Pay/CheckIos" completion:^(id responseBody, NSError *error){
//            [SVProgressHUD dismiss];
            if (!error) {
                
            }
            else{
                [[AppPublic getInstance].topViewController showHint:@"网络出错"];
            }
        }];
    }
}

#pragma public
- (BOOL)canMakePayments{
    return [SKPaymentQueue canMakePayments];
}


@end
