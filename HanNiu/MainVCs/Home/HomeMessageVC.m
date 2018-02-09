//
//  HomeMessageVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/9.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "HomeMessageVC.h"
#import "HomeMessageSubTableVC.h"


@interface HomeMessageVC ()

@property (strong, nonatomic) UISegmentedControl *titleSegment;
@property (strong, nonatomic) NSMutableArray *viewArray;

@end

@implementation HomeMessageVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        [[UserPublic getInstance].msgFromMusicMapDic removeAllObjects];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.viewArray addObject:[[HomeMessageSubTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self andIndexTag:0]];
    [self.viewArray addObject:[[HomeMessageSubTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self andIndexTag:1]];
    [self buildUI];
    [self updateSegmentedControllViews];
}

- (void)initializeNavigationBar {
    [self createNavWithTitle:self.title createMenuItem:^UIView *(int nIndex) {
        if (nIndex == 0) {
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1) {
            self.titleSegment.width = self.titleLabel.width;
            self.titleSegment.center = self.titleLabel.center;
            self.titleSegment.selectedSegmentIndex = 0;
            return self.titleSegment;
        }
        return nil;
    }];
}

- (void)buildUI {
    for (NSInteger i = 0; i < self.viewArray.count; i++) {
        PublicViewController *vc = self.viewArray[i];
        vc.view.frame = CGRectMake(0, self.navigationBarView.bottom, screen_width, screen_height - self.navigationBarView.bottom);
        [self.view addSubview:vc.view];
    }
    
    [self.view setNeedsLayout];
}

- (void)titleSegmentAction {
    [self updateSegmentedControllViews];
}

- (void)updateSegmentedControllViews {
    for (NSInteger i = 0; i < self.viewArray.count; i++) {
        PublicViewController *vc = self.viewArray[i];
        if (i == self.titleSegment.selectedSegmentIndex) {
            vc.view.hidden = NO;
            [vc becomeListed];
        }
        else {
            vc.view.hidden = YES;
        }
    }
}

#pragma mark - getter
- (UISegmentedControl *)titleSegment{
    if (!_titleSegment) {
        _titleSegment = [[UISegmentedControl alloc] initWithItems:@[@"收到的", @"发出的"]];
        _titleSegment.tintColor = [UIColor whiteColor];
        [_titleSegment addTarget:self action:@selector(titleSegmentAction) forControlEvents:UIControlEventValueChanged];
    }
    return _titleSegment;
}

- (NSMutableArray *)viewArray {
    if (!_viewArray) {
        _viewArray = [NSMutableArray new];
    }
    return _viewArray;
}

@end
