//
//  AppPurchases.h
//  HanNiu
//
//  Created by 7kers on 2018/3/5.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppPurchases : NSObject

+ (AppPurchases *)getInstance;

- (BOOL)canMakePayments;
- (void)requestProductData:(NSString *)type;

@end
