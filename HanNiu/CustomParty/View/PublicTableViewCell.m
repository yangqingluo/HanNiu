//
//  PublicTableViewCell.m
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicTableViewCell.h"

@implementation PublicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat i_radius = self.contentView.height - 2 * kEdgeSmall;
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdgeSmall, i_radius, i_radius)];
        [self.contentView addSubview:_showImageView];
        
        _titleLabel = NewLabel(CGRectMake(_showImageView.right + kEdgeMiddle, 0, self.contentView.width - (_showImageView.right + kEdge), self.contentView.height), nil, nil, NSTextAlignmentLeft);
        [self.contentView addSubview:_titleLabel];
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
    return kCellHeight;
}

@end
