//
//  XOBaseViewController.m
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import "XOBaseViewController.h"
#import "XOMacro.h"
#import "NSBundle+XOBaseLib.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface XOBaseViewController () <UINavigationControllerDelegate>

@end

@implementation XOBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged:) name:JTLanguageDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontSizeChanged:) name:JTFontSizeDidChangeNotification object:nil];
    }
    return self;
}

// 如果是从xib初始化的, 也要监听通知, 因为从xib初始化不会重载init方法
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged:) name:JTLanguageDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontSizeChanged:) name:JTFontSizeDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ %s", NSStringFromClass([self class]), __func__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 隐藏悬浮的弹窗
    if ([self.presentedViewController isKindOfClass:[UIAlertController class]]) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    [self.view endEditing:YES];
    [SVProgressHUD dismiss];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.view endEditing:YES];
    [SVProgressHUD dismiss];
}

- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    
    _safeInset = self.view.safeAreaInsets;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UINavigationController *)navigationController
{
    if (super.navigationController) {
        return super.navigationController;
    }
    return self.tabBarController.navigationController;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *root = navigationController.viewControllers[0];
    
    if (root != viewController) {
        UIBarButtonItem *itemleft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popAction:)];
        viewController.navigationItem.leftBarButtonItem = itemleft;
    }
}

- (void)popAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ========================= public =========================

/** 设置菜单栏的角标
 *  badgeNum: 角标数  index: 要设置的BBI的位置
 */
- (void)setBadgeNum:(NSUInteger)badgeNum atIndex:(NSUInteger)index
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        JTTabbarController *mainVC = (JTTabbarController *)self.tabBarController;
//        if (mainVC) {
//            UITabBarItem *tabbarItem;
//            switch (index) {
//                case 0:
//                    tabbarItem = mainVC.homeVC.tabBarItem;
//                    break;
//                case 1:
//                    tabbarItem = mainVC.dynamicVC.tabBarItem;
//                    break;
//                case 2: {
//                    if (Use_LiveModule) {
//                        tabbarItem = mainVC.liveListVC.tabBarItem;
//                    }
//                    else if (!Use_LiveModule && Use_ChatModule) {
//                        tabbarItem = mainVC.chatListVC.tabBarItem;
//                    }
//                    else {
//                        tabbarItem = mainVC.mineVC.tabBarItem;
//                    }
//                }
//                    break;
//                case 3: {
//                    if (Use_ChatModule) {
//                        tabbarItem = mainVC.chatListVC.tabBarItem;
//                    }
//                    else {
//                        tabbarItem = mainVC.mineVC.tabBarItem;
//                    }
//                }
//                    break;
//                case 4:
//                    tabbarItem = mainVC.mineVC.tabBarItem;
//                    break;
//                default:
//                    break;
//            }
//
//            if (badgeNum > 0) {
//                tabbarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)badgeNum];
//            } else {
//                tabbarItem.badgeValue = nil;
//            }
//        }
//    });
}

/**
 *  设置导航栏左边按钮文字或者图片
 */
- (void)setLeftBarButtonTitle:(NSString  * _Nonnull)title
{
    if (XOIsEmptyString(title)) {
        JTLog(@"title不能为空");
        return;
    }
    
    if (!self.navigationItem.leftBarButtonItem) {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(leftBBIDidClick:)];
        self.navigationItem.leftBarButtonItem = bbi;
    } else {
        [self.navigationItem.leftBarButtonItem setTitle:title];
    }
}

- (void)setLeftBarButtonImage:(UIImage  * _Nonnull)image
{
    if (!image) {
        JTLog(@"image不能为空");
        return;
    }
    
    if (!self.navigationItem.leftBarButtonItem) {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(leftBBIDidClick:)];
        self.navigationItem.leftBarButtonItem = bbi;
    } else {
        [self.navigationItem.leftBarButtonItem setImage:image];
    }
}

/**
 *  设置导航栏右边按钮文字或者图片
 */
- (void)setRightBarButtonTitle:(NSString * _Nonnull)title
{
    if (XOIsEmptyString(title)) {
        JTLog(@"title不能为空");
        return;
    }
    
    if (!self.navigationItem.rightBarButtonItem) {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(rightBBIDidClick:)];
        self.navigationItem.rightBarButtonItem = bbi;
    } else {
        [self.navigationItem.rightBarButtonItem setTitle:title];
    }
}

- (void)setRightBarButtonImage:(UIImage * _Nonnull)image
{
    if (!image) {
        JTLog(@"image不能为空");
        return;
    }
    
    if (!self.navigationItem.rightBarButtonItem) {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(rightBBIDidClick:)];
        self.navigationItem.rightBarButtonItem = bbi;
    } else {
        [self.navigationItem.rightBarButtonItem setImage:image];
    }
}

/**
 *  导航栏按钮被点击
 */
- (void)leftBBIDidClick:(UIBarButtonItem *)sender { /*JTLog(@"导航栏左边按钮被点击");*/ }
- (void)rightBBIDidClick:(UIBarButtonItem *)sender { /*JTLog(@"导航栏右边按钮被点击");*/ }



/**
 *  键盘将要升起
 */
- (void)keyboardWillShow:(NSNotification *)noti { /*JTLog(@"键盘将要升起");*/ }
- (void)keyboardDidShow:(NSNotification *)noti { /*JTLog(@"键盘已经升起");*/ }
- (void)keyboardWillHide:(NSNotification *)noti { /*JTLog(@"键盘将要降落");*/ }

/**
 *  通用设置修改通知
 */
- (void)languageChanged:(NSNotification *)noti
{
    [self refreshByGenralSettingChange:JTGenralChangeLanguage userInfo:noti.object];
}
- (void)fontSizeChanged:(NSNotification *)noti
{
    [self refreshByGenralSettingChange:JTGenralChangeFontSize userInfo:noti.object];
}

/**
 *  通用设置改变
 *  由子类去具体实现
 */
- (void)refreshByGenralSettingChange:(JTGenralChangeType)genralType userInfo:(NSDictionary *)userInfo {}

/**
 *  弹框提醒
 */
- (void)showAlertWithTitle:(NSString * _Nullable)title
               message:(NSString * _Nullable)message
             sureTitle:(NSString * _Nullable)sureTitle
           cancelTitle:(NSString * _Nullable)cancelTitle
       sureComplection:(void(^)(void))sureComplection
     cancelComplection:(void(^)(void))cancelComplection
{
    if (XOIsEmptyString(sureTitle) && XOIsEmptyString(cancelTitle)) {
        JTLog(@"sureTitle 和 cancelTitle 不能都为空");
        return;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    // 取消
    if (!XOIsEmptyString(cancelTitle)) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (cancelComplection) {
                cancelComplection();
            }
            // 消失
            [alertVC dismissViewControllerAnimated:true completion:nil];
        }];
        [alertVC addAction:cancelAction];
    }
    // 确定
    if (!XOIsEmptyString(sureTitle)) {
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (sureComplection) {
                sureComplection();
            }
            // 消失
            [alertVC dismissViewControllerAnimated:true completion:nil];
        }];
        [alertVC addAction:sureAction];
    }
    // show
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
}

/**
 *  选择框 sheet
 */
- (void)showSheetWithTitle:(NSString * _Nullable)title
               message:(NSString * _Nullable)message
               actions:(NSArray <NSString *> * _Nonnull)actions
              redIndex:(NSNumber * _Nullable)redIndex
           complection:(void(^)(int index, NSString *title))complection
     cancelComplection:(void(^)(void))cancelComplection
{
    if (XOIsEmptyArray(actions)) {
        JTLog(@"actions不能都为空");
        return;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < actions.count; i++) {
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (redIndex && [redIndex intValue] == i) {
            style = UIAlertActionStyleDestructive;
        }
        UIAlertAction *action = [UIAlertAction actionWithTitle:actions[i] style:style handler:^(UIAlertAction * _Nonnull action) {
            if (complection) {
                complection(i, actions[i]);
            }
            // 消失
            [alertVC dismissViewControllerAnimated:true completion:nil];
        }];
        [alertVC addAction:action];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:XOLocalizedString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelComplection) {
            cancelComplection();
        }
        // 消失
        [alertVC dismissViewControllerAnimated:true completion:nil];
    }];
    [alertVC addAction:cancelAction];
    // show
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
}

/**
 *  显示照片选择
 */
- (void)showPickerPhoto:(void(^)(void))takePicture
       photoLibrary:(void(^)(void))photoLibrary
{
    NSArray *actions = @[XOLocalizedString(@"action.title.photos"), XOLocalizedString(@"action.title.camera")];
    [self showSheetWithTitle:nil message:nil actions:actions redIndex:nil complection:^(int index, NSString *title) {
        if (0 == index) {
            if (takePicture) {
                takePicture();
            }
        }
        else {
            if (photoLibrary) {
                photoLibrary();
            }
        }
    } cancelComplection:nil];
}


// 点击view, 取消输入
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

/**
 *  显示申请权限
 */
- (void)showAlertAuthor:(JTRequestAuthType)authType
{
    NSString *tips = XOLocalizedString(@"tip.title");
    NSString *sure = XOLocalizedString(@"sure");
    NSString *appname = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    // 相机
    if (JTRequestAuthCamera == authType) {
        NSString *message = [NSString stringWithFormat:@"%@%@", XOLocalizedString(@"permission.setting.Camera.%@"), appname];
        [self showAlertWithTitle:tips message:message sureTitle:sure cancelTitle:nil sureComplection:nil cancelComplection:nil];
    }
    // 相册
    else if (JTRequestAuthPhotos == authType) {
        NSString *message = [NSString stringWithFormat:@"%@%@", XOLocalizedString(@"permission.setting.Photos.%@"), appname];
        [self showAlertWithTitle:tips message:message sureTitle:sure cancelTitle:nil sureComplection:nil cancelComplection:nil];
    }
    // 定位
    else if (JTRequestAuthLocation == authType) {
        NSString *message = [NSString stringWithFormat:@"%@%@", XOLocalizedString(@"permission.setting.Location.%@"), appname];
        [self showAlertWithTitle:tips message:message sureTitle:sure cancelTitle:nil sureComplection:nil cancelComplection:nil];
    }
    // 麦克风
    else if (JTRequestAuthMicphone == authType) {
        NSString *message = [NSString stringWithFormat:@"%@%@", XOLocalizedString(@"permission.setting.Micphone.%@"), appname];
        [self showAlertWithTitle:tips message:message sureTitle:sure cancelTitle:nil sureComplection:nil cancelComplection:nil];
    }
    // 通讯录
    else if (JTRequestAuthAddressBook == authType) {
        NSString *message = [NSString stringWithFormat:@"%@%@", XOLocalizedString(@"permission.setting.AddressBook.%@"), appname];
        [self showAlertWithTitle:tips message:message sureTitle:sure cancelTitle:nil sureComplection:nil cancelComplection:nil];
    }
    // 通知
    else if (JTRequestAuthNotification == authType) {
        NSString *message = [NSString stringWithFormat:@"%@%@", XOLocalizedString(@"permission.setting.Notification.%@"), appname];
        [self showAlertWithTitle:tips message:message sureTitle:sure cancelTitle:nil sureComplection:nil cancelComplection:nil];
    }
}


@end
