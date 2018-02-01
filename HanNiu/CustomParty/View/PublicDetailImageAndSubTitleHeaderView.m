//
//  SchoolAndCompanyHeaderView.m
//  HanNiu
//
//  Created by 7kers on 2018/1/31.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicDetailImageAndSubTitleHeaderView.h"

@implementation PublicDetailImageAndSubTitleHeaderView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, screen_width, 140)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat i_radius = self.height - 2 * kEdgeMiddle;
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdgeMiddle, i_radius, i_radius)];
        [AppPublic roundCornerRadius:_showImageView cornerRadius:appViewCornerRadius];
        [self addSubview:_showImageView];
        
        _titleLabel = NewLabel(CGRectMake(_showImageView.right + kEdgeHuge, _showImageView.top, self.width - kEdgeMiddle - kEdgeHuge, 0.2 * _showImageView.height),appTextColor, [AppPublic appFontOfSize:appLabelFontSize], NSTextAlignmentLeft);
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        
        _subTitleLabel = NewLabel(CGRectMake(_titleLabel.left, _showImageView.top + 0.4 * _showImageView.height, _titleLabel.width, 0.3 * _showImageView.height), [UIColor grayColor], [AppPublic appFontOfSize:appLabelFontSizeLittle], _titleLabel.textAlignment);
        _subTitleLabel.numberOfLines = 0;
        [self addSubview:_subTitleLabel];
        
        _tagLabel = NewLabel(_subTitleLabel.frame, _subTitleLabel.textColor, _subTitleLabel.font, _subTitleLabel.textAlignment);
        _tagLabel.top = _subTitleLabel.bottom;
        [self addSubview:_tagLabel];
    }
    return self;
}

@end
