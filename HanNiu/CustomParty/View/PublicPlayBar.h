//
//  PublicPlayBar.h
//  HanNiu
//
//  Created by 7kers on 2018/1/25.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicPlayerManager.h"

@interface PublicPlayBar : UIView

+ (PublicPlayBar *)getInstance;

@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UIButton *listBtn;
@property (strong, nonatomic) UIImageView *playImageView;
@property (strong, nonatomic) UILabel *songName;
@property (strong, nonatomic) UILabel *singerName;

@end
