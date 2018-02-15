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
        CGFloat i_radius = [[self class] tableView:nil heightForRowAtIndexPath:nil] - 2 * kEdgeSmall;
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdgeSmall, i_radius, i_radius)];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_showImageView];
        
        _titleLabel = NewLabel(CGRectMake(_showImageView.right + kEdgeMiddle, 0, screen_width - (_showImageView.right + kEdgeMiddle), self.contentView.height), nil, nil, NSTextAlignmentLeft);
        _titleLabel.numberOfLines = 0;
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
    return kCellHeightMiddle;
}

@end


@implementation PayStyleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeBig, kEdge, screen_width - 2 * kEdgeBig, [[self class] tableView:nil heightForRowAtIndexPath:nil] - 2 * kEdge)];
        [AppPublic roundCornerRadius:baseView cornerRadius:appViewCornerRadius];
        baseView.layer.borderColor = appSeparatorColor.CGColor;
        baseView.layer.borderWidth = appSeparaterLineSize;
        [self.contentView addSubview:baseView];
        
        self.showImageView.frame = CGRectMake(kEdgeMiddle, 0, 24, 24);
        self.showImageView.centerY = 0.5 * baseView.height;
        [baseView addSubview:self.showImageView];
        
        self.tagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_circle_unselected"]];
        self.tagImageView.highlightedImage = [UIImage imageNamed:@"icon_circle_selected"];
        self.tagImageView.right = baseView.width - kEdgeMiddle;
        self.tagImageView.centerY = self.showImageView.centerY;
        [baseView addSubview:self.tagImageView];
        
        self.titleLabel.frame = CGRectMake(self.showImageView.right + kEdgeMiddle, 0, self.tagImageView.left - self.showImageView.right - kEdgeMiddle, baseView.height);
        [baseView addSubview:self.titleLabel];
    }
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeightMiddle;
}

@end
