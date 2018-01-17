//
//  AccountAboutVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/17.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AccountAboutVC.h"

@interface AccountAboutVC ()

@end

@implementation AccountAboutVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我们";
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_trans_back"]];
    logoImageView.centerX = 0.5 * self.view.width;
    logoImageView.top = 160;
    [self.view addSubview:logoImageView];
    
    UILabel *companyLabel = NewLabel(CGRectMake(0, logoImageView.bottom + kEdgeHuge, self.view.width, 44), nil, [AppPublic appFontOfSize:appLabelFontSizeSmall], NSTextAlignmentCenter);
    companyLabel.numberOfLines = 0;
    companyLabel.text = @"成都某某某科技有限公司\nwww.xxxxx.com";
    [self.view addSubview:companyLabel];
    
    UILabel *versionLabel = NewLabel(CGRectMake(0, companyLabel.bottom + kEdgeBig, self.view.width, 20),appTextLightColor, [AppPublic appFontOfSize:appLabelFontSize], NSTextAlignmentCenter);
    versionLabel.text = [AppPublic getInstance].appVersion;
    [self.view addSubview:versionLabel];
    
    UILabel *noteLabel = NewLabel(CGRectMake(0, self.view.height - 44 - kEdgeHuge, self.view.width, 44), [UIColor grayColor], [AppPublic appFontOfSize:appLabelFontSizeLittle], NSTextAlignmentCenter);
    noteLabel.numberOfLines = 0;
    noteLabel.text = @"信息网络传播视听许可证：88888888\n视听节目由成都某某某科技公司管理经营";
    [self.view addSubview:noteLabel];
}

@end
