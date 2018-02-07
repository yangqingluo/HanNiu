//
//  PublicImageTagTitleCell.h
//  HanNiu
//
//  Created by 7kers on 2018/1/31.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicImageSubTitleCell.h"
#import "PublicButton.h"

@interface PublicImageTagTitleCell : PublicImageSubTitleCell

@property (strong, nonatomic) UILabel *tagLabel;

@end


@interface MusicCommentCell : PublicImageTagTitleCell

@property (strong, nonatomic) PublicButton *likeBtn;
@property (strong, nonatomic) AppCommentInfo *data;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath andSubTitle:(NSString *)subTitle;

@end
