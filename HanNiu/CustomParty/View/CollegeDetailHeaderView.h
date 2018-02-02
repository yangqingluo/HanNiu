//
//  CollegeDetailHeaderView.h
//  HanNiu
//
//  Created by 7kers on 2018/2/1.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicDetailImageAndSubTitleHeaderView.h"
#import "PublicGridLabelView.h"

@interface CollegeDetailHeaderView : PublicDetailImageAndSubTitleHeaderView

@property (strong, nonatomic) PublicGridLabelView *gridLabelView;
@property (copy, nonatomic) AppCollegeInfo *data;

@end
