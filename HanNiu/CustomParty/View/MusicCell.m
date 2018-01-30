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
        CGFloat radius = kCellHeightBig - 2 * kEdge;
        self.showImageView.frame = CGRectMake(kEdgeMiddle, kEdge, radius, radius);
        [AppPublic roundCornerRadius:self.showImageView];
        self.titleLabel.frame = CGRectMake(self.showImageView.right + kEdgeMiddle, kEdge, self.contentView.width - (self.showImageView.right + kEdgeMiddle), 0.5 * [[self class] tableView:nil heightForRowAtIndexPath:nil]);
        CGFloat m_height = 20.0;
        self.subTitleLabel = NewLabel(CGRectMake(screen_width - kEdgeMiddle - 120, self.titleLabel.bottom, 120, m_height), [UIColor grayColor], [AppPublic appFontOfSize:appLabelFontSizeLittle], NSTextAlignmentRight);
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

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeightBig;
}

#pragma mark - setter
- (void)setMusic:(AppMusicInfo *)music {
    _music = music;
    
    [self.showImageView sd_setImageWithURL:fileURLWithPID(music.Image)];
    self.titleLabel.text = music.Name;
    self.playBtn.showLabel.text = [NSString stringWithFormat:@"%d", music.PlayTimes];
    self.messageBtn.showLabel.text = [NSString stringWithFormat:@"%d", music.Comment];
    self.timeBtn.showLabel.text = stringWithTimeInterval(music.Duration);
}

@end