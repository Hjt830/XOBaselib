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
#import "UIImage+XOBaseLib.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface XOBaseViewController () <UIGestureRecognizerDelegate>
{
    id <UIGestureRecognizerDelegate> _delegate;
}
@end

@implementation XOBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged:) name:XOLanguageDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontSizeChanged:) name:XOFontSizeDidChangeNotification object:nil];
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged:) name:XOLanguageDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontSizeChanged:) name:XOFontSizeDidChangeNotification object:nil];
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
    
    [self showBackBarItem:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1) {
        // 记录系统返回手势的代理
        _delegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        // 设置系统返回手势的代理为当前控制器
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 设置系统返回手势的代理为我们刚进入控制器的时候记录的系统的返回手势代理
    self.navigationController.interactivePopGestureRecognizer.delegate = _delegate;
    
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
//        XOTabbarController *mainVC = (XOTabbarController *)self.tabBarController;
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
 *  设置导航栏返回
 */
- (void)showBackBarItem:(BOOL)show
{
    if (show) {
        if (self.navigationController.viewControllers.count > 1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 64, 44);
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 10)];
            [button setImage:[UIImage xo_imageNamedFromBaseBundle:@"back"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
            self.navigationItem.leftBarButtonItem = item;
        }
        else {
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

/**
 *  设置导航栏左边按钮文字或者图片
 */
- (void)setLeftBarButtonTitle:(NSString  * _Nonnull)title
{
    if (XOIsEmptyString(title)) {
        XOLog(@"title不能为空");
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
        XOLog(@"image不能为空");
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
        XOLog(@"title不能为空");
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
        XOLog(@"image不能为空");
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
- (void)leftBBIDidClick:(UIBarButtonItem *)sender { /*XOLog(@"导航栏左边按钮被点击");*/ }
- (void)rightBBIDidClick:(UIBarButtonItem *)sender { /*XOLog(@"导航栏右边按钮被点击");*/ }



/**
 *  键盘将要升起
 */
- (void)keyboardWillShow:(NSNotification *)noti { /*XOLog(@"键盘将要升起");*/ }
- (void)keyboardDidShow:(NSNotification *)noti { /*XOLog(@"键盘已经升起");*/ }
- (void)keyboardWillHide:(NSNotification *)noti { /*XOLog(@"键盘将要降落");*/ }

/**
 *  通用设置修改通知
 */
- (void)languageChanged:(NSNotification *)noti
{
    [self refreshByGenralSettingChange:XOGenralChangeLanguage userInfo:noti.object];
}
- (void)fontSizeChanged:(NSNotification *)noti
{
    [self refreshByGenralSettingChange:XOGenralChangeFontSize userInfo:noti.object];
}

/**
 *  通用设置改变
 *  由子类去具体实现
 */
- (void)refreshByGenralSettingChange:(XOGenralChangeType)genralType userInfo:(NSDictionary *)userInfo {}

#pragma mark ========================= UIGestureRecognizerDelegate =========================

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.navigationController.childViewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return self.navigationController.viewControllers.count > 1;
}

@end
