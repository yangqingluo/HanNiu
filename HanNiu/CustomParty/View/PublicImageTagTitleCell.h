//
//  PublicImageTagTitleCell.h
//  HanNiu
//
//  Created by 7kers on 2018/1/31.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicImageSubTitleCell.h"
#import "PublicButton.h"
#import "CommentCellFooterView.h"

@interface PublicImageTagTitleCell : PublicImageSubTitleCell

@property (strong, nonatomic) UILabel *tagLabel;

@end


@interface MusicCommentCell : PublicImageTagTitleCell

@property (strong, nonatomic) PublicButton *likeBtn;
@property (strong, nonatomic) AppCommentInfo *data;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath andSubTitle:(NSString *)subTitle;

@end


@interface MusicCommentToMeCell : PublicImageTagTitleCell

@property (strong, nonatomic) CommentToMeCellFooterView *footerView;

@property (strong, nonatomic) AppCommentInfo *data;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath andComment:(AppCommentInfo *)data;

@end

@interface MusicCommentFromMeCell : PublicImageTagTitleCell

@property (strong, nonatomic) CommentFromMeCellFooterView *footerView;

@property (strong, nonatomic) AppCommentInfo *data;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath andComment:(AppCommentInfo *)data;

@end
