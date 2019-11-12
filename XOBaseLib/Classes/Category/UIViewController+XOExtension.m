//
//  UIViewController+XOExtension.m
//  xxoogo
//
//  Created by kenter on 2019/10/31.
//  Copyright © 2019 xinchidao. All rights reserved.
//

#import "UIViewController+XOExtension.h"
#import "NSBundle+XOBaseLib.h"
#import "XOMacro.h"

@implementation UIViewController (XOExtension)

// 增加返回按钮
- (void)addBackBarButtonItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 64, 44);
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 10)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)back
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (self.navigationController) {
            if (self.navigationController.viewControllers.count > 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
            }
            
        } else {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
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
        XOLog(@"actions不能都为空");
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
        NSLog(@"sureTitle 和 cancelTitle 不能都为空");
        return;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (!XOIsEmptyString(sureTitle)) {
        UIAlertAction *sure = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
            
            if (sureComplection) {
                sureComplection ();
            }
        }];
        [sure setValue:AppTinColor forKey:@"_titleTextColor"];
        [alertVC addAction:sure];
    }
    if (!XOIsEmptyString(cancelTitle)) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
            
            if (cancelComplection) {
                cancelComplection ();
            }
        }];
        [cancel setValue:AppTinColor forKey:@"_titleTextColor"];
        [alertVC addAction:cancel];
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:alertVC animated:YES completion:nil];
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

/**
 *  显示申请权限
 */
- (void)showAlertAuthor:(XORequestAuthType)authType
{
    NSString *tips = XOLocalizedString(@"tip.title");
    NSString *sure = XOLocalizedString(@"sure");
    NSString *cancel = XOLocalizedString(@"cancel");
    NSString *appname = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
    // 相机
    if (XORequestAuthCamera == authType) {
        NSString *message = [NSString stringWithFormat:XOLocalizedString(@"permission.setting.Camera.%@"), appname];
        [self showAlertWithTitle:tips message:message sureTitle:sure cancelTitle:cancel sureComplection:^{
            [self openAppSetting];
        } cancelComplection:nil];
    }
    // 相册
    else if (XORequestAuthPhotos == authType) {
        NSString *message = [NSString stringWithFormat:XOLocalizedString(@"permission.setting.Photos.%@"), appname];
        [self showAlertWithTitle:tips message:message sureTitle:sure cancelTitle:cancel sureComplection:^{
            [self openAppSetting];
        } cancelComplection:nil];
    }
    // 定位
    else if (XORequestAuthLocation == authType) {
        NSString *message = [NSString stringWithFormat:XOLocalizedString(@"permission.setting.Location.%@"), appname];
        [self showAlertWithTitle:tips message:message sureTitle:sure cancelTitle:cancel sureComplection:^{
            [self openAppSetting];
        } cancelComplection:nil];
    }
    // 麦克风
    else if (XORequestAuthMicphone == authType) {
        NSString *message = [NSString stringWithFormat:XOLocalizedString(@"permission.setting.Micphone.%@"), appname];
        [self showAlertWithTitle:tips message:message sureTitle:sure cancelTitle:cancel sureComplection:^{
            [self openAppSetting];
        } cancelComplection:nil];
    }
    // 通讯录
    else if (XORequestAuthAddressBook == authType) {
        NSString *message = [NSString stringWithFormat:XOLocalizedString(@"permission.setting.AddressBook.%@"), appname];
        [self showAlertWithTitle:tips message:message sureTitle:sure cancelTitle:cancel sureComplection:^{
            [self openAppSetting];
        } cancelComplection:nil];
    }
    // 通知
    else if (XORequestAuthNotification == authType) {
        NSString *message =[NSString stringWithFormat:XOLocalizedString(@"permission.setting.Notification.%@"), appname];
        [self showAlertWithTitle:tips message:message sureTitle:sure cancelTitle:cancel sureComplection:^{
            [self openAppSetting];
        } cancelComplection:nil];
    }
}

- (void)openAppSetting
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (@available (iOS 10.0, *)) {
        NSString * const  AppUniversalLinks = @"https://xxoolive.tv/*";
        [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly:AppUniversalLinks} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
