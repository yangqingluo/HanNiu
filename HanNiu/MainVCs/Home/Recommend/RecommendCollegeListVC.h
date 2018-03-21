//
//  RecommendCollegeListVC.h
//  HanNiu
//
//  Created by 7kers on 2018/2/5.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "CollegeListVC.h"
#import "DoubleImageView.h"
#import "PublicGridLabelView.h"
#import "PublicImageSubTagTitleCell.h"

@interface RecommendCollegeListCell : PublicImageSubTagTitleCell

@property (strong, nonatomic) PublicGridLabelView *gridLabelView;
@property (strong, nonatomic) UIImageView *bigImageView;

@end

@interface RecommendCollegeListVC : CollegeListVC

@end
