//
//  JobDetailVC.h
//  HanNiu
//
//  Created by 7kers on 2018/2/5.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicViewController.h"

#import "PublicCollectionHeaderTitleView.h"

@interface JobHeaderView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UILabel *tagLabel;

@end

@interface JobFooterView : UIView

@property (strong, nonatomic) PublicCollectionHeaderTitleView *headerView;
@property (strong, nonatomic) UITextView *textView;

@end

@interface JobDetailVC : PublicViewController

@property (copy, nonatomic) AppJobInfo *data;
@property (assign, nonatomic) BOOL showCompany;


@end
