//
//  AccountSuggestVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/22.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AccountSuggestVC.h"

#import "XHMessageTextView.h"

@interface AccountSuggestVC ()<UITextViewDelegate>

@end

@implementation AccountSuggestVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    
    UIButton *sendBtn = NewButton(CGRectMake(0, 0, 44, 44), @"提交", [UIColor whiteColor], nil);
    sendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    
    XHMessageTextView *inputTextView = [[XHMessageTextView alloc] initWithFrame:CGRectMake(kEdge, STATUS_BAR_HEIGHT + kEdge, screen_width - 2 * kEdge, self.view.height * (4.0 / 7.0))];
//    inputTextView.backgroundColor = [UIColor whiteColor];
    inputTextView.placeHolder = @"请输入要反馈的意见";
    inputTextView.font = [AppPublic appFontOfSize:appLabelFontSize];
    inputTextView.layer.cornerRadius = appViewCornerRadius;
    inputTextView.layer.borderColor = appSeparatorColor.CGColor;
    inputTextView.layer.borderWidth = appSeparaterLineSize;
    inputTextView.delegate = self;
    [self.view addSubview:inputTextView];
}

@end
