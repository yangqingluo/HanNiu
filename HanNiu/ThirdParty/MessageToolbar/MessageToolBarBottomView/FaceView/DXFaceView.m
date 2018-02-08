/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "DXFaceView.h"

@interface DXFaceView ()
{
    FacialView *_facialView;
}

@end

@implementation DXFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _facialView = [[FacialView alloc] initWithFrame: CGRectMake(5, 0, frame.size.width - 10, self.bounds.size.height - 35)];
        [_facialView loadFacialView:1 size:CGSizeMake(30, 30)];
        _facialView.delegate = self;
        [self addSubview:_facialView];
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 35, self.bounds.size.width, 35)];
        [bottomView setBackgroundColor:[UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0]];
        [self addSubview:bottomView];
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setTitle:NSLocalizedString(@"send", @"Send") forState:UIControlStateNormal];
        [sendButton setFrame:CGRectMake(bottomView.bounds.size.width - 90, 0, 90, bottomView.bounds.size.height)];
        [sendButton addTarget:self action:@selector(sendFace) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setBackgroundColor:[UIColor colorWithRed:0 / 255.0 green:191 / 255.0 blue:255 / 255.0 alpha:1.0]];
        [bottomView addSubview:sendButton];
    }
    return self;
}

#pragma mark - FacialViewDelegate

-(void)selectedFacialView:(NSString*)str{
    if (_delegate) {
        [_delegate selectedFacialView:str isDelete:NO];
    }
}

-(void)deleteSelected:(NSString *)str{
    if (_delegate) {
        [_delegate selectedFacialView:str isDelete:YES];
    }
}

- (void)sendFace
{
    if (_delegate) {
        [_delegate sendFace];
    }
}

#pragma mark - public

- (BOOL)stringIsFace:(NSString *)string
{
    if ([_facialView.faces containsObject:string]) {
        return YES;
    }
    
    return NO;
}

@end
