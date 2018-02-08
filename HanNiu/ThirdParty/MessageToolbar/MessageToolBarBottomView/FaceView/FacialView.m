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

#import "FacialView.h"
#import "PublicEmoji.h"
#import "NSAttributedString+JTATEmoji.h"


@interface FacialView ()<UIScrollViewDelegate>{
    UIScrollView *baseScrollView;
    UIScrollView *pointScrollView;
}

@end

@implementation FacialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _faces = [PublicEmoji allEmoji];
    }
    return self;
}


//给faces设置位置
-(void)loadFacialView:(int)page size:(CGSize)size{

    int countPerPage = 20;
    int pages = ceil(_faces.count / (double)countPerPage);
    
    CGFloat s_width = self.bounds.size.width;
    CGFloat s_height = self.bounds.size.height;
    
    baseScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    baseScrollView.contentSize = CGSizeMake(s_width * pages, s_height);
    baseScrollView.pagingEnabled = YES;
    baseScrollView.bounces = NO;
    [self addSubview:baseScrollView];

    int maxCol = 7;
    int maxRow = 3;

    CGFloat itemWidth = s_width / maxCol;
    CGFloat itemHeight = s_height / maxRow;
    
    for (NSString *string in _faces) {
        NSInteger index = [_faces indexOfObject:string];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setFrame:CGRectMake(itemWidth * (index % 20 % 7) + s_width * (index / countPerPage), itemHeight * ((index % 20) / 7), itemWidth, itemHeight)];
        
        [button setAttributedTitle:[NSAttributedString emojiAttributedString:string withFont:[UIFont fontWithName:@"AppleColorEmoji" size:16.0]] forState:UIControlStateNormal];
        
        button.tag = index;
        [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        [baseScrollView addSubview:button];
    }
    
    for (int i = 0; i < pages; i++) {
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setBackgroundColor:[UIColor clearColor]];
        [deleteButton setFrame:CGRectMake(s_width * i + (maxCol - 1) * itemWidth, (maxRow - 1) * itemHeight, itemWidth, itemHeight)];
        [deleteButton setImage:[UIImage imageNamed:@"faceDelete"] forState:UIControlStateNormal];
        deleteButton.tag = -1;
        [deleteButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        [baseScrollView addSubview:deleteButton];
    }
    
}


-(void)selected:(UIButton*)bt
{
    if (bt.tag == -1 && _delegate) {
        [_delegate deleteSelected:nil];
    }else{
        NSString *str = [_faces objectAtIndex:bt.tag];
        if (_delegate) {
            [_delegate selectedFacialView:str];
        }
    }
}

- (void)sendAction:(id)sender
{
    if (_delegate) {
        [_delegate sendFace];
    }
}

@end
