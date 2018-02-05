//
//  PublicCollectionHeaderTitleView.m
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicCollectionHeaderTitleView.h"

#import "UIResponder+Router.h"

@implementation PublicCollectionHeaderTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kEdgeMiddle, 0, 2, 14)];
        leftImageView.centerY = 0.5 * self.height;
        leftImageView.image = [UIImage imageNamed:@"icon_text_header"];
        [self addSubview:leftImageView];
        
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - kEdgeMiddle - 9, 0, 9, 18)];
        _rightImageView.centerY = 0.5 * self.height;
        _rightImageView.image = [UIImage imageNamed:@"icon_right_arrow"];
        [self addSubview:_rightImageView];
        
        _titleLabel = NewLabel(CGRectMake(leftImageView.right + kEdgeMiddle, 0,  _rightImageView.left - leftImageView.right - 2 * kEdgeMiddle, self.height), nil, nil, NSTextAlignmentLeft);
        [self addSubview:_titleLabel];
        
        _subTitleLabel = NewLabel(CGRectMake(_rightImageView.left - 80 - kEdge, _titleLabel.top,  80, _titleLabel.height), [UIColor grayColor], [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentRight);
        [self addSubview:_subTitleLabel];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)tapGestureAction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"tag" : @(self.tag)}];
    [self routerEventWithName:Event_PublicCollectionHeaderTitleViewTapped userInfo:[NSDictionary dictionaryWithDictionary:m_dic]];
}

@end
