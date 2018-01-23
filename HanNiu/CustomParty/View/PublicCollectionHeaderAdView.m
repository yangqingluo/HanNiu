//
//  PublicCollectionHeaderAdView.m
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicCollectionHeaderAdView.h"

@implementation PublicCollectionHeaderAdView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.adView];
    }
    return self;
}

#pragma mark - getter
- (AdScrollView *)adView{
    if (!_adView) {
        _adView = [[AdScrollView alloc] initWithFrame:self.bounds];
        _adView.PageControlShowStyle = UIPageControlShowStyleCenter;
        _adView.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _adView.pageControl.currentPageIndicatorTintColor = appMainColor;
    }
    return _adView;
}

@end
