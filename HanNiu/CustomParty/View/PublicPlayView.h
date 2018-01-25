//
//  PublicPlayView.h
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicSlider.h"

@interface PublicPlayView : UIView

@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UIButton *lastBtn;
@property (strong, nonatomic) UIButton *nextBtn;
@property (nonatomic, strong) PublicSlider *progressSlider;

@property (nonatomic, strong) id playerTimeObserver;

@end
