//
//  PublicCollectionViewController.m
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicCollectionViewController.h"

#import "MJRefresh.h"

@interface PublicCollectionViewController ()

@property (strong, nonatomic) LongPressFlowLayout *flowLayout;

@end

@implementation PublicCollectionViewController

//- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
//    self = [super init];
//    if (self) {
//        _flowLayout = layout;
//    }
//    return self;
//}

- (instancetype)initWithCollectionRowCount:(NSUInteger)count cellHeight:(CGFloat)height{
    return [self initWithCollectionRowCount:count cellHeight:height sectionInset:UIEdgeInsetsZero];
}

- (instancetype)initWithCollectionRowCount:(NSUInteger)count cellHeight:(CGFloat)height sectionInset:(UIEdgeInsets)sectionInset {
    self = [super init];
    if (self) {
        double width = [[self class] cellWithWithListCount:count sectionInset:sectionInset];
        self.flowLayout.itemSize = CGSizeMake(width, height);
        self.flowLayout.sectionInset = sectionInset;
    }
    return self;
}

- (instancetype)initWithCollectionSectionInset:(UIEdgeInsets)sectionInset {
    self = [super init];
    if (self) {
        double width = [[self class] cellWithWithListCount:3 sectionInset:sectionInset];
        self.flowLayout.itemSize = CGSizeMake(width, width + 40);
        self.flowLayout.sectionInset = sectionInset;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public
- (void)loadFirstPageData {
    [self pullBaseListData:YES];
}

- (void)loadMoreData {
    [self pullBaseListData:NO];
}

- (void)pullBaseListData:(BOOL)isReset {
    
}

- (void)updateScrollViewHeader {
    QKWEAKSELF;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstPageData];
    }];
}

- (void)updateScrollViewFooter {
    QKWEAKSELF;
    if (!self.collectionView.mj_footer) {
        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakself loadMoreData];
        }];
    }
}

- (void)beginRefreshing {
    self.needRefresh = NO;
    self.isResetCondition = NO;
    [self.collectionView.mj_header beginRefreshing];
}

- (void)endRefreshing {
    //记录刷新时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.dateKey];
    [self doHideHudFunction];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)updateSubviews {
    [self.collectionView reloadData];
}

+ (CGFloat)cellWithWithListCount:(NSUInteger)countH sectionInset:(UIEdgeInsets)sectionInset {
    return (screen_width - sectionInset.left - sectionInset.right - kEdge * (countH - 1)) / countH;
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:self.flowLayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight |  UIViewAutoresizingFlexibleBottomMargin;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

- (LongPressFlowLayout *)flowLayout {
    if (!_flowLayout) {
        double width = [[self class] cellWithWithListCount:3 sectionInset:UIEdgeInsetsZero];
        _flowLayout = [LongPressFlowLayout new];
        _flowLayout.scrollDirection =  UICollectionViewScrollDirectionVertical;
        _flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        _flowLayout.footerReferenceSize = CGSizeMake(0, 0);
        _flowLayout.itemSize = CGSizeMake(width, width + 40);
        _flowLayout.minimumInteritemSpacing = 0.0;
        _flowLayout.minimumLineSpacing = 0.0;
//        _flowLayout.sectionInset = UIEdgeInsetsMake(0, kEdgeMiddle, 0, 0);
    }
    return _flowLayout;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 0;
}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//
//    // Configure the cell
//
//    return cell;
//}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
 return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 
 }
 */

@end
