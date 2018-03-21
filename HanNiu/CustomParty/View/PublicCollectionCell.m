//
//  PublicCollectionCell.m
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicCollectionCell.h"

@implementation PublicCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        CGFloat i_radius = self.contentView.width;
        _showImageView = [[DoubleImageView alloc] initWithFrame:CGRectMake(0, 0, i_radius, i_radius)];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_showImageView];
        [AppPublic roundCornerRadius:_showImageView cornerRadius:appViewCornerRadius];
        _showImageView.layer.borderColor = appSeparatorColor.CGColor;
        _showImageView.layer.borderWidth = 1.0;
        
        _titleLabel = [[PublicLabel alloc] initWithFrame:CGRectMake(0, self.showImageView.bottom + kEdge, self.contentView.width, self.contentView.height - self.showImageView.bottom)];
        _titleLabel.textColor = appTextColor;
        _titleLabel.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.verticalAlignment = VerticalAlignmentTop;
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

@end
