//
//  AppActivity.m
//  One2Ten2Hundred
//
//  Created by yangqingluo on 16/4/28.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import "AppActivity.h"

#define default_activity_height 320

@interface AppActivity()

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *cancelButtonTitle;
@property (nonatomic,strong) NSString *otherButtonTitle;

@property (nonatomic,strong) UIView *topBar;
@property (nonatomic,strong) UIView *bottomBar;

@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,assign) id<AppActivityDelegate>delegate;

@end

@implementation AppActivity

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle{
    self = [super init];
    if (self) {
        self.title = title;
        self.message = message;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitle = otherButtonTitle;
        
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = RGBA(0, 0, 0, 0.2);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        if (delegate) {
            self.delegate = delegate;
        }
        
        [self initSubviews];
    }
    
    return self;
}

- (void)dismiss{
    [UIView animateWithDuration:0.25 animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)view{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

- (void)tappedCancel{
    [self dismiss];
}

- (void)tappedBackGroundView{
    
    
}

- (void)initSubviews{
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
    [self.backGroundView addGestureRecognizer:tapGesture];
    
    [self addSubview:self.backGroundView];
    
    [self.backGroundView addSubview:self.topBar];
    
    if (self.cancelButtonTitle) {
        [self.backGroundView addSubview:self.bottomBar];
        self.textView.frame = CGRectMake(0, DEFAULT_BAR_HEIGHT, self.width, default_activity_height - 2 * DEFAULT_BAR_HEIGHT);
    }
    
    [self.backGroundView addSubview:self.textView];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - default_activity_height, [UIScreen mainScreen].bounds.size.width, default_activity_height)];
    } completion:^(BOOL finished) {
    }];
}

- (void)closeButtonClick{
    [self dismiss];
}

- (void)cancelButtonClick{
    [self dismiss];
}

- (void)otherButtonClick{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(didClickOnOtherButton:)]) {
        [self.delegate didClickOnOtherButton:self];
    }
}

#pragma getter
- (UIView *)topBar{
    if (!_topBar) {
        _topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, DEFAULT_BAR_HEIGHT)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *i = [UIImage imageNamed:@"nav_close"];
        [btn setImage:i forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0, 0, 64, 44)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, kEdge, 0, 0);
        [btn addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_topBar addSubview:btn];
        
        if (self.title) {
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:_topBar.bounds];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [titleLabel setTextColor:[UIColor blackColor]];
            [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            
            titleLabel.text = self.title;
            [_topBar addSubview:titleLabel];
        }
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _topBar.height - 0.5, _topBar.width, 0.5)];
        lineView.backgroundColor = appSeparatorColor;
        [_topBar addSubview:lineView];
    }
    
    return _topBar;
}

- (UIView *)bottomBar{
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc]initWithFrame:CGRectMake(0, default_activity_height - DEFAULT_BAR_HEIGHT, self.width, DEFAULT_BAR_HEIGHT)];
        
        
        UIButton *cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(0.5 * _bottomBar.width, 0, 0.5 * _bottomBar.width, _bottomBar.height)];
        [cancleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        cancleButton.backgroundColor = [UIColor clearColor];
        [cancleButton setTitle:(self.cancelButtonTitle ? self.cancelButtonTitle : @"取消") forState:UIControlStateNormal];
        [cancleButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.cancelButtonTitle) {
            [_bottomBar addSubview:cancleButton];
            
            if (self.otherButtonTitle) {
                UIButton *otherButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0.5 * _bottomBar.width, _bottomBar.height)];
                [otherButton setTitleColor:appMainColor forState:UIControlStateNormal];
                otherButton.backgroundColor = [UIColor clearColor];
                [otherButton setTitle:self.otherButtonTitle forState:UIControlStateNormal];
                [otherButton addTarget:self action:@selector(otherButtonClick) forControlEvents:UIControlEventTouchUpInside];
                [_bottomBar addSubview:otherButton];
                
                UIView *separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.5, _bottomBar.height)];
                separatorView.center = CGPointMake(0.5 * _bottomBar.width, 0.5 * _bottomBar.height);
                separatorView.backgroundColor = appSeparatorColor;
                [_bottomBar addSubview:separatorView];
            }
            else{
                cancleButton.frame = _bottomBar.bounds;
            }
        }
        
        
        
        
        
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _bottomBar.width, 0.5)];
        lineView.backgroundColor = appSeparatorColor;
        [_bottomBar addSubview:lineView];
    }
    
    return _bottomBar;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, DEFAULT_BAR_HEIGHT, self.width, default_activity_height - DEFAULT_BAR_HEIGHT)];
        _textView.text = self.message;
        _textView.textColor = [UIColor grayColor];
        _textView.font = [UIFont systemFontOfSize:16.0];
        _textView.textContainerInset = UIEdgeInsetsMake(kEdge, kEdge, 0, kEdge);
        _textView.editable = NO;
    }
    
    return _textView;
}

@end
