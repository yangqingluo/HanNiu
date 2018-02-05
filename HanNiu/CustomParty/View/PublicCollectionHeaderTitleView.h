//
//  PublicCollectionHeaderTitleView.h
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Event_PublicCollectionHeaderTitleViewTapped @"Event_PublicCollectionHeaderTitleViewTapped"

@interface PublicCollectionHeaderTitleView : UICollectionReusableView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UIImageView *rightImageView;

@end
