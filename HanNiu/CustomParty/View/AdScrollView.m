//
//  AdScrollView.m
//  广告循环滚动效果
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//

#import "AdScrollView.h"

#define UISCREENWIDTH  self.bounds.size.width//广告的宽度
#define UISCREENHEIGHT  self.bounds.size.height//广告的高度

#define HIGHT self.bounds.origin.y //由于_pageControl是添加进父视图的,所以实际位置要参考,滚动视图的y坐标


@interface AdScrollView ()

{
    //广告的label
    UILabel * _adLabel;
    //循环滚动的三个视图
    UIImageView * _leftImageView;
    UIImageView * _centerImageView;
    UIImageView * _rightImageView;
    
    
    //为每一个图片添加一个广告语(可选)
    UILabel * _leftAdLabel;
    UILabel * _centerAdLabel;
    UILabel * _rightAdLabel;
    
    NSUInteger currentImage;
}

@property (retain,nonatomic,readonly) UIImageView * leftImageView;
@property (retain,nonatomic,readonly) UIImageView * centerImageView;
@property (retain,nonatomic,readonly) UIImageView * rightImageView;

@end

@implementation AdScrollView

- (void)dealloc{
    if ([_moveTime isValid]) {
        [_moveTime invalidate];
    }
    
    if ([_adjustTimer isValid]) {
        [_adjustTimer invalidate];
    }
}

- (instancetype)init {
    CGSize size = [AdScrollView adSize];
    self = [[AdScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self) {
        
    }
    return self;
}

- (void)stop{
//    if ([_moveTime isValid]) {
//        [_moveTime invalidate];
//    }
//    
//    if ([_adjustTimer isValid]) {
//        [_adjustTimer invalidate];
//    }
    
}

- (void)start{
    if ([_moveTime isValid]) {
        [_moveTime invalidate];
    }
    _moveTime = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(adjustPosition) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:_moveTime forMode:UITrackingRunLoopMode];
}

- (void)updateAdvertisements:(NSArray *)list {
    NSMutableArray *m_array = [NSMutableArray arrayWithCapacity:list.count];
    for (NSDictionary *item in list) {
        [m_array addObject:fileURLStringWithPID(item[@"Image"])];
    }
    self.imageNameArray = m_array;
}

- (void)updateImages:(NSArray *)list {
    self.imageNameArray = list;
}

#pragma mark - getter
+ (CGSize)adSize {
    return CGSizeMake(screen_width, screen_width * 1.0 / 2.5);
}

#pragma mark - 自由指定广告所占的frame
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.contents = (id)[UIImage imageNamed:@"placeholder_banner"].CGImage;
        self.PageControlShowStyle = UIPageControlShowStyleCenter;
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.currentPageIndicatorTintColor = appMainColor;
        
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
        self.contentSize = CGSizeMake(UISCREENWIDTH * 3, UISCREENHEIGHT);
        self.delegate = self;
        
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        _leftImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_leftImageView];
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        _centerImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_centerImageView];
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH*2, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        _rightImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_rightImageView];
        
        
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _centerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}


- (void)changeToIndex:(NSUInteger)index{
    if (index < self.imageNameArray.count) {
        currentImage = index;
        
        _pageControl.currentPage = currentImage;
        
        NSInteger leftIndex = (currentImage - 1 + _imageNameArray.count) % _imageNameArray.count;
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[leftIndex]] placeholderImage:nil];
        _leftAdLabel.text = _adTitleArray[leftIndex];
        
        
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[currentImage%_imageNameArray.count]] placeholderImage:nil];
        _centerAdLabel.text = _adTitleArray[currentImage % _imageNameArray.count];
        
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[(currentImage+1)%_imageNameArray.count]] placeholderImage:nil];
        _rightAdLabel.text = _adTitleArray[(currentImage + 1) % _imageNameArray.count];
        
        
        self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
        
        if ([_moveTime isValid]) {
            [_moveTime invalidate];
        }
        if ([_adjustTimer isValid]) {
            [_adjustTimer invalidate];
        }
        
        _moveTime = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(adjustPosition) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop]addTimer:_moveTime forMode:UITrackingRunLoopMode];
    }
}

-(void)adjustPosition{
    [self setContentOffset:CGPointMake(UISCREENWIDTH * 2, 0) animated:YES];
    
    if ([_adjustTimer isValid]) {
        [_adjustTimer invalidate];
    }
    _adjustTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:_adjustTimer forMode:UITrackingRunLoopMode];
}

#pragma mark - 设置广告所使用的图片(名字)
- (void)setImageNameArray:(NSArray *)imageNameArray
{
    _imageNameArray = imageNameArray;

    if (imageNameArray.count > 3) {
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[_imageNameArray.count - 1]] placeholderImage:nil];
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[0]] placeholderImage:nil];
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[1]] placeholderImage:nil];
    }
    else if (imageNameArray.count == 2) {
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[1]] placeholderImage:nil];
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[0]] placeholderImage:nil];
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[1]] placeholderImage:nil];
    }
    else if (imageNameArray.count == 1){
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[0]] placeholderImage:nil];
    }
    else{
        
    }
    
    _pageControl.numberOfPages = imageNameArray.count;
    
    [self changeToIndex:0];
}

#pragma mark - 设置每个对应广告对应的广告语
- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle
{
    _adTitleArray = adTitleArray;
    
    if(adTitleStyle == AdTitleShowStyleNone)
    {
        return;
    }

    
    _leftAdLabel = [[UILabel alloc]init];
    _centerAdLabel = [[UILabel alloc]init];
    _rightAdLabel = [[UILabel alloc]init];
    
    
    _leftAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
    [_leftImageView addSubview:_leftAdLabel];
    _centerAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
    [_centerImageView addSubview:_centerAdLabel];
    _rightAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
    [_rightImageView addSubview:_rightAdLabel];
    
    if (adTitleStyle == AdTitleShowStyleLeft) {
        _leftAdLabel.textAlignment = NSTextAlignmentLeft;
        _centerAdLabel.textAlignment = NSTextAlignmentLeft;
        _rightAdLabel.textAlignment = NSTextAlignmentLeft;
    }
    else if (adTitleStyle == AdTitleShowStyleCenter)
    {
        _leftAdLabel.textAlignment = NSTextAlignmentCenter;
        _centerAdLabel.textAlignment = NSTextAlignmentCenter;
        _rightAdLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        _leftAdLabel.textAlignment = NSTextAlignmentRight;
        _centerAdLabel.textAlignment = NSTextAlignmentRight;
        _rightAdLabel.textAlignment = NSTextAlignmentRight;
    }
    
    
    _leftAdLabel.text = _adTitleArray[0];
    _centerAdLabel.text = _adTitleArray[1];
    _rightAdLabel.text = _adTitleArray[2];
    
}


#pragma mark - 创建pageControl,指定其显示样式
- (void)setPageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
{
    if (PageControlShowStyle == UIPageControlShowStyleNone) {
        return;
    }
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = _imageNameArray.count;
    
    
    double height_control = 8;
    double edge_conttrol = 5;
    
    if (PageControlShowStyle == UIPageControlShowStyleLeft)
    {
        _pageControl.frame = CGRectMake(10, HIGHT + UISCREENHEIGHT - height_control - edge_conttrol, 20*_pageControl.numberOfPages, height_control);
    }
    else if (PageControlShowStyle == UIPageControlShowStyleCenter)
    {
        _pageControl.frame = CGRectMake(0, 0, 20 * _pageControl.numberOfPages, height_control);
        _pageControl.center = CGPointMake(UISCREENWIDTH / 2.0, HIGHT + UISCREENHEIGHT - 0.5 * _pageControl.height - edge_conttrol);
    }
    else
    {
        _pageControl.frame = CGRectMake( UISCREENWIDTH - 20 * _pageControl.numberOfPages, HIGHT+UISCREENHEIGHT - height_control - edge_conttrol, 20*_pageControl.numberOfPages, height_control);
    }

    _pageControl.currentPage = 0;
    
    _pageControl.enabled = NO;
    
    [self performSelector:@selector(addPageControl) withObject:nil afterDelay:0.1f];
}
//由于PageControl这个空间必须要添加在滚动视图的父视图上(添加在滚动视图上的话会随着图片滚动,而达不到效果)
- (void)addPageControl
{
    [[self superview] addSubview:_pageControl];
}

#pragma mark - 图片停止时,调用该函数使得滚动视图复用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!_imageNameArray.count) {
        return;
    }
    
    if (self.contentOffset.x == 0)
    {
        currentImage = (currentImage - 1 + _imageNameArray.count) % _imageNameArray.count;
        
    }
    else if(self.contentOffset.x == UISCREENWIDTH * 2)
    {
        
       currentImage = (currentImage + 1) % _imageNameArray.count;
    }
    else
    {
        return;
    }
    
    [self changeToIndex:currentImage];
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
