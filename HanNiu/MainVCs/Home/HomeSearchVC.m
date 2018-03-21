//
//  HomeSearchVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/22.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "HomeSearchVC.h"
#import "CollegeDetailVC.h"
#import "SchoolDetailVC.h"
#import "MusicDetailVC.h"

#import "PublicPopView.h"
#import "PublicImageSubTagTitleCell.h"
#import "QualityCell.h"

#import "UIImageView+WebCache.h"

@interface HomeSearchVC ()<UITextFieldDelegate> {
    NSInteger selectedIndex;
}

@property (strong, nonatomic) UITextField *textField;

@end

@implementation HomeSearchVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popViewCellSelectedNotification:) name:Event_PublicPopViewCellSelected object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textField becomeFirstResponder];
    
}

- (void)initializeNavigationBar {
    [self createNavWithTitle:self.title createMenuItem:^UIView *(int nIndex) {
        if (nIndex == 0) {
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1) {
            UIButton *btn = NewRightButton([UIImage imageNamed:@"search"], nil);
            [btn addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 2) {
            UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(STATUS_BAR_HEIGHT, 7, screen_width - 2 * STATUS_BAR_HEIGHT, 30)];
            searchTextField.background = [UIImage imageNamed:@"bg_search"];
            searchTextField.placeholder = @"搜索您感兴趣的内容";
            searchTextField.font = [AppPublic appFontOfSize:appLabelFontSizeSmall];
            searchTextField.borderStyle = UITextBorderStyleNone;
            searchTextField.returnKeyType = UIReturnKeySearch;
            searchTextField.layer.cornerRadius = 0.5 * searchTextField.bounds.size.height;
            searchTextField.delegate = self;
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5 * searchTextField.height, searchTextField.height)];
            searchTextField.leftView = leftView;
            searchTextField.leftViewMode = UITextFieldViewModeAlways;
            _textField = searchTextField;
            return searchTextField;
        }
        return nil;
    }];
}

- (void)pullBaseListData:(BOOL)isReset {
    if (!self.textField.text.length) {
        return;
    }
    NSString *urlFooter = @"";
    Class m_class = AppBasicMusicDetailInfo.class;
    switch (selectedIndex) {
        case 0:{
            urlFooter = @"University/List";
        }
            break;
            
        case 1:{
            urlFooter = @"University/School/List";
        }
            break;
            
        case 2:{
            urlFooter = @"University/Major/List";
        }
            break;
            
        default:
            break;
    }
    
    if (!urlFooter.length) {
        return;
    }
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"keyWord" : self.textField.text}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:urlFooter completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:[m_class mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
        }
        [weakself updateSubviews];
    }];
}

- (void)searchButtonAction {
    [self dismissKeyboard];
    if (self.textField.text.length) {
        PublicPopView *pop = [PublicPopView new];
        [pop showMenu:YES];
    }
    else {
        [self doShowHintFunction:@"请输入搜索内容"];
    }
}

- (void)doSearchFunction:(NSInteger)row {
    selectedIndex = row;
    [self pullBaseListData:YES];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedIndex == 1) {
        return [QualityCell tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return [PublicImageSubTagTitleCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    if (selectedIndex == 1 || selectedIndex == 2) {
        QualityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[QualityCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.data = self.dataSource[indexPath.row];
        return cell;
    }
    PublicImageSubTagTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PublicImageSubTagTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.subTitleLabel.width = [AppPublic textSizeWithString:@"播放：9999999999次" font:cell.subTitleLabel.font constantHeight:cell.subTitleLabel.height].width;
        cell.tagLabel.frame = CGRectMake(0.5 * screen_width, cell.subTitleLabel.top, screen_width - 0.5 * screen_width, cell.subTitleLabel.height);
        cell.tagLabel.font = [AppPublic appFontOfSize:appLabelFontSizeTiny];
    }
    AppBasicMusicDetailInfo *item = self.dataSource[indexPath.row];
    [cell.showImageView sd_setImageWithURL:fileURLWithPID(item.Image) placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    cell.titleLabel.text = item.Name;
    cell.subTitleLabel.text = [NSString stringWithFormat:@"播放：%d次", item.Music.PlayTimes];
    cell.tagLabel.text = [NSString stringWithFormat:@"分类：%@", item.showStringForTags];
    cell.subTagLabel.text = item.showStringForAddr;
    [AppPublic adjustLabelWidth:cell.titleLabel];
    [AppPublic adjustLabelWidth:cell.subTagLabel];
    cell.subTagLabel.left = cell.titleLabel.right + kEdgeHuge;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (selectedIndex == 0) {
//        CollegeDetailVC *vc = [CollegeDetailVC new];
//        vc.data = [self.dataSource[indexPath.row] copy];
//        [self doPushViewController:vc animated:YES];
    }
    else if (selectedIndex == 1) {
        SchoolDetailVC *vc = [SchoolDetailVC new];
        vc.data = [self.dataSource[indexPath.row] copy];
        [self doPushViewController:vc animated:YES];
    }
    else if (selectedIndex == 2) {
        [[AppPublic getInstance] goToMusicVC:self.dataSource[indexPath.row] list:nil type:PublicMusicDetailFromBetter];
    }
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self searchButtonAction];
    return YES;
}

#pragma mark - notification
- (void)popViewCellSelectedNotification:(NSNotification *)notification {
    NSDictionary *m_dic = notification.object;
    NSIndexPath *indexPath = m_dic[@"indexPath"];
    [self doSearchFunction:indexPath.row];
}

@end
