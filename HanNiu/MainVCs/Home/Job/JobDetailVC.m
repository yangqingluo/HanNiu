//
//  JobDetailVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/5.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "JobDetailVC.h"
#import "CompanyDetailVC.h"

#import "PublicImageAndSubTitleView.h"

#import "NSAttributedString+JTATEmoji.h"
#import "UIImageView+WebCache.h"

@implementation JobHeaderView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, screen_width, 100)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = NewLabel(CGRectMake(kEdgeBig, kEdge, self.width - kEdgeMiddle - kEdgeHuge, 0.3 * self.height), appTextColor, [AppPublic appFontOfSize:appLabelFontSize], NSTextAlignmentLeft);
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        
        _subTitleLabel = NewLabel(CGRectMake(self.titleLabel.left, self.titleLabel.bottom, self.titleLabel.width, 0.2 * self.height), appMainColor, [AppPublic appFontOfSize:appLabelFontSizeLittle], NSTextAlignmentLeft);
        _subTitleLabel.numberOfLines = 0;
        [self addSubview:_subTitleLabel];
        
        _tagLabel = NewLabel(CGRectMake(self.titleLabel.left, self.subTitleLabel.bottom, self.titleLabel.width, 0.3 * self.height), [UIColor grayColor], [AppPublic appFontOfSize:appLabelFontSizeLittle], NSTextAlignmentLeft);
        _tagLabel.top = _subTitleLabel.bottom;
        [self addSubview:_tagLabel];
    }
    return self;
}

@end

@implementation JobFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _headerView = [[PublicCollectionHeaderTitleView alloc] initWithFrame:CGRectMake(0, 0, self.width, kCellHeight)];
        _headerView.rightImageView.hidden = YES;
        _headerView.titleLabel.text = @"职位描述";
        [self addSubview:_headerView];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.width, self.height- self.headerView.bottom)];
        _textView.editable = NO;
        _textView.textColor = appTextColor;
        _textView.font = [AppPublic appFontOfSize: appLabelFontSizeSmall];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.textContainerInset = UIEdgeInsetsMake(kEdge, kEdge, kEdge, 0);
        _textView.scrollIndicatorInsets = UIEdgeInsetsMake(kEdge, 0, kEdge, 0);
        [self addSubview:_textView];
    }
    return self;
}

@end


@interface JobDetailVC ()

@property (strong, nonatomic) JobHeaderView *headerView;
@property (strong, nonatomic) PublicBorderImageAndSubTitleView *companyView;
@property (strong, nonatomic) JobFooterView *footerView;
@property (strong, nonatomic) AppCompanyInfo *companyData;

@end

@implementation JobDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    
    [self.view addSubview:self.headerView];
    self.headerView.titleLabel.text = self.data.Name;
    self.headerView.subTitleLabel.text = self.data.Salary;
    self.headerView.tagLabel.attributedText = [NSAttributedString emojiAttributedString:[NSString stringWithFormat:@"[place] %@　[place] %@　[place] %@及以上", self.data.Area, self.data.Exp, self.data.Edu] withFont:self.headerView.tagLabel.font];
    
    if (self.showCompany) {
        [self.view addSubview:self.companyView];
    }
    
    CGFloat m_top = self.showCompany ? self.companyView.bottom : self.headerView.bottom;
    self.footerView = [[JobFooterView alloc] initWithFrame:CGRectMake(0,m_top + kEdge, screen_width, self.view.height - TAB_BAR_HEIGHT - m_top)];
    [self.view addSubview:self.footerView];
    
    [self updateSubViews];
    [self pullBaseListData:YES];
}

- (void)pullBaseListData:(BOOL)isReset {
    [self doGetJobDetailFunction];
    [self doGetCompanyDetailFunction];
}

- (void)doGetJobDetailFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"id" : self.data.Id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Job/Job/Detail" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            weakself.data = [AppJobInfo mj_objectWithKeyValues:responseBody[@"Data"]];
            [weakself updateFooterView];
        }
    }];
}

- (void)doGetCompanyDetailFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"id" : self.data.Company.Id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Job/Company/Detail" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            weakself.companyData = [AppCompanyInfo mj_objectWithKeyValues:responseBody[@"Data"]];
            [weakself updateCompanyView];
        }
    }];
}

- (void)updateSubViews {
    [self updateCompanyView];
    [self updateFooterView];
}

- (void)updateCompanyView {
    [self.companyView.showImageView sd_setImageWithURL:fileURLWithPID(self.companyData.Image) placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    self.companyView.titleLabel.text = self.companyData.Name;
    self.companyView.subTitleLabel.text = self.companyData.Tags;
}

- (void)updateFooterView {
    self.footerView.textView.text = self.data.Introduce;
}

- (void)companyViewTapAction {
    CompanyDetailVC *vc = [CompanyDetailVC new];
    vc.data = self.companyData;
    [self doPushViewController:vc animated:YES];
}

#pragma mark - getter
- (AppCompanyInfo *)companyData {
    if (!_companyData) {
        _companyData = [self.data.Company copy];
    }
    return _companyData;
}

- (JobHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [JobHeaderView new];
        _headerView.top = self.navigationBarView.bottom + kEdge;
    }
    return _headerView;
}

- (PublicBorderImageAndSubTitleView *)companyView {
    if (!_companyView) {
        _companyView = [PublicBorderImageAndSubTitleView new];
        _companyView.top = self.headerView.bottom + kEdge;
        
        UIImageView *m_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right_arrow"]];
        m_imageView.centerY = 0.5 * _companyView.height;
        m_imageView.right = _companyView.width - kEdgeMiddle;
        [_companyView addSubview:m_imageView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(companyViewTapAction)];
        [_companyView addGestureRecognizer:gesture];
    }
    return _companyView;
}

@end
