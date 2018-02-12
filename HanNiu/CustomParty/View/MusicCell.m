//
//  MusicCell.m
//  HanNiu
//
//  Created by 7kers on 2018/1/25.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "MusicCell.h"
#import "UIImageView+WebCache.h"

@implementation MusicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat m_height = 20.0;
        self.subTitleLabel.frame = CGRectMake(screen_width - kEdgeMiddle - appTimeLabelWidth, self.showImageView.centerY + kEdgeSmall, appTimeLabelWidth, m_height);
        self.subTitleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.subTitleLabel];
        
        CGFloat m_width = 60.0;
        _playBtn = [[PublicButton alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.subTitleLabel.top, m_width, m_height)];
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

- (void)adjustPublicButton:(PublicButton *)button {
    CGFloat radius = 12.0;
    button.positionStyle = PublicButtonPSLeftTextRightImageLeft;
    button.edgeInTextImage = 3.0;
    button.showImageView.frame = CGRectMake(0, 0.5 * (button.height - radius), radius, radius);
    button.showLabel.frame = CGRectMake(button.showImageView.right + button.edgeInTextImage, 0, button.width - (button.showImageView.right + button.edgeInTextImage), button.height);
    button.showLabel.textColor = self.subTitleLabel.textColor;
    button.showLabel.font = self.subTitleLabel.font;
    button.showLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:button];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter
- (void)setMusic:(AppMusicInfo *)music {
    _music = music;
    AppItemInfo *item = music.showItem;
    
    [self.showImageView sd_setImageWithURL:fileURLWithPID(item.Image)];
    self.titleLabel.text = item.Name;
    self.playBtn.showLabel.text = [NSString stringWithFormat:@"%d", music.PlayTimes];
    self.messageBtn.showLabel.text = [NSString stringWithFormat:@"%d", music.Comment];
    self.timeBtn.showLabel.text = stringWithTimeInterval(music.Duration);
}

@end
