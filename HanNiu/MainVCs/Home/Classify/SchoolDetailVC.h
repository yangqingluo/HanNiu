//
//  SchoolDetailVC.h
//  HanNiu
//
//  Created by 7kers on 2018/2/4.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicSlideViewController.h"

@interface SchoolDetailVC : PublicSlideViewController

@property (copy, nonatomic) AppQualityInfo *data;

@property (strong, nonatomic) NSMutableArray *majorListGrade0;
@property (strong, nonatomic) NSMutableArray *majorListGrade1;
@property (strong, nonatomic) NSMutableArray *majorListGrade2;

@end
