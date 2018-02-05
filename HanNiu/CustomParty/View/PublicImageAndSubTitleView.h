//
//  PublicImageAndSubTitleView.h
//  HanNiu
//
//  Created by 7kers on 2018/2/5.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicImageAndSubTitleView : UIView

@property (strong, nonatomic) UIImageView *showImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;

@end

@interface PublicBorderImageAndSubTitleView : PublicImageAndSubTitleView

@end
