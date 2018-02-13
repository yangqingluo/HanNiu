//
//  QuantityCell.m
//  HanNiu
//
//  Created by 7kers on 2018/1/24.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "QualityCell.h"
#import "UIImageView+WebCache.h"

@implementation QualityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
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

#pragma mark - setter
- (void)setData:(AppBasicMusicDetailInfo *)data {
    _data = data;
    
    [self.showImageView sd_setImageWithURL:fileURLWithPID(data.Image)];
    self.titleLabel.text = data.Name;
    self.subTitleLabel.text = stringFromDate([NSDate dateWithTimeIntervalSince1970:0.001 * [data.UpdateTime integerValue]], @"yyyy.MM.dd");
    self.playBtn.showLabel.text = [NSString stringWithFormat:@"%d", data.Music.PlayTimes];
    self.messageBtn.showLabel.text = [NSString stringWithFormat:@"%d", data.Music.Comment];
    self.timeBtn.showLabel.text = stringWithTimeInterval(data.Music.Duration);
}

@end
