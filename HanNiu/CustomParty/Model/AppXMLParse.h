//
//  AppXMLParse.h
//  HanNiu
//
//  Created by 7kers on 2018/2/1.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLElement : NSObject


@property (nonatomic,strong) NSString *type;// 标签类型
@property (nonatomic,strong) NSString *content;// 内容
@property (nonatomic,strong) NSDictionary *attributes;// 标签的属性
@property (nonatomic,strong) NSMutableArray *subElements;// 子标签集合
@property (nonatomic,strong) XMLElement *parent;// 上一级标签

@end

@interface AppXMLParse : NSObject

+ (AppXMLParse *)getInstance;

@property (nonatomic) NSMutableDictionary *parseDic;
@property (nonatomic) NSMutableArray *parseArray;
//@property (nonatomic) NSDictionary *courseDic;
//@property (nonatomic) NSArray *provinceArray;

- (BOOL)parseWithString:(NSString *)string;

@end
