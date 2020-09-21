//
//  UIViewController+XOExtension.h
//  xxoogo
//
//  Created by kenter on 2019/10/31.
//  Copyright © 2019 xinchidao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/// 请求权限的类型
typedef NS_ENUM(NSInteger, XORequestAuthType) {
    XORequestAuthPhotos  = 200,     // 相册
    XORequestAuthCamera   = 201,    // 相机
    XORequestAuthLocation = 202,    // 定位
    XORequestAuthMicphone = 203,    // 麦克风
    XORequestAuthAddressBook = 204, // 通讯录
    XORequestAuthNotification = 205,// 通知
};

@interface UIViewController (XOExtension)

// 增加返回按钮
- (void)addBackBarButtonItem;

/**
 *  选择框 sheet
 */
- (void)showSheetWithTitle:(NSString * _Nullable)title
                   message:(NSString * _Nullable)message
                   actions:(NSArray <NSString *> * _Nullable)actions
               cancelTitle:(NSString * _Nullable)cancelTitle
                  redIndex:(NSNumber * _Nullable)redIndex
               complection:(void(^_Nullable)(int index, NSString * _Nullable title))complection
         cancelComplection:(void(^_Nullable)(void))cancelComplection;

/**
 *  弹框提醒 alert
 */
- (void)showAlertWithTitle:(NSString * _Nullable)title
                   message:(NSString * _Nullable)message
                 sureTitle:(NSString * _Nullable)sureTitle
               cancelTitle:(NSString * _Nullable)cancelTitle
           sureComplection:(void(^_Nullable)(void))sureComplection
         cancelComplection:(void(^_Nullable)(void))cancelComplection;

/**
 *  带输入框的弹框
 */
- (void)showAlertWithTitle:(NSString * _Nullable)title
                   message:(NSString * _Nullable)message
                 sureTitle:(NSString * _Nullable)sureTitle
               cancelTitle:(NSString * _Nullable)cancelTitle
           sureComplection:(void(^ _Nullable)(NSString * _Nullable inputStr))sureComplection
         cancelComplection:(void(^ _Nullable)(NSString * _Nullable inputStr))cancelComplection
                 textField:(void(^ _Nullable)(UITextField * _Nonnull textField))inputHanlder;

/**
 *  提示打开权限
 */
- (void)showAlertAuthor:(XORequestAuthType)authType;

/**
 *  显示照片选择
 */
- (void)showPickerPhotoInAlbum:(void(^)(void))albumComplection takePhotoInCamera:(void(^)(void))cameraComplection;

/**
*  打开app权限设置
*/
- (void)openAppSetting;

@end

NS_ASSUME_NONNULL_END
