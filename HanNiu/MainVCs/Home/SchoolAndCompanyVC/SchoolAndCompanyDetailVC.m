//
//  SchoolAndCompanyDetailVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/31.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "SchoolAndCompanyDetailVC.h"

#import "PublicDetailImageAndSubTitleHeaderView.h"

#import "UIImageView+WebCache.h"

@interface SchoolAndCompanyDetailVC ()

@property (strong, nonatomic) PublicDetailImageAndSubTitleHeaderView *headerView;
@property (strong, nonatomic) UITextView *textView;

@end

@implementation SchoolAndCompanyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.data[@"Name"];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.textView];
    [self.headerView.showImageView sd_setImageWithURL:fileURLWithPID(self.data[@"Image"]) placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    self.headerView.titleLabel.text = self.data[@"Name"];
    self.headerView.subTitleLabel.text = self.data[@"SubName"];
    self.headerView.tagLabel.text = self.data[@"Tag"];
    self.textView.text = self.data[@"Introduce"];
}

#pragma mark - getter
- (PublicDetailImageAndSubTitleHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [PublicDetailImageAndSubTitleHeaderView new];
        _headerView.top = self.navigationBarView.bottom;
    }
    return _headerView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom + kEdge, self.view.width, self.view.height - TAB_BAR_HEIGHT - (self.headerView.bottom + kEdge))];
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
