//
//  CollegeIntroduceHeaderView.m
//  HanNiu
//
//  Created by 7kers on 2018/2/4.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "CollegeIntroduceHeaderView.h"

#define height_CollegeIntroduceHeaderView  200.0
#define height_SchoolIntroduceHeaderView  200.0

@implementation CollegeIntroduceHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        _introduceLabelTop = 120;
        self.height = height_CollegeIntroduceHeaderView;
        
        CGFloat i_radius = _introduceLabelTop - 2 * kEdgeBig;
        UIView *imageBackView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdgeBig, i_radius, i_radius)];
        [AppPublic roundCornerRadius:imageBackView];
        imageBackView.layer.borderColor = appSeparatorColor.CGColor;
        imageBackView.layer.borderWidth = appSeparaterLineSize;
        [self addSubview:imageBackView];
        self.imageBackgroundView = imageBackView;
        
        self.showImageView.frame = CGRectMake(0, 0, 0.7 * i_radius, 0.7 * i_radius);
        self.showImageView.center = CGPointMake(0.5 * imageBackView.width, 0.5 * imageBackView.height);
        [imageBackView addSubview:self.showImageView];
        
        self.titleLabel.frame = CGRectMake(imageBackView.right + kEdge, imageBackView.top, self.width - kEdgeMiddle - kEdgeHuge, 0.5 * imageBackView.height);
        self.subTitleLabel.frame = CGRectMake(self.titleLabel.left, self.titleLabel.bottom, self.titleLabel.width, 0.5 * imageBackView.height);
        self.foldBtn = NewButton(CGRectZero, nil, nil, nil);
        [self addSubview:self.foldBtn];
        self.tagLabel.left = kEdgeHuge;
        self.tagLabel.top = _introduceLabelTop;
        self.tagLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self adjustTagLabelHeight:3];
    }
    return self;
}

- (void)adjustTagLabelHeight:(NSInteger)numberOfLines {
    self.tagLabel.numberOfLines = numberOfLines;
    CGFloat m_height1 = [AppPublic textSizeWithString:self.tagLabel.text font:self.tagLabel.font constantWidth:self.tagLabel.width].height;
    CGFloat m_height2 = [AppPublic textSizeWithString:@"1.\n2.\n3." font:self.tagLabel.font constantWidth:self.tagLabel.width].height;
    self.foldBtn.hidden = m_height1 < m_height2;
    CGFloat m_height = 0;
    if (numberOfLines == 0) {
        [self.foldBtn setImage:[UIImage imageNamed:@"icon_arrow_up"] forState:UIControlStateNormal];
        m_height = m_height1;
    }
    else {
        [self.foldBtn setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
        m_height = m_height2;
    }
    self.height = _introduceLabelTop + m_height + 30;
    self.tagLabel.height = m_height;
    self.foldBtn.frame = CGRectMake(0, self.height - 30, self.width, 30);
}

@end


@implementation SchoolIntroduceHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.introduceLabelTop = kEdgeMiddle;
        self.height = height_SchoolIntroduceHeaderView;
        self.tagLabel.left = 20;
        self.tagLabel.width = self.width - 30;
        self.tagLabel.top = self.introduceLabelTop;
        
        [self.showImageView removeFromSuperview];
        [self.imageBackgroundView removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.subTitleLabel removeFromSuperview];
    }
    return self;
}


@end
