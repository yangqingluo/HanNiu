//
//  PublicCollectionViewController.h
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicViewController.h"

#import "LongPressFlowLayout.h"

@interface PublicCollectionViewController : PublicViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

//- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout;
- (instancetype)initWithCollectionRowCount:(NSUInteger)count cellHeight:(CGFloat)height;
- (instancetype)initWithCollectionRowCount:(NSUInteger)count cellHeight:(CGFloat)height sectionInset:(UIEdgeInsets)sectionInset;
- (instancetype)initWithCollectionSectionInset:(UIEdgeInsets)sectionInset;

- (void)updateScrollViewHeader;
- (void)updateScrollViewFooter;
- (void)beginRefreshing;
- (void)endRefreshing;
- (void)updateSubviews;
- (void)loadFirstPageData;
- (void)loadMoreData;
- (void)pullBaseListData:(BOOL)isReset;

@end
