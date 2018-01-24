//
//  QuantityCell.m
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "QuantityCell.h"
#import "UIImageView+WebCache.h"

@implementation QuantityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat radius = kCellHeightBig - 2 * kEdgeMiddle;
        self.showImageView.frame = CGRectMake(kEdgeMiddle, kEdgeMiddle, radius, radius);
        self.showImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.frame = CGRectMake(self.showImageView.right + kEdgeMiddle, kEdge, self.contentView.width - (self.showImageView.right + kEdgeMiddle), 0.5 * [[self class] tableView:nil heightForRowAtIndexPath:nil]);
        CGFloat m_height = 20.0;
        self.subTitleLabel = NewLabel(CGRectMake(screen_width - kEdgeMiddle - 120, self.titleLabel.bottom, 120, m_height), [UIColor lightGrayColor], [AppPublic appFontOfSize:appLabelFontSizeLittle], NSTextAlignmentRight);
        [self.contentView addSubview:self.subTitleLabel];
        
        CGFloat m_width = 60.0;
        _playBtn = [[PublicButton alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom, m_width, m_height)];
        [self adjustPublicButton:_playBtn];
        _messageBtn = [[PublicButton alloc] initWithFrame:CGRectMake(_playBtn.right, _playBtn.top, m_width, m_height)];
        [self adjustPublicButton:_messageBtn];
        _timeBtn = [[PublicButton alloc] initWithFrame:CGRectMake(_messageBtn.right, _playBtn.top, m_width, m_height)];
        [self adjustPublicButton:_timeBtn];
        
        _playBtn.showImageView.image = [UIImage imageNamed:@"icon_play_gray"];
        _messageBtn.showImageView.image = [UIImage imageNamed:@"icon_comment_gray"];
        _timeBtn.showImageView.image = [UIImage imageNamed:@"icon_audio_duration"];
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

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeightBig;
}

- (void)adjustPublicButton:(PublicButton *)button {
    CGFloat radius = 12.0;
    button.positionStyle = PublicButtonPSLeftTextRightImageLeft;
    button.edgeInTextImage = 3.0;
    button.showImageView.frame = CGRectMake(0, 0.5 * (button.height - radius), radius, radius);
    button.showLabel = NewLabel(CGRectMake(button.showImageView.right + button.edgeInTextImage, 0, button.width - (button.showImageView.right + button.edgeInTextImage), button.height), self.subTitleLabel.textColor, self.subTitleLabel.font, NSTextAlignmentLeft);
    [button addSubview:button.showLabel];
    [self.contentView addSubview:button];
}

#pragma mark - setter
- (void)setData:(AppQualityInfo *)data {
    _data = data;
    
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:urlStringWithService([NSString stringWithFormat:@"File/?pid=%@", data.Image])]];
    self.titleLabel.text = data.Name;
    self.subTitleLabel.text = stringFromDate([NSDate dateWithTimeIntervalSince1970:0.001 * [data.UpdateTime integerValue]], @"yyyy.MM.dd");
    self.playBtn.showLabel.text = data.Music.PlayTimes;
    self.messageBtn.showLabel.text = data.Music.Comment;
    self.timeBtn.showLabel.text = stringWithTimeInterval([data.Music.Duration integerValue]);
}

@end
