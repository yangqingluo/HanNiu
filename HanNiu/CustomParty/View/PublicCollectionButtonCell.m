//
//  PublicCollectionButtonCell.m
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicCollectionButtonCell.h"

@implementation PublicCollectionButtonCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentView.backgroundColor = [UIColor whiteColor];
        //某些情况下，一行cell的宽度和并不完全等于collectionView.width，所以cell之间有空隙，会显示出底部其他视图的背景颜色，所以这样处理
        UIView *baseView = [[UIView alloc] initWithFrame:self.bounds];
        baseView.width = ceil(baseView.width);
        baseView.backgroundColor = [UIColor whiteColor];
        [self insertSubview:baseView belowSubview:self.contentView];
        
        _button = NewButton(CGRectMake(kEdgeSmall, kEdgeSmall, self.contentView.width - 2 * kEdgeSmall, self.contentView.height - 2 * kEdgeSmall), @"", appTextColor, [AppPublic appFontOfSize:appButtonTitleFontSizeLittle]);
        [_button setBackgroundImage:[UIImage imageNamed:@"icon_classify_sub_recycler_item_back_normal"] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageNamed:@"icon_classify_sub_recycler_item_back_selected"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_button];
        [AppPublic roundCornerRadius:_button cornerRadius:appButtonCornerRadius];
        _button.layer.borderColor = appSeparatorColor.CGColor;
        _button.layer.borderWidth = 1.0;
    }
    return self;
}

@end
