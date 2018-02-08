//
//  PublicImageTagTitleself.m
//  HanNiu
//
//  Created by 7kers on 2018/1/31.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicImageTagTitleCell.h"

#import "UIImageView+WebCache.h"

@implementation PublicImageTagTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel.height = 0.4 * self.showImageView.height;
        self.subTitleLabel.top = self.titleLabel.bottom;
        
        self.tagLabel = NewLabel(self.subTitleLabel.frame, self.subTitleLabel.textColor, self.subTitleLabel.font, self.subTitleLabel.textAlignment);
        self.tagLabel.top = self.subTitleLabel.bottom;
        [self.contentView addSubview:self.tagLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation MusicCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel.height = 0.5 * self.showImageView.height;
        self.tagLabel.frame = CGRectMake(screen_width - kEdgeMiddle - appTimeLabelWidth, self.titleLabel.top, appTimeLabelWidth, self.titleLabel.height);
        self.tagLabel.textAlignment = NSTextAlignmentRight;
        
        self.subTitleLabel.frame = CGRectMake(self.titleLabel.left, self.showImageView.centerY, self.tagLabel.left - self.titleLabel.left, self.subTitleLabel.height);
        
        self.likeBtn = [[PublicButton alloc] initWithFrame:CGRectMake(self.tagLabel.left, self.subTitleLabel.top, self.tagLabel.width, self.subTitleLabel.height)];
        self.likeBtn.positionStyle = PublicButtonPSRightTextLeftImageRight;
        [self adjustPublicButton:self.likeBtn];
        self.likeBtn.showImageView.image = [UIImage imageNamed:@"icon_good_no"];
        self.likeBtn.showImageView.highlightedImage = [UIImage imageNamed:@"icon_good_yes"];
    }
    return self;
}

- (void)adjustPublicButton:(PublicButton *)button {
    CGFloat radius = 12.0;
    button.edgeInTextImage = 3.0;
    button.showImageView.frame = CGRectMake(button.width - radius, 0.5 * (button.height - radius), radius, radius);
    button.showLabel.frame = CGRectMake(0, 0, button.showImageView.left - button.edgeInTextImage, button.height);
    button.showLabel.textColor = self.subTitleLabel.textColor;
    button.showLabel.font = self.subTitleLabel.font;
    button.showLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:button];
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath andSubTitle:(NSString *)subTitle {
    CGFloat m_height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    CGFloat textHeight = ceil([AppPublic textSizeWithString:subTitle font:[AppPublic appFontOfSize:appLabelFontSizeLittle] constantWidth:(screen_width - kEdgeMiddle - appTimeLabelWidth - 2 * kEdgeMiddle - (m_height - 2 * kEdge))].height);
    return m_height + MAX(0, textHeight - (0.5 * m_height - kEdge));
}

- (void)setData:(AppCommentInfo *)data {
    _data = data;
    
    [self.showImageView sd_setImageWithURL:fileURLWithPID(_data.User.Image) placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    self.titleLabel.text = _data.User.Name;
    self.tagLabel.text = stringFromDate([NSDate dateWithTimeIntervalSince1970:0.001 * [_data.UpdateTime integerValue]], @"yyyy.MM.dd");
    self.likeBtn.showLabel.text = [NSString stringWithFormat:@"%d", _data.LikeCount];
    self.likeBtn.selected = _data.HasMakeGood;
    self.subTitleLabel.text = _data.showStringForContent;
    [AppPublic adjustLabelHeight:self.subTitleLabel];
}

@end



