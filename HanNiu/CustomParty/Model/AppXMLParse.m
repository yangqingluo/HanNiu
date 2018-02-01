//
//  AppXMLParse.m
//  HanNiu
//
//  Created by 7kers on 2018/2/1.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AppXMLParse.h"

@implementation XMLElement

#pragma getter
- (NSMutableArray *)subElements {
    if(!_subElements){
        _subElements = [NSMutableArray new];
    }
    return _subElements;
}

@end

@interface AppXMLParse ()<NSXMLParserDelegate>

@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic,strong) XMLElement *rootElement;
@property (nonatomic,strong) XMLElement *currentElementPointer;

@end

@implementation AppXMLParse

__strong static AppXMLParse  *_singleManger = nil;
+ (AppXMLParse *)getInstance {
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _singleManger = [[AppXMLParse alloc] init];
    });
    return _singleManger;
}

- (BOOL)parseWithString:(NSString *)string{
    [self.parseDic removeAllObjects];
    
    self.xmlParser = [[NSXMLParser alloc]initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    [self.xmlParser setDelegate:self];
    [self.xmlParser setShouldResolveExternalEntities: YES];
    
    if([self.xmlParser parse]){
        NSLog(@"The XML is Parsed");
        for (XMLElement *element in self.rootElement.subElements) {
            NSMutableArray *courseArray = [NSMutableArray arrayWithCapacity:element.subElements.count];
            for (XMLElement *subElement in element.subElements) {
                [courseArray addObject:(subElement.content ? subElement.content : @"")];
            }
            [self.parseDic setObject:courseArray forKey:element.attributes[@"name"]];
        }
        return YES;
    }
    return NO;
}

#pragma mark - getter
- (NSMutableDictionary *)parseDic{
    if (!_parseDic) {
        _parseDic = [NSMutableDictionary new];
    }
    return _parseDic;
}

- (NSMutableArray *)parseArray{
    if (!_parseArray) {
        _parseArray = [NSMutableArray new];
    }
    return _parseArray;
}

#pragma mark - NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName attributes: (NSDictionary *)attributeDict {
    if(!self.rootElement){
        self.rootElement = [XMLElement new];
        self.currentElementPointer = self.rootElement;
    }
    else{
        XMLElement *newElement = [[XMLElement alloc]init];
        newElement.parent = self.currentElementPointer;
        [self.currentElementPointer.subElements addObject:newElement];
        self.currentElementPointer = newElement;
    }
    
    self.currentElementPointer.type = elementName;
    self.currentElementPointer.attributes = attributeDict;
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if([self.currentElementPointer.content length] > 0){
        self.currentElementPointer.content = [self.currentElementPointer.content stringByAppendingString:string];
    }
    else{
        self.currentElementPointer.content = [NSMutableString stringWithString:string];
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    self.currentElementPointer = self.currentElementPointer.parent;
}
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"-------------------start--------------");
    self.rootElement = nil;
    self.currentElementPointer = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"-------------------end--------------");
    self.currentElementPointer = nil;
}
//报告不可恢复的解析错误
- (void)paser:parserErrorOccured {
    NSLog(@"-------------------error--------------");
}

@end
