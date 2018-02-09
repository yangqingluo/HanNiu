//
//  CommentCellFooterView.h
//  HanNiu
//
//  Created by 7kers on 2018/2/9.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCellFooterView : UIView

@property (strong, nonatomic) UIImageView *showImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;

+ (CGFloat)footerHeight;

@end


@interface CommentToMeCellFooterView : CommentCellFooterView

@property (strong, nonatomic) UILabel *tagLabel;

@end

@interface CommentFromMeCellFooterView : CommentCellFooterView

@property (strong, nonatomic) NSString *musicId;

- (void)clear;

@end
