//
//  CollegeDetailVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/1.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "CollegeDetailVC.h"
#import "PublicSlideSubVC.h"

#import "CollegeDetailHeaderView.h"

#import "UIImageView+WebCache.h"

@interface CollegeDetailVC ()

@property (strong, nonatomic) CollegeDetailHeaderView *headerView;

@end

@implementation CollegeDetailVC

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViewController:@"学校简介" vc:[PublicSlideSubVC new]];
        [self addViewController:@"招生专业" vc:[PublicSlideSubVC new]];
        [self addViewController:@"精品收听" vc:[PublicSlideSubVC new]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.data.Name;
    
    [self.view addSubview:self.headerView];
    [self.headerView.showImageView sd_setImageWithURL:fileURLWithPID(self.data.Image) placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    self.headerView.titleLabel.text = self.data.Name;
//    self.headerView.subTitleLabel.text = self.data.SubName;
//    self.headerView.tagLabel.text = self.data[@"Tag"];
    
    self.slidePageView.frame = CGRectMake(0, self.headerView.bottom + kEdge, self.view.width, self.view.height - (self.headerView.bottom + kEdge));
}

- (void)initializeNavigationBar {
    [self createNavWithTitle:self.title createMenuItem:^UIView *(int nIndex) {
        if (nIndex == 0) {
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1) {
            UIButton *btn = NewRightButton([UIImage imageNamed:@"icon_back_to_mainview"], nil);
            btn.frame = CGRectMake(screen_width - 44, 0, 44, DEFAULT_BAR_HEIGHT);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            return btn;
        }
        else if (nIndex == 2) {
            UIButton *btn = NewRightButton([UIImage imageNamed:@"icon_share"], nil);
            btn.frame = CGRectMake(screen_width - 2 * 44, 0, 44, DEFAULT_BAR_HEIGHT);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
            return btn;
        }
        return nil;
    }];
}

#pragma mark - getter
- (CollegeDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [CollegeDetailHeaderView new];
        _headerView.top = self.navigationBarView.bottom;
    }
    return _headerView;
}

@end
