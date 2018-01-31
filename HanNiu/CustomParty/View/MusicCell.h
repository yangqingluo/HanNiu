//
//  MusicCell.h
//  HanNiu
//
//  Created by 7kers on 2018/1/25.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicImageSubTitleCell.h"
#import "PublicButton.h"

@interface MusicCell : PublicImageSubTitleCell

@property (strong, nonatomic) PublicButton *playBtn;
@property (strong, nonatomic) PublicButton *messageBtn;
@property (strong, nonatomic) PublicButton *timeBtn;

@property (strong, nonatomic) AppMusicInfo *music;

@end
