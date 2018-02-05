//
//  PublicImageAndSubTitleView.m
//  HanNiu
//
//  Created by 7kers on 2018/2/5.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicImageAndSubTitleView.h"

@implementation PublicImageAndSubTitleView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, screen_width, 100)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat i_radius = self.height - 2 * kEdgeMiddle;
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdgeMiddle, i_radius, i_radius)];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        [AppPublic roundCornerRadius:self.showImageView];
        [self addSubview:_showImageView];
        
        _titleLabel = NewLabel(CGRectMake(self.showImageView.right + kEdgeMiddle, self.showImageView.top, screen_width - (self.showImageView.right + kEdgeMiddle), 0.5 * self.showImageView.height), nil, nil, NSTextAlignmentLeft);
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];

        self.subTitleLabel = NewLabel(CGRectMake(self.titleLabel.left, self.titleLabel.bottom, self.titleLabel.width, 20), [UIColor grayColor], [AppPublic appFontOfSize:appLabelFontSizeLittle], NSTextAlignmentLeft);
        self.subTitleLabel.numberOfLines = 0;
        self.subTitleLabel.top = self.titleLabel.bottom;
        [self addSubview:self.subTitleLabel];
    }
    return self;
}

@end


@implementation PublicBorderImageAndSubTitleView

- (instancetype)init {
    self = [super init];
    if (self) {
        CGFloat i_radius = self.showImageView.width;
        UIView *imageBackView = [[UIView alloc] initWithFrame:self.showImageView.frame];
        [AppPublic roundCornerRadius:imageBackView];
        imageBackView.layer.borderColor = appSeparatorColor.CGColor;
        imageBackView.layer.borderWidth = appSeparaterLineSize;
        [self addSubview:imageBackView];
        self.showImageView.layer.cornerRadius = 0;
        self.showImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.showImageView.frame = CGRectMake(0, 0, 0.7 * i_radius, 0.7 * i_radius);
        self.showImageView.center = CGPointMake(0.5 * imageBackView.width, 0.5 * imageBackView.height);
        [imageBackView addSubview:self.showImageView];
    }
    return self;
}
@end
