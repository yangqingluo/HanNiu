//
//  PublicImageTagTitleself.m
//  HanNiu
//
//  Created by 7kers on 2018/1/31.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicImageTagTitleCell.h"

#import "UIImageView+WebCache.h"

#import "NSAttributedString+JTATEmoji.h"

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel.height = 0.5 * self.showImageView.height;
        self.tagLabel.frame = CGRectMake(screen_width - kEdgeMiddle - appTimeLabelWidth, self.titleLabel.top, appTimeLabelWidth, self.titleLabel.height);
        self.tagLabel.textAlignment = NSTextAlignmentRight;
        
        self.subTitleLabel.frame = CGRectMake(self.titleLabel.left, self.showImageView.centerY, self.tagLabel.left - self.titleLabel.left, self.subTitleLabel.height);
        
        self.likeBtn = [[PublicButton alloc] initWithFrame:CGRectMake(0, 0.4 * self.showImageView.height, 40, 40)];
        self.likeBtn.right = self.tagLabel.right;
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
    button.showLabel.numberOfLines = 0;
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


@implementation MusicCommentToMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel.height = 0.5 * self.showImageView.height;
        self.tagLabel.frame = CGRectMake(self.titleLabel.left, self.showImageView.centerY, appTimeLabelWidth, self.subTitleLabel.height);
        
        self.subTitleLabel.frame = CGRectMake(kEdgeMiddle, self.showImageView.bottom + kEdge, screen_width - 2 * kEdgeMiddle, 30);
        self.footerView = [CommentToMeCellFooterView new];
        self.footerView.top = self.subTitleLabel.bottom + kEdge;
        [self.contentView addSubview:self.footerView];
    }
    return self;
}

NSAttributedString *attributedStringWithToMeData(AppCommentInfo *data, UIFont *font) {
    NSDictionary *dic1 = @{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : font};
    NSDictionary *dic2 = @{NSForegroundColorAttributeName : appMainColor, NSFontAttributeName : font};
    NSMutableAttributedString *m_string = [NSMutableAttributedString new];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:@"回复了" attributes:dic1]];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"@%@：", data.ToUser.Name] attributes:dic2]];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:data.Content attributes:dic1]];
    return m_string;
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath andComment:(AppCommentInfo *)data {
    UIFont *font = [AppPublic appFontOfSize:appLabelFontSizeLittle];
    NSStringDrawingOptions drawOptions = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSAttributedString *m_string = attributedStringWithToMeData(data, font);
    CGFloat textHeight = ceil([m_string boundingRectWithSize:CGSizeMake(screen_width - 2 * kEdgeMiddle, MAXFLOAT) options:drawOptions context:nil].size.height);
    
    CGFloat m_height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    return m_height + textHeight + [CommentCellFooterView footerHeight] + 2 * kEdge;
}

- (void)setData:(AppCommentInfo *)data {
    _data = data;
    
    [self.showImageView sd_setImageWithURL:fileURLWithPID(_data.User.Image) placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    self.titleLabel.text = _data.User.Name;
    self.tagLabel.text = stringFromDate([NSDate dateWithTimeIntervalSince1970:0.001 * [_data.UpdateTime integerValue]], @"yyyy.MM.dd");
    self.subTitleLabel.attributedText = attributedStringWithToMeData(_data, self.subTitleLabel.font);
    [AppPublic adjustLabelHeight:self.subTitleLabel];
    
    self.footerView.top = self.subTitleLabel.bottom + kEdge;
    self.footerView.titleLabel.text = _data.ToUser.Name;
    self.footerView.subTitleLabel.text = _data.ToComment.showStringForContent;
    self.footerView.tagLabel.text = stringFromDate([NSDate dateWithTimeIntervalSince1970:0.001 * [_data.ToComment.CreateTime integerValue]], @"yyyy.MM.dd HH:mm");
}

@end

@implementation MusicCommentFromMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel.height = 0.5 * self.showImageView.height;
        self.tagLabel.frame = CGRectMake(self.titleLabel.left, self.showImageView.centerY, appTimeLabelWidth, self.subTitleLabel.height);
        
        self.subTitleLabel.frame = CGRectMake(kEdgeMiddle, self.showImageView.bottom + kEdge, screen_width - 2 * kEdgeMiddle, 30);
        self.footerView = [CommentFromMeCellFooterView new];
        self.footerView.top = self.subTitleLabel.bottom + kEdge;
        [self.contentView addSubview:self.footerView];
    }
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath andComment:(AppCommentInfo *)data {
    UIFont *font = [AppPublic appFontOfSize:appLabelFontSizeLittle];
    CGFloat textHeight = ceil([AppPublic textSizeWithString:data.Content font:font constantWidth:screen_width - 2 * kEdgeMiddle].height);
    
    CGFloat m_height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    return m_height + textHeight + [CommentCellFooterView footerHeight] + 2 * kEdge;
}

- (void)setData:(AppCommentInfo *)data {
    _data = data;
    
    [self.showImageView sd_setImageWithURL:fileURLWithPID(_data.User.Image) placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    self.titleLabel.text = _data.User.Name;
    self.tagLabel.text = stringFromDate([NSDate dateWithTimeIntervalSince1970:0.001 * [_data.UpdateTime integerValue]], @"yyyy.MM.dd");
    self.subTitleLabel.text = _data.Content;
    [AppPublic adjustLabelHeight:self.subTitleLabel];
    
    self.footerView.top = self.subTitleLabel.bottom + kEdge;
    self.footerView.musicId = _data.MusicId;
    
}
@end
