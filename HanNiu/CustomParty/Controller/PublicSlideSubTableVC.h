//
//  PublicSlideSubTableVC.h
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicShowTableVC.h"

#import "PublicCollectionHeaderAdView.h"

@interface PublicSlideSubTableVC : PublicShowTableVC

- (instancetype)initWithStyle:(UITableViewStyle)style parentVC:(PublicViewController *)pVC andIndexTag:(NSInteger)index;

@property (strong, nonatomic) AdScrollView *adHeadView;
@property (strong, nonatomic) NSMutableArray *bannerList;

@end
