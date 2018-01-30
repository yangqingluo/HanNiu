//
//  PublicCollectionCell.h
//  HanNiu
//
//  Created by 7kers on 2018/1/23.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicLabel.h"

@interface PublicCollectionCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *showImageView;
@property (strong, nonatomic) PublicLabel *titleLabel;

@end