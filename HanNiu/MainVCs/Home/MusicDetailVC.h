//
//  MusicDetailVC.h
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicViewController.h"

@interface MusicDetailVC : PublicViewController

@property (strong, nonatomic) AppQualityInfo *data;

@property (nonatomic, strong) id playerTimeObserver;

@end
