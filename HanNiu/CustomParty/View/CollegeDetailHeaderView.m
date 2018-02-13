//
//  CollegeDetailHeaderView.m
//  HanNiu
//
//  Created by 7kers on 2018/2/1.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "CollegeDetailHeaderView.h"

#import "UIImageView+WebCache.h"

@implementation CollegeDetailHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.subTitleLabel.top = self.titleLabel.bottom + 0.1 * self.showImageView.height;
        self.subTitleLabel.height = 0.2 * self.showImageView.height;
        self.tagLabel.top = self.subTitleLabel.bottom;
        self.tagLabel.height = self.subTitleLabel.height;
        
        self.gridLabelView = [[PublicGridLabelView alloc] initWithFrame:CGRectMake(self.tagLabel.left, self.tagLabel.bottom + kEdge, self.tagLabel.width, appLabelFontSizeTiny + kEdgeSmall)];
        [self addSubview:self.gridLabelView];
    }
    return self;
}

#pragma mark - setter
- (void)setData:(AppCollegeInfo *)data {
    _data = data;
    [self.showImageView sd_setImageWithURL:fileURLWithPID(data.Image) placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    self.titleLabel.text = data.Name;
    self.subTitleLabel.text = data.showStringForAddr;
    [self.gridLabelView resetGridWithStringArray:[data.Tags componentsSeparatedByString:@"|"]];
    
    NSDictionary *dic1 = @{NSForegroundColorAttributeName : self.tagLabel.textColor};
    NSDictionary *dic2 = @{NSForegroundColorAttributeName : appMainColor};
    NSMutableAttributedString *m_string = [NSMutableAttributedString new];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:@"播放：" attributes:dic1]];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", data.Music.PlayTimes] attributes:dic2]];
    [m_string appendAttributedString:[[NSAttributedString alloc] initWithString:@"次" attributes:dic1]];
    self.tagLabel.attributedText = m_string;
}

@end
