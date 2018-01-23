//
//  PublicViewController.m
//  HanNiu
//
//  Created by 7kers on 2018/1/16.
//  Copyright © 2018年 zdz. All rights reserved.
//

#import "PublicViewController.h"

@interface PublicViewController (){
    float _nSpaceNavY;
    NSUInteger hudCount;
}

@property (nonatomic, strong) UIView *navView;

@end

@implementation PublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = appLightWhiteColor;
    [self initializeNavigationBar];
    [self initializeData];
}

- (void)setupNavigationViews{
    _nSpaceNavY = 0;
    CGFloat StatusbarSize = 20.0;
    
    _navigationBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _nSpaceNavY, self.view.width, 64 - _nSpaceNavY)];
    [self.view addSubview:_navigationBarView];
    _navigationBarView.image = [UIImage imageNamed:@"navigation_bar_back"];
    [_navigationBarView setBackgroundColor:[UIColor clearColor]];
    
    _navView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, StatusbarSize, self.view.width, 44.f)];
    ((UIImageView *)_navView).backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navView];
    _navView.userInteractionEnabled = YES;
    
    self.shadowLine = [[UIView alloc]initWithFrame:CGRectMake(0, _navView.bounds.size.height - 0.5, _navView.bounds.size.width, 0.5)];
    self.shadowLine.backgroundColor = appSeparatorColor;
    self.shadowLine.hidden = YES;
    [_navView addSubview:self.shadowLine];
    
    self.titleLabel.frame = CGRectMake(60, 0, _navView.width - 120, _navView.height);
    [_navView addSubview:self.titleLabel];
}

#pragma mark - setter
- (void)setTitle:(NSString *)title{
    [super setTitle:title];
    self.titleLabel.text = title;
}

#pragma mark - getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
    }
    return _titleLabel;
}

- (NSString *)dateKey{
    if (!_dateKey) {
        _dateKey = [NSString stringWithFormat:@"%@_dateKey_%d", [self class], (int)self.indextag];
    }
    return _dateKey;
}

#pragma mark - public
- (void)createNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem{
    [self setupNavigationViews];
    self.title = szTitle;
    NSUInteger itemCount = 4;
    for (int i = 0; i < itemCount; i++) {
        UIView *item = menuItem(i);
        if (item){
            [_navView addSubview:item];
        }
    }
}

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

- (void)doShowHintFunction:(NSString *)hint {
    if (self.parentVC) {
        [self.parentVC showHint:hint];
    }
    else {
        [self showHint:hint];
    }
}

- (void)doShowHudFunction {
    [self doShowHudFunction:nil];
}

- (void)doShowHudFunction:(NSString *)hint {
    if (hudCount == 0) {
        if (self.parentVC) {
            [self.parentVC showHudInView:self.parentVC.view hint:hint];
        }
        else {
            [self showHudInView:self.view hint:hint];
        }
    }
    hudCount++;
}

- (void)doHideHudFunction {
    if (hudCount > 0) {
        hudCount--;
    }
    if (hudCount == 0) {
        if (self.parentVC) {
            [self.parentVC hideHud];
        }
        else {
            [self hideHud];
        }
    }
}

- (void)doPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.parentVC) {
        [self.parentVC.navigationController pushViewController:viewController animated:animated];
    }
    else {
        [self.navigationController pushViewController:viewController animated:animated];
    }
}
- (void)showFromVC:(PublicViewController *)fromVC {
    [fromVC doPushViewController:self animated:YES];
}
- (UIViewController *)doPopViewControllerAnimated:(BOOL)animated {
    if (self.parentVC) {
        return [self.parentVC.navigationController popViewControllerAnimated:animated];
    }
    else {
        return [self.navigationController popViewControllerAnimated:animated];
    }
}
- (NSArray<__kindof UIViewController *> *)doPopToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.parentVC) {
        return [self.parentVC.navigationController popToViewController:viewController animated:animated];
    }
    else {
        return [self.navigationController popToViewController:viewController animated:animated];
    }
}
- (NSArray<__kindof UIViewController *> *)doPopToLastViewControllerSkip:(NSUInteger)skip animated:(BOOL)animated {
    return [self doPopToLastViewControllerSkip:skip animated:animated fromViewController:self.parentVC ? self.parentVC : self];
}

- (NSArray<__kindof UIViewController *> *)doPopToLastViewControllerSkip:(NSUInteger)skip animated:(BOOL)animated fromViewController:(UIViewController *)viewController {
    NSArray *m_array = viewController.navigationController.viewControllers;
    NSUInteger count = m_array.count;
    if (skip > 0 && skip <= count - 1) {
        UIViewController *VC = m_array[count - 1 - skip];
        return [viewController.navigationController popToViewController:VC animated:animated];
    }
    else {
        return nil;
    }
}

- (void)initializeNavigationBar {
    [self createNavWithTitle:self.title createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        return nil;
    }];
}

- (void)initializeData {
    
}

- (void)cancelButtonAction {
    [self goBackWithDone:NO];
}
- (void)goBackWithDone:(BOOL)done {
    if (done) {
        [self doDoneAction];
    }
    [self.navigationController popViewControllerAnimated:YES];
    //    QKWEAKSELF;
    //    [self.navigationController dismissViewControllerAnimated:NO completion:^{
    //        if (done) {
    //            [weakself doDoneAction];
    //        }
    //    }];
}

- (void)doDoneAction {
    if (self.doneBlock) {
        self.doneBlock(nil);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self dismissKeyboard];
}

#pragma mark - TextFieldDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    if ([textField isKindOfClass:[IndexPathTextField class]]) {
//        IndexPathTextField *m_textFiled = (IndexPathTextField *)textField;
//        if (m_textFiled.adjustZeroShow) {
//            if ([textField.text intValue] == 0) {
//                textField.text = @"";
//            }
//        }
//    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if ([textField isKindOfClass:[IndexPathTextField class]]) {
//        IndexPathTextField *m_textFiled = (IndexPathTextField *)textField;
//        NSIndexPath *indexPath = m_textFiled.indexPath;
//        [self editAtIndexPath:indexPath tag:textField.tag andContent:textField.text];
//        if (m_textFiled.adjustZeroShow) {
//            if (textField.text.length == 0) {
//                textField.text = @"0";
//            }
//        }
//    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return (range.location < kInputLengthMax);
}

- (void)textFieldDidChange:(UITextField *)textField {
    //    if (textField.text.length > kInputLengthMax) {
    //        textField.text = [textField.text substringToIndex:kInputLengthMax];
    //    }
//    if ([textField isKindOfClass:[IndexPathTextField class]]) {
//        NSIndexPath *indexPath = [(IndexPathTextField *)textField indexPath];
//        [self editAtIndexPath:indexPath tag:textField.tag andContent:textField.text];
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - notification
- (void)needRefreshNotification:(NSNotification *)notification {
    self.needRefresh = YES;
}

@end
