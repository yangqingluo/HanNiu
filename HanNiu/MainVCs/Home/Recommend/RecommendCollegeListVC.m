//
//  RecommendCollegeListVC.m
//  HanNiu
//
//  Created by 7kers on 2018/2/5.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "RecommendCollegeListVC.h"
#import "UIImageView+WebCache.h"

@implementation RecommendCollegeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, [[self class]  tableView:nil heightForRowAtIndexPath:nil] - kCellHeightBig)];
        [self.contentView addSubview:self.bigImageView];
        
        CGFloat i_radius = kCellHeightBig - 2 * kEdgeSmall;
        self.showImageView.frame = CGRectMake(kEdgeMiddle, self.bigImageView.bottom + kEdgeSmall, i_radius, i_radius);
        self.titleLabel.frame = CGRectMake(self.showImageView.right + kEdgeBig, self.showImageView.top, screen_width - kEdgeMiddle - (self.showImageView.right + kEdgeBig), 20);
        self.subTagLabel.frame = CGRectMake(self.titleLabel.left, self.titleLabel.bottom + kEdgeSmall, self.titleLabel.width, 16);
        
        self.gridLabelView = [[PublicGridLabelView alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.subTagLabel.bottom + kEdge, self.subTagLabel.width, appLabelFontSizeTiny + kEdgeSmall)];
        [self.contentView addSubview:self.gridLabelView];
        
        [AppPublic roundCornerRadius:self.showImageView cornerRadius:appViewCornerRadius];
        self.showImageView.layer.borderColor = appSeparatorColor.CGColor;
        self.showImageView.layer.borderWidth = appSeparaterLineSize;
    }
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return screen_width * appImageScale + kCellHeightBig;
}

@end


@interface RecommendCollegeListVC ()

@end

@implementation RecommendCollegeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐学校";
    
    self.tableView.height = screen_height - TAB_BAR_HEIGHT - self.navigationBarView.bottom;
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type" : @"1"}];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"Featured/List" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            if (isReset) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:[AppBasicMusicDetailInfo mj_objectArrayWithKeyValuesArray:responseBody[@"Data"]]];
        }
        [weakself updateSubviews];
    }];
}

#pragma mark - UITableView
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataSource.count;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RecommendCollegeListCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"show_cell";
    RecommendCollegeListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[RecommendCollegeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    AppBasicMusicDetailInfo *item = self.dataSource[indexPath.row];
    [cell.showImageView sd_setImageWithURL:fileURLWithPID(item.Image) placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    NSArray *m_array = item.picsAddressListForPics;
    if (m_array.count) {
        [cell.bigImageView sd_setImageWithURL:m_array[0] placeholderImage:[UIImage imageNamed:defaultDownloadPlaceImageName]];
    }
    else {
        cell.bigImageView.image = [UIImage imageNamed:defaultDownloadPlaceImageName];
    }
    
    cell.titleLabel.text = item.Name;
    [cell.gridLabelView resetGridWithStringArray:[item.Tags componentsSeparatedByString:@"|"]];
    cell.subTagLabel.text = item.showStringForAddr;
    [AppPublic adjustLabelWidth:cell.titleLabel];
    [AppPublic adjustLabelWidth:cell.subTagLabel];
    
    return cell;
}

@end
