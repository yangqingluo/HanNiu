//
//  CommentCellFooterView.m
//  HanNiu
//
//  Created by 7kers on 2018/2/9.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "CommentCellFooterView.h"

#import "UIImageView+WebCache.h"

#import "NSAttributedString+JTATEmoji.h"

@implementation CommentCellFooterView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(kEdgeMiddle, 0, screen_width - 2 * kEdgeMiddle, [[self class] footerHeight])];
    if (self) {
        [AppPublic roundCornerRadius:self cornerRadius:appViewCornerRadius];
        self.layer.borderColor = appSeparatorColor.CGColor;
        self.layer.borderWidth = appSeparaterLineSize;
        self.backgroundColor = appLightWhiteColor;
        
        CGFloat i_radius = self.height - 2 * kEdge;
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdge, i_radius, i_radius)];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_showImageView];
        
        _titleLabel = NewLabel(CGRectMake(self.showImageView.right + kEdgeMiddle, self.showImageView.top, screen_width - (self.showImageView.right + kEdgeMiddle), 0.5 * self.showImageView.height), nil, nil, NSTextAlignmentLeft);
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        
        self.subTitleLabel = NewLabel(CGRectMake(self.titleLabel.left, self.titleLabel.bottom, self.titleLabel.width, 20), [UIColor grayColor], [AppPublic appFontOfSize:appLabelFontSizeLittle], NSTextAlignmentLeft);
//        self.subTitleLabel.numberOfLines = 0;
        [self addSubview:self.subTitleLabel];
    }
    return self;
}

+ (CGFloat)footerHeight {
    return kCellHeightMiddle;
}

@end


@implementation CommentToMeCellFooterView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleLabel.left = kEdgeMiddle;
        self.subTitleLabel.left = kEdgeMiddle;
        
        self.tagLabel = NewLabel(CGRectMake(0, self.subTitleLabel.top, appTimeLabelWidth + kEdgeBig, self.subTitleLabel.height), [UIColor lightGrayColor], [AppPublic appFontOfSize:appLabelFontSizeTiny], NSTextAlignmentRight);
        self.tagLabel.right = self.width - kEdgeMiddle;
        [self addSubview:self.tagLabel];
        
        self.subTitleLabel.width = self.tagLabel.left - kEdgeSmall - self.subTitleLabel.left;
    }
    return self;
}

@end

@implementation CommentFromMeCellFooterView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.showImageView.width = self.showImageView.height / appImageScale;
        self.titleLabel.frame = CGRectMake(self.showImageView.right + kEdgeMiddle, self.showImageView.top, screen_width - (self.showImageView.right + kEdgeMiddle), 0.5 * self.showImageView.height);
        self.subTitleLabel.frame = CGRectMake(self.titleLabel.left, self.titleLabel.bottom, self.titleLabel.width, 20);
    }
    return self;
}

- (void)clear {
    self.showImageView.image = [UIImage imageNamed:defaultDownloadPlaceImageName];
    self.titleLabel.text = @"";
    self.subTitleLabel.attributedText = [NSAttributedString emojiAttributedString:[NSString stringWithFormat:@"[play] %@   \t\t[message] %@\t\t[duration] %@", @"0", @"0", @"00:00"] withFont:self.subTitleLabel.font];
}

- (void)updateSubViews:(AppMusicDetailInfo *)music {
    self.subTitleLabel.attributedText = [NSAttributedString emojiAttributedString:[NSString stringWithFormat:@"[play] %d   \t\t[message] %d\t\t[duration] %@", music.PlayTimes, music.Comment, stringWithTimeInterval(music.Duration)] withFont:self.subTitleLabel.font];
    AppItemInfo *item = nil;
    if (music.Qualities.count) {
        item = music.Qualities[0];
    }
    else if (music.Universitys.count) {
        item = music.Universitys[0];
    }
    else if (music.Schools.count) {
        item = music.Schools[0];
    }
    else if (music.Majors.count) {
        item = music.Majors[0];
    }
    
    if (item) {
        self.titleLabel.text = item.Name;
        [self.showImageView sd_setImageWithURL:fileURLWithPID(item.Image) placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    }
}

- (void)setMusicId:(NSString *)musicId {
    _musicId = musicId;
    
    [self clear];
    AppMusicDetailInfo *music = [UserPublic getInstance].msgFromMusicMapDic[musicId];
    if (music) {
        [self updateSubViews:music];
    }
    else {
        NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"id" : musicId}];
        QKWEAKSELF;
        [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Music/Detail" completion:^(id responseBody, NSError *error){
            if (!error) {
                AppMusicDetailInfo *m_music = [AppMusicDetailInfo mj_objectWithKeyValues:responseBody[@"Data"]];
                [[UserPublic getInstance].msgFromMusicMapDic setObject:m_music forKey:musicId];
                [weakself updateSubViews:m_music];
            }
        }];
    }
    
}

@end
