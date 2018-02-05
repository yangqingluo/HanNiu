//
//  PublicThreeImageButtonCell.m
//  HanNiu
//
//  Created by 7kers on 2018/2/5.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicThreeImageButtonCell.h"

#import "UIButton+WebCache.h"
#import "UIResponder+Router.h"

static CGFloat scale = 3.0 / 4.0;
static NSInteger count = 3;
static NSInteger tag_base_button = 1000;

@implementation PublicThreeImageButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat m_edge = kEdgeSmall;
        CGFloat m_width = (screen_width - 2 * kEdgeMiddle - (count - 1) * m_edge) / count;
        for (NSInteger i = 0; i < count; i++) {
            UIButton *btn = NewButton(CGRectMake(kEdgeMiddle + i * (m_width + m_edge), 0, m_width, m_width * scale), nil, nil, nil);
            btn.tag = tag_base_button + i;
            [btn addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
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

- (void)imageButtonAction:(UIButton *)button {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"tag" : @(button.tag - tag_base_button)}];
    if (self.indexPath) {
        [m_dic setObject:self.indexPath forKey:@"indexPath"];
    }
    [self routerEventWithName:Event_PublicThreeImageButtonCellButtonClicked userInfo:[NSDictionary dictionaryWithDictionary:m_dic]];
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (screen_width - 2 * kEdgeMiddle - (count - 1) * kEdgeSmall) / count * scale;
}

#pragma mark - setter
- (void)setData:(NSArray *)data {
    _data = data;
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = [self.contentView viewWithTag:tag_base_button + i];
        if (i < data.count) {
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:data[i]] forState:UIControlStateNormal];
        }
        else {
            [btn setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
}

@end
