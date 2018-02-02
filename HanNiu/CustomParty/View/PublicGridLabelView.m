//
//  PublicGridLabelView.m
//  HanNiu
//
//  Created by 7kers on 2018/2/2.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicGridLabelView.h"

@implementation PublicGridLabelView

- (void)resetGridWithStringArray:(NSArray *)array {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat x = 0.0;
    for (NSString *m_string in array) {
        UILabel *label = NewLabel(CGRectMake(0, 0, self.width, self.height), [UIColor grayColor], [AppPublic appFontOfSize:appLabelFontSizeTiny], NSTextAlignmentCenter);
        label.text = m_string;
        label.width = [AppPublic textSizeWithString:m_string font:label.font constantHeight:label.height].width + 2 * kEdgeSmall;
        [AppPublic roundCornerRadius:label cornerRadius:appViewCornerRadius];
        label.layer.borderColor = label.textColor.CGColor;
        label.layer.borderWidth = appSeparaterLineSize;
        label.left = x;
        x += (label.width + kEdge);
        [self addSubview:label];
    }
}

@end
