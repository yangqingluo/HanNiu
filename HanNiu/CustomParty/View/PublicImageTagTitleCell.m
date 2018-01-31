//
//  PublicImageTagTitleCell.m
//  HanNiu
//
//  Created by 7kers on 2018/1/31.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicImageTagTitleCell.h"

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
