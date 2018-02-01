//
//  PublicImageSubTitleCell.m
//  HanNiu
//
//  Created by 7kers on 2018/1/31.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicImageSubTitleCell.h"

@implementation PublicImageSubTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat cellHeight = [[self class] tableView:nil heightForRowAtIndexPath:nil];
        CGFloat radius = cellHeight - 2 * kEdge;
        self.showImageView.frame = CGRectMake(kEdgeMiddle, kEdge, radius, radius);
        [AppPublic roundCornerRadius:self.showImageView];
        
        self.titleLabel.frame = CGRectMake(self.showImageView.right + kEdgeMiddle, self.showImageView.top, screen_width - (self.showImageView.right + kEdgeMiddle), 0.5 * self.showImageView.height);
        
        self.subTitleLabel = NewLabel(CGRectMake(self.titleLabel.left, self.titleLabel.bottom, self.titleLabel.width, 20), [UIColor grayColor], [AppPublic appFontOfSize:appLabelFontSizeLittle], NSTextAlignmentLeft);
        self.subTitleLabel.numberOfLines = 0;
        self.subTitleLabel.top = self.titleLabel.bottom;
        [self.contentView addSubview:self.subTitleLabel];
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

@end
