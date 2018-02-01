//
//  PublicCollectionFooterLineView.m
//  HanNiu
//
//  Created by 7kers on 2018/2/1.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicCollectionFooterLineView.h"

@implementation PublicCollectionFooterLineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _lineView = NewSeparatorLine(CGRectMake(kEdgeMiddle, self.height - appSeparaterLineSize, self.width - 2 * kEdgeMiddle, appSeparaterLineSize));
        [self addSubview:_lineView];
    }
    return self;
}

@end
