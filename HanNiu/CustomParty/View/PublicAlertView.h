//
//  PublicAlertView.h
//  HanNiu
//
//  Created by 7kers on 2018/1/22.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicInputView.h"
#import "PublicLabel.h"

@interface PublicAlertView : UIView

typedef void(^ActionAlertBlock)(PublicAlertView *view, NSInteger index);

@property (strong, nonatomic) ActionAlertBlock block;
@property (strong, nonatomic) UIView *baseView;
@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) UIButton *cancelButton;

- (instancetype)initWithContentView:(UIView *)contentView;
- (void)show;
- (void)dismiss;

- (void)cancelButtonAction;
- (void)sureButtonAction;

@end

@interface PublicAlertShowView : PublicAlertView

@property (strong, nonatomic) UILabel *titleLabel;



@end

@interface PublicAlertShowGraphView : PublicAlertShowView

@property (strong, nonatomic) UIImageView *graphView;
@property (strong, nonatomic) PublicInputView *inputView;

@end


@interface PublicAlertShowMusicBuyView : PublicAlertShowView

@property (strong, nonatomic) PublicSubTitleView *nameView;
@property (strong, nonatomic) PublicSubTitleView *priceView;
@property (strong, nonatomic) PublicSubTitleView *balanceView;

@property (strong, nonatomic) AppBasicMusicDetailInfo *data;

@end

@interface PublicAlertMusicListView : PublicAlertView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;


@end
