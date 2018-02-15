//
//  AccountDetailVC.m
//  HanNiu
//
//  Created by 7kers on 2018/1/22.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "AccountDetailVC.h"
#import "AccountEditPropertyVC.h"

#import "PublicTableViewCell.h"
#import "UIButton+WebCache.h"
#import "BlockActionSheet.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface AccountDetailVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIButton *headerBtn;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) AppUserInfo *userData;

@end

@implementation AccountDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    self.tableView.tableHeaderView = self.headerView;
    [self initializeData];
    [self updateSubviews];
//    [self pullBaseListData:YES];
}

- (void)pullBaseListData:(BOOL)isReset {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:@{@"username" : [UserPublic getInstance].userData.Extra.userinfo.Name}];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Get:m_dic HeadParm:nil URLFooter:@"UserInfo" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [weakself updateSubviews];
        }
    }];
}

- (void)doPushImageFunction:(NSData *)data{
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] PushImages:@[data] completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            NSString *pID = responseBody[@"Data"];
            [[SDImageCache sharedImageCache] storeImageDataToDisk:data forKey:fileURLStringWithPID(pID)];
            [weakself doUpdateUserImageFunction:pID];
        }
    } withUpLoadProgress:^(float progress){
        
    }];
}

- (void)doUpdateUserImageFunction:(NSString *)pID {
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:self.userData.mj_keyValues];
    [m_dic setObject:pID forKey:@"Image"];
    [self doShowHudFunction];
    QKWEAKSELF;
    [[AppNetwork getInstance] Post:m_dic HeadParm:nil URLFooter:@"UserInfo?v=1" completion:^(id responseBody, NSError *error){
        [weakself doHideHudFunction];
        if (error) {
            [weakself doShowHintFunction:error.userInfo[appHttpMessage]];
        }
        else {
            [UserPublic getInstance].userData.Extra.userinfo = [AppUserInfo mj_objectWithKeyValues:responseBody[@"Data"]];
            [[UserPublic getInstance] saveUserData:nil];
            weakself.userData = nil;
            [weakself updateSubviews];
        }
    }];
}

//初始化数据
- (void)initializeData {
    self.showArray = @[@{@"title":@"昵称",@"subTitle":@"请输入",@"key":@"NickName"}];
}

- (void)updateSubviews {
    [self.headerBtn sd_setImageWithURL:fileURLWithPID(self.userData.Image) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:defaultHeadPlaceImageName]];
    [self.tableView reloadData];
}

- (void)headerButtonAction {
    QKWEAKSELF;
    BlockActionSheet *sheet = [[BlockActionSheet alloc] initWithTitle:@"设置头像" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil clickButton:^(NSInteger buttonIndex){
        if (buttonIndex == 2) {
            [weakself requestAccessForMedia:buttonIndex];
        }
        else if (buttonIndex == 1) {
            [weakself chooseHeadImage:buttonIndex];
        }
    } otherButtonTitles:@"从相册选取", @"拍照", nil];
    [sheet showInView:self.view];
}

- (void)requestAccessForMedia:(NSUInteger)buttonIndex{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                [self chooseHeadImage:buttonIndex];
            }
            else{
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus != AVAuthorizationStatusAuthorized){
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-相机\"选项中，允许%@访问您的相机",[AppPublic getInstance].appName] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    return;
                }
            }
            
        });
    }];
}

- (void)chooseHeadImage:(NSUInteger)buttonIndex{
    UIImagePickerControllerSourceType type = (buttonIndex == 2) ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:type]){
        self.imagePicker.sourceType = type;
        [self presentViewController:self.imagePicker animated:YES completion:^{
            
        }];
    }
    else{
        NSString *name = (buttonIndex == 2) ? @"相机" : @"照片";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@不可用", name] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - getter
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kCellHeightHuge)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        CGFloat radius = 0.8 * _headerView.height;
        _headerBtn = NewButton(CGRectMake(0, 0, radius, radius), nil, nil, nil);
        _headerBtn.center = CGPointMake(0.5 * _headerView.width, 0.5 * _headerView.height);
        [_headerBtn setBackgroundImage:[UIImage imageNamed:defaultHeadPlaceImageName] forState:UIControlStateNormal];
        [_headerBtn addTarget:self action:@selector(headerButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_headerBtn];
        [AppPublic roundCornerRadius:_headerBtn];
    }
    return _headerView;
}

- (AppUserInfo *)userData {
    if (!_userData) {
        _userData = [[UserPublic getInstance].userData.Extra.userinfo copy];
    }
    return _userData;
}

- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
        _imagePicker.allowsEditing = YES;
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeightMiddle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"select_cell";
    PublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PublicTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [AppPublic appFontOfSize:appLabelFontSize];
        cell.detailTextLabel.textColor = appTextColor;
        cell.detailTextLabel.font = cell.textLabel.font;
    }
    NSDictionary *dic = self.showArray[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.detailTextLabel.text = [[UserPublic getInstance].userData.Extra.userinfo valueForKey:dic[@"key"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        QKWEAKSELF;
        AccountEditPropertyVC *vc = [AccountEditPropertyVC new];
        vc.userData = self.userData;
        vc.doneBlock = ^(id object){
            [weakself updateSubviews];
        };
        [self doPushViewController:vc animated:YES];
    }
}
#pragma mark UIImagePickerControllerDelegate协议的方法
//用户点击图像选取器中的“cancel”按钮时被调用，这说明用户想要中止选取图像的操作
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//用户点击选取器中的“choose”按钮时被调用，告知委托对象，选取操作已经完成，同时将返回选取图片的实例
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // 图片类型
    if([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        //编辑后的图片
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        //压缩图片
        NSData *imageData = dataOfImageCompression(image, YES);
        
        //如果想之后立刻调用UIVideoEditor,animated不能是YES。最好的还是dismiss结束后再调用editor。
        [picker dismissViewControllerAnimated:YES completion:^{
            [self doPushImageFunction:imageData];
        }];
    }
}

@end
