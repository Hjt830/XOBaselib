//
//  XOBaseViewController.h
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XOSettingManager.h"

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


@interface XOBaseViewController : UIViewController

// iphoneXx以上机型的安全边缘b偏移量
@property (nonatomic, assign, readonly) UIEdgeInsets      safeInset;


/** 设置菜单栏的角标
 *  badgeNum: 角标数  index: 要设置的BBI的位置
 */
- (void)setBadgeNum:(NSUInteger)badgeNum atIndex:(NSUInteger)index;

/**
 *  设置导航栏左边、右边按钮文字或者图片
 */
- (void)setLeftBarButtonTitle:(NSString  * _Nonnull)title;
- (void)setLeftBarButtonImage:(UIImage  * _Nonnull)image;
- (void)setRightBarButtonTitle:(NSString * _Nonnull)title;
- (void)setRightBarButtonImage:(UIImage * _Nonnull)image;

/**
 *  导航栏按钮被点击
 */
- (void)leftBBIDidClick:(UIBarButtonItem *_Nonnull)sender;
- (void)rightBBIDidClick:(UIBarButtonItem *_Nonnull)sender;

/**
 *  键盘将要升起、降落
 */
- (void)keyboardWillShow:(NSNotification *_Nonnull)noti;
- (void)keyboardDidShow:(NSNotification *_Nonnull)noti;
- (void)keyboardWillHide:(NSNotification *_Nonnull)noti;

/** @brief 通用设置改变
 *  @param genralType 改变的类型
 *  @param userInfo 改变后的通用数据
 */
- (void)refreshByGenralSettingChange:(XOGenralChangeType)genralType userInfo:(NSDictionary *_Nonnull)userInfo;


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
 *  选择框 sheet
 */
- (void)showSheetWithTitle:(NSString * _Nullable)title
                   message:(NSString * _Nullable)message
                   actions:(NSArray <NSString *> * _Nonnull)actions
                  redIndex:(NSNumber * _Nullable)redIndex
               complection:(void(^_Nullable)(int index, NSString * _Nullable title))complection
         cancelComplection:(void(^_Nullable)(void))cancelComplection;

/**
 *  显示照片选择
 */
- (void)showPickerPhoto:(void(^_Nullable)(void))takePicture
           photoLibrary:(void(^_Nullable)(void))photoLibrary;

/**
 *  提示打开权限
 */
- (void)showAlertAuthor:(XORequestAuthType)authType;
    
@end

NS_ASSUME_NONNULL_END
