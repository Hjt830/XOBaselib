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
#import "UIColor+XOExtension.h"
#import "UIViewController+XOExtension.h"
#import <AVFoundation/AVFoundation.h>

@interface XOBaseViewController () <UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate>
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
    self.view.backgroundColor = [UIColor groupTableViewColor];
    
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
    
//    // tabbarVC的基础控制器的导航栏置空
//    NSArray <UIViewController *>*viewControllers = self.tabBarController.viewControllers;
//    if (viewControllers.count > 0 && [viewControllers containsObject:self]) {
//        self.navigationItem.titleView = nil;
//        self.navigationItem.leftBarButtonItem = nil;
//        self.navigationItem.leftBarButtonItems = nil;
//        self.navigationItem.rightBarButtonItem = nil;
//        self.navigationItem.rightBarButtonItems = nil;
//    }
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
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.view endEditing:YES];
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

- (UINavigationItem *)navigationItem
{
    UITabBarController *tabBarVC = self.tabBarController;
    if (tabBarVC) {
        return self.tabBarController.navigationItem;
    }
    return [super navigationItem];
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
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(leftBBIDidClick:)];
    self.navigationItem.leftBarButtonItem = bbi;
}

- (void)setLeftBarButtonImage:(UIImage  * _Nonnull)image
{
    if (!image) {
        XOLog(@"image不能为空");
        return;
    }
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(leftBBIDidClick:)];
    self.navigationItem.leftBarButtonItem = bbi;
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
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(rightBBIDidClick:)];
    self.navigationItem.rightBarButtonItem = bbi;
}

- (void)setRightBarButtonImage:(UIImage * _Nonnull)image
{
    if (!image) {
        XOLog(@"image不能为空");
        return;
    }
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(rightBBIDidClick:)];
    self.navigationItem.rightBarButtonItem = bbi;
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
/**
 *  拍照
 */
- (void)takePhotoInCamera:(BOOL)allowEdit handler:(void(^)(NSDictionary <UIImagePickerControllerInfoKey,id> *info))cameraHandler
{
    AVAuthorizationStatus cameraAuth = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    // 已授权
    if (AVAuthorizationStatusAuthorized == cameraAuth)
    {
        self.pickHandler = [cameraHandler copy];
        [self openCamera:allowEdit];
    }
    // 请求授权
    else if (AVAuthorizationStatusNotDetermined == cameraAuth) {
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            [self takePhotoInCamera:allowEdit handler:cameraHandler];
        }];
    }
    // 拒绝授权 | 家长控制
    else {
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        NSString *message = [NSString stringWithFormat:XOLocalizedString(@"permission.setting.Camera.%@"), appName];
        [self showAlertWithTitle:XOLocalizedString(@"tip.title") message:message sureTitle:XOLocalizedString(@"sure") cancelTitle:XOLocalizedString(@"cancel") sureComplection:^{
            
            [self openAppSetting];
        } cancelComplection:NULL];
    }
}

/**
 *  选择单张照片
 */
- (void)pickSinglePicture:(BOOL)allowEdit handler:(UIImagePickControllerHandler)pickHandler
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    // 已授权
    if (PHAuthorizationStatusAuthorized == status)
    {
        self.pickHandler = [pickHandler copy];
        [self openSystemAlbum:allowEdit];
    }
    // 请求授权
    else if (PHAuthorizationStatusNotDetermined == status)
    {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            [self pickSinglePicture:allowEdit handler:pickHandler];
        }];
    }
    // 拒绝授权 | 家长控制
    else {
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        NSString *message = [NSString stringWithFormat:XOLocalizedString(@"permission.setting.Photos.%@"), appName];
        [self showAlertWithTitle:XOLocalizedString(@"tip.title") message:message sureTitle:XOLocalizedString(@"sure") cancelTitle:XOLocalizedString(@"cancel") sureComplection:^{
            
            [self openAppSetting];
        } cancelComplection:NULL];
    }
}

/**
*  选择多张照片
*/
- (void)pickMultiplePicture:(int)maxCount handler:(TZImagePickControllerHandler)multiplePickHandler
{
    self.multiplePickHandler = [multiplePickHandler copy];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount columnNumber:3 delegate:self];
        imagePicker.statusBarStyle = UIStatusBarStyleLightContent;
        imagePicker.maxImagesCount = maxCount;
        imagePicker.videoMaximumDuration = 15;
        // 2. 在这里设置imagePickerVc的外观
        imagePicker.iconThemeColor = AppTintColor;
        imagePicker.navigationBar.barTintColor = AppTintColor;
        imagePicker.navigationBar.tintColor = [UIColor whiteColor];
        imagePicker.oKButtonTitleColorDisabled = TextBrownColor;
        imagePicker.oKButtonTitleColorNormal = AppTintColor;
        // 3. 设置是否可以选择视频/图片/原图
        imagePicker.allowPickingOriginalPhoto = YES;
        // 4. 照片排列按修改时间升序
        imagePicker.sortAscendingByModificationDate = YES;
        // 5. 裁剪
        imagePicker.allowCrop = YES;
        imagePicker.scaleAspectFillCrop = YES;
        imagePicker.cropRectPortrait = CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH)/2.0, SCREEN_WIDTH, SCREEN_HEIGHT);
        // 6. 设置语言
        XOLanguageName language = [XOSettingManager defaultManager].language;
        if (!XOIsEmptyString(language) && [language isEqualToString:XOLanguageNameEn]) {
            imagePicker.preferredLanguage = @"en";
        } else {
            imagePicker.preferredLanguage = @"zh-Hant";
        }
        imagePicker.allowPreview = YES;
        imagePicker.allowPickingVideo = NO;
        imagePicker.allowPickingImage = YES;
        imagePicker.allowPickingMultipleVideo = NO;
        imagePicker.allowTakePicture = NO;
        imagePicker.allowTakeVideo = NO;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }];
}

// 拍照
- (void)openCamera:(BOOL)allowEdit
{
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = allowEdit;
            picker.showsCameraControls = YES;
            picker.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:picker animated:YES completion:nil];
        }];
    }
}

// 打开相册
- (void)openSystemAlbum:(BOOL)allowEdit
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = allowEdit; // 设置拍照后的图片可被编辑
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:picker animated:YES completion:nil];
        
        [UINavigationBar appearance].barTintColor = AppTintColor;
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
        [UINavigationBar appearance].translucent = NO;
    }];
}

#pragma mark ========================= UIImagePickerControllerDelegate =========================

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [UINavigationBar appearance].barTintColor = [UIColor XOWhiteColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    if (self.pickHandler) {
        self.pickHandler(info);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [UINavigationBar appearance].barTintColor = [UIColor XOWhiteColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark ========================= TZImagePickerControllerDelegate =========================

// 选择图片的回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    if (self.multiplePickHandler) {
        self.multiplePickHandler(photos, assets, isSelectOriginalPhoto, infos);
    }
}


@end
