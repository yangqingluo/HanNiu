//
//  SchoolDetailVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/4.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "SchoolDetailVC.h"
#import "SchoolDetailSlideSubTableVC.h"
#import "SchoolDetailSlideMajorVC.h"

@interface SchoolDetailVC ()

@property (strong, nonatomic) NSArray *majorGradeTitleArray;

@end

@implementation SchoolDetailVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        [self addViewController:@"简介" vc:[[SchoolDetailSlideSubTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self andIndexTag:0]];
        [self addViewController:@"精品收听" vc:[[SchoolDetailSlideSubTableVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self andIndexTag:1]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.data.Name;
    
    [self pullBaseListData:YES];
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
            [btn addTarget:self action:@selector(homeButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 2) {
            UIButton *btn = NewRightButton([UIImage imageNamed:@"icon_share"], nil);
            btn.frame = CGRectMake(screen_width - 2 * 44, 0, 44, DEFAULT_BAR_HEIGHT);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
            [btn addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)pullBaseListData:(BOOL)isReset {
    [self doGetSchoolDetailFunction];
    [self doGetMusicCommentFunction];
    [self doGetMajorListFunction];
}

- (void)doGetSchoolDetailFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"id" : self.data.Id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"University/School/Detail" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            
        }
    }];
}

- (void)doGetMajorListFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"schoolId" : self.data.Id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"University/Major/List" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself updateMajorViews:[AppMajorMusicInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
        }
    }];
}

- (void)doGetMusicCommentFunction {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"MusicId" : self.data.Music.Id}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Music/Comment/List" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            
        }
    }];
}

- (void)updateMajorViews:(NSArray *)majorList {
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:[NSMutableArray new]];
    [self.dataSource addObject:[NSMutableArray new]];
    [self.dataSource addObject:[NSMutableArray new]];
    for (AppMajorMusicInfo *item in majorList) {
        int Grade = [item.Grade intValue];
        if (Grade < self.dataSource.count) {
            NSMutableArray *m_list = self.dataSource[Grade];
            [m_list addObject:item];
        }
    }
    NSMutableArray *m_array = [NSMutableArray new];
    for (NSDictionary *m_dic in self.viewArray) {
        if ([m_dic[@"VC"] isKindOfClass:[SchoolDetailSlideSubTableVC class]]) {
            [m_array addObject:m_dic];
        }
    }
    for (NSUInteger i = 0; i < self.dataSource.count; i++) {
        NSArray *m_list = self.dataSource[i];
        if (m_list.count) {
            SchoolDetailSlideMajorVC *vc = [[SchoolDetailSlideMajorVC alloc] initWithStyle:UITableViewStyleGrouped parentVC:self andIndexTag:i];
            [vc.dataSource addObjectsFromArray:m_list];
            [m_array insertObject:@{@"title" : self.majorGradeTitleArray[i], @"VC" : vc} atIndex:m_array.count - 1];
        }
    }
    [self.viewArray removeAllObjects];
    [self.viewArray addObjectsFromArray:m_array];
    [self.slidePageView buildUI];
}

#pragma mark - getter
- (NSArray *)majorGradeTitleArray {
    if (!_majorGradeTitleArray) {
        _majorGradeTitleArray = @[@"专科专业", @"本科专业", @"硕士专业"];
    }
    return _majorGradeTitleArray;
}

@end
