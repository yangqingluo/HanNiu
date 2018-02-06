//
//  CompanyIntroduceSubVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/6.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "CompanyIntroduceSubVC.h"
#import "CompanyDetailVC.h"

#import "AdScrollView.h"

@interface CompanyIntroduceSubVC ()

@property (strong, nonatomic) AdScrollView *adView;
@property (strong, nonatomic) UITextView *textView;

@end

@implementation CompanyIntroduceSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.adView];
    [self.view addSubview:self.textView];
    
    CompanyDetailVC *p_VC = (CompanyDetailVC *)self.parentVC;
    [self.adView updateImages:p_VC.data.picsAddressListForPics];
    self.textView.text = p_VC.data.Introduce;
}

#pragma mark - getter
- (AdScrollView *)adView{
    if (!_adView) {
        CGSize m_size = [AdScrollView adSize];
        _adView = [[AdScrollView alloc] initWithFrame:CGRectMake(0, 0, m_size.width, m_size.height)];
    }
    return _adView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.adView.bottom + kEdge, self.view.width, self.view.height - TAB_BAR_HEIGHT - (self.adView.bottom + kEdge))];
        _textView.editable = NO;
        _textView.textColor = appTextColor;
        _textView.font = [AppPublic appFontOfSize: appLabelFontSizeSmall];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.textContainerInset = UIEdgeInsetsMake(kEdge, kEdge, kEdge, 0);
        _textView.scrollIndicatorInsets = UIEdgeInsetsMake(kEdge, 0, kEdge, 0);
    }
    return _textView;
}

@end
