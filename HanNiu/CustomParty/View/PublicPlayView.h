//
//  PublicPlayView.h
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicSlider.h"
#import "PublicPlayerManager.h"

@interface PublicPlayView : UIView

@property (strong, nonatomic, readonly) UIView *baseView;
@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UIButton *lastBtn;
@property (strong, nonatomic) UIButton *nextBtn;
@property (strong, nonatomic) PublicSlider *progressSlider;
@property (strong, nonatomic) UIButton *listBtn;
@property (strong, nonatomic) UIButton *favorBtn;
@property (strong, nonatomic) UIButton *messageBtn;
@property (strong, nonatomic) UILabel *startLabel;
@property (strong, nonatomic) UILabel *endLabel;
@property (strong, nonatomic) UITextField *textField;


@property (strong, nonatomic) id playerTimeObserver;

- (void)updateFavorButtonInCollection:(BOOL)isInCollect;

@end
