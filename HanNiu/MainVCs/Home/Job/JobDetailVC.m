//
//  JobDetailVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/5.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "JobDetailVC.h"

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
        
    }
    return self;
}

@end


@interface JobDetailVC ()

@property (strong, nonatomic) JobHeaderView *headerView;
@property (strong, nonatomic) PublicBorderImageAndSubTitleView *companyView;

@end

@implementation JobDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    
    [self.view addSubview:self.headerView];
    self.headerView.titleLabel.text = self.data.Name;
    self.headerView.subTitleLabel.text = self.data.Salary;
    self.headerView.tagLabel.attributedText = [NSAttributedString emojiAttributedString:[NSString stringWithFormat:@"[place] %@　[place] %@　[place] %@", self.data.Area, self.data.Exp, self.data.Edu] withFont:self.headerView.tagLabel.font];
    
    [self.view addSubview:self.companyView];
    [self updateCompanyView];
    [self pullBaseListData:YES];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"id" : self.data.Company.Id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Job/Company/Detail" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            weakself.data.Company = [AppCompanyInfo mj_objectWithKeyValues:responseBody[@"Data"]];
            [weakself updateCompanyView];
        }
    }];
}

- (void)updateCompanyView {
    [self.companyView.showImageView sd_setImageWithURL:fileURLWithPID(self.data.Company.Image) placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    self.companyView.titleLabel.text = self.data.Company.Name;
    self.companyView.subTitleLabel.text = self.data.Company.Tags;
}

#pragma mark - getter
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
    }
    return _companyView;
}

@end
