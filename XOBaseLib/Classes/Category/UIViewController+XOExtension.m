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
                   actions:(NSArray <NSString *> * _Nullable)actions
               cancelTitle:(NSString * _Nullable)cancelTitle
                  redIndex:(NSNumber * _Nullable)redIndex
               complection:(void(^_Nullable)(int index, NSString * _Nullable title))complection
         cancelComplection:(void(^_Nullable)(void))cancelComplection
{
//    if (XOIsEmptyArray(actions)) {
//        XOLog(@"actions不能都为空");
//        return;
//    }
    
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
//        [action setValue:AppTintColor forKey:@"_titleTextColor"];
        [alertVC addAction:action];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelComplection) {
            cancelComplection();
        }
        // 消失
        [alertVC dismissViewControllerAnimated:true completion:nil];
    }];
    [alertVC addAction:cancelAction];
    // show
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (nil != self.navigationController) {
            [self.navigationController presentViewController:alertVC animated:YES completion:nil];
        } else {
            [self presentViewController:alertVC animated:YES completion:nil];
        }
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
        UIAlertAction *sure = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
            
            if (sureComplection) {
                sureComplection ();
            }
        }];
        [sure setValue:AppTintColor forKey:@"_titleTextColor"];
        [alertVC addAction:sure];
    }
    if (!XOIsEmptyString(cancelTitle)) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
            
            if (cancelComplection) {
                cancelComplection ();
            }
        }];
        [cancel setValue:AppTintColor forKey:@"_titleTextColor"];
        [alertVC addAction:cancel];
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (nil != self.navigationController) {
            [self.navigationController presentViewController:alertVC animated:YES completion:nil];
        } else {
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }];
}

/**
 *  带输入框的弹框
 */
- (void)showAlertWithTitle:(NSString * _Nullable)title
                   message:(NSString * _Nullable)message
                 sureTitle:(NSString * _Nullable)sureTitle
               cancelTitle:(NSString * _Nullable)cancelTitle
           sureComplection:(void(^ _Nullable)(NSString * _Nullable inputStr))sureComplection
         cancelComplection:(void(^ _Nullable)(NSString * _Nullable inputStr))cancelComplection
                 textField:(void(^ _Nullable)(UITextField * _Nonnull textField))inputHanlder
{
    if (XOIsEmptyString(sureTitle) && XOIsEmptyString(cancelTitle)) {
        NSLog(@"sureTitle 和 cancelTitle 不能都为空");
        return;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        if (inputHanlder) {
            inputHanlder(textField);
        }
    }];
    if (!XOIsEmptyString(sureTitle)) {
        UIAlertAction *sure = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (sureComplection) {
                sureComplection (alertVC.textFields.firstObject.text);
            }
            [alertVC dismissViewControllerAnimated:YES completion:nil];
            [alertVC.textFields.firstObject resignFirstResponder];
        }];
        [sure setValue:AppTintColor forKey:@"_titleTextColor"];
        [alertVC addAction:sure];
    }
    if (!XOIsEmptyString(cancelTitle)) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (cancelComplection) {
                cancelComplection (alertVC.textFields.firstObject.text);
            }
            [alertVC.textFields.firstObject resignFirstResponder];
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }];
        [cancel setValue:AppTintColor forKey:@"_titleTextColor"];
        [alertVC addAction:cancel];
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (nil != self.navigationController) {
            [self.navigationController presentViewController:alertVC animated:YES completion:nil];
        } else {
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }];
}

/**
 *  显示照片选择
 */
- (void)showPickerPhotoInAlbum:(void(^)(void))albumComplection takePhotoInCamera:(void(^)(void))cameraComplection
{
    NSArray *actions = @[XOLocalizedString(@"action.title.photos"), XOLocalizedString(@"action.title.camera")];
    [self showSheetWithTitle:nil message:nil actions:actions cancelTitle:XOLocalizedString(@"cancel") redIndex:nil complection:^(int index, NSString *title) {
        if (0 == index) {
            if (albumComplection) {
                albumComplection();
            }
        }
        else {
            if (cameraComplection) {
                cameraComplection();
            }
        }
    } cancelComplection:nil];
}

- (void)openAppSetting
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (@available (iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@"https://baidu.com/*"} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
