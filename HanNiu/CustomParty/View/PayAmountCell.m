//

//  PayAmountCell.m
//  HanNiu
//
//  Created by 7kers on 2018/2/15.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PayAmountCell.h"

#define PublicSelectLineCount     3
#define PublicSelectRowCount      2
#define PublicSelectLineEdge      16.0
#define PublicSelectRowEdge       16.0


@implementation PublicSelectButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [AppPublic roundCornerRadius:self cornerRadius:appViewCornerRadius];
        self.layer.borderColor = appSeparatorColor.CGColor;
        self.layer.borderWidth = appSeparaterLineSize;
        self.showLabel.frame = CGRectMake(0, 0, self.width, 0.6 * self.height);
        self.showLabel.textAlignment = NSTextAlignmentCenter;
        self.showLabel.font = [AppPublic appFontOfSize:appLabelFontSizeLittle];
        self.showLabel.textColor = appTextColor;
        
        self.subTitleLabel = NewLabel(self.showLabel.frame, appMainColor, [AppPublic appFontOfSize:appLabelFontSizeTiny], self.showLabel.textAlignment);
        self.subTitleLabel.top = 0.5 * self.height;
        self.subTitleLabel.height = 0.3 * self.height;
        [self addSubview:self.subTitleLabel];
        
        self.showImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bought_unit_selected"]];
        self.showImageView.frame = self.bounds;
//        self.showImageView.right = self.width;
//        self.showImageView.top = 0;
        [self addSubview:self.showImageView];
    }
    return self;
}


@end

@implementation PayAmountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat m_width = (screen_width - (PublicSelectLineCount + 1) * PublicSelectLineEdge) / PublicSelectLineCount;
        CGFloat m_height = m_width / 2.0;
        for (NSInteger i = 0; i < (PublicSelectLineCount * PublicSelectRowCount); i++) {
            NSInteger lineIndex = i % PublicSelectLineCount;
            NSInteger rowIndex = i / PublicSelectLineCount;
            PublicSelectButton *btn = [[PublicSelectButton alloc] initWithFrame:CGRectMake(PublicSelectLineEdge + (m_width + PublicSelectLineEdge) * lineIndex, kEdgeMiddle + (m_height + PublicSelectRowEdge) * rowIndex, m_width, m_height)];
            btn.tag = i;
            [self addSubview:btn];
            [self.buttonArray addObject:btn];
        }
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
    CGFloat m_width = (screen_width - (PublicSelectLineCount + 1) * PublicSelectLineEdge) / PublicSelectLineCount;
    CGFloat m_height = m_width / 2.0;
    return (m_height + PublicSelectRowEdge) * PublicSelectRowCount + kEdgeMiddle;
}

#pragma mark - getter
- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray new];
    }
    return _buttonArray;
}

@end
