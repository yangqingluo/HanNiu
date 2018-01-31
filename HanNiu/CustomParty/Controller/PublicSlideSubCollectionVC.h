//
//  PublicSlideSubCollectionVC.h
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicCollectionViewController.h"

#import "PublicCollectionHeaderAdView.h"

static NSString *reuseId_header_title = @"reuseId_header_title";
static NSString *reuseId_header_ad = @"reuseId_header_ad";
static NSString *reuseId_cell_btn = @"reuseId_cell_btn";

@interface PublicSlideSubCollectionVC : PublicCollectionViewController

@property (strong, nonatomic) PublicCollectionHeaderAdView *adHeadView;
@property (strong, nonatomic) NSMutableArray *bannerList;

@end
