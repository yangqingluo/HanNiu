//
//  CollegeIntroduceHeaderView.h
//  HanNiu
//
//  Created by 7kers on 2018/2/4.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicDetailImageAndSubTitleHeaderView.h"

@interface CollegeIntroduceHeaderView : PublicDetailImageAndSubTitleHeaderView

@property (strong, nonatomic) UIButton *foldBtn;

- (void)adjustTagLabelHeight:(NSInteger)numberOfLines;

@end
