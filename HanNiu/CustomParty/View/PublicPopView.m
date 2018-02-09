//
//  PopRootViewController.m
//  SchoolIM
//
//  Created by yangqingluo on 16/5/29.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import "PublicPopView.h"
#import "UIResponder+Router.h"

@interface PublicPopView ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSArray *showArray;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation PublicPopView

- (instancetype)init{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(screen_width  - 120, STATUS_BAR_HEIGHT, 120, 0) style:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = appMainColor;
        self.tableView.scrollEnabled = NO;
        [self addSubview:self.tableView];
        
        //初始化背景视图，添加手势
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tappedCancel{
    [self showMenu:NO];
}

- (void)showMenu:(BOOL)show{
    if (show) {
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.height = self.tableView.contentSize.height;
            self.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];
    }
    else{
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.height = 0;
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
            }
        }];
    }
}

#pragma getter
- (NSArray *)showArray{
    if (!_showArray) {
        _showArray = @[@{@"title":@"搜学校",@"subTitle":@"",@"headImage":@""},
                       @{@"title":@"搜学院",@"subTitle":@"",@"headImage":@""},
                       @{@"title":@"搜专业",@"subTitle":@"",@"headImage":@""}];
    }
    return _showArray;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
    
}

#pragma tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"show_cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:NewSeparatorLine(CGRectMake(0, 0, screen_width, appSeparaterLineSize))];
    }    
    NSDictionary *m_dic = self.showArray[indexPath.row];
    cell.textLabel.text = m_dic[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showMenu:NO];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"indexPath" : indexPath}];
    [[NSNotificationCenter defaultCenter] postNotificationName:Event_PublicPopViewCellSelected object:m_dic userInfo:nil];
}



@end
