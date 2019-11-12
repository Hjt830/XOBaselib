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

@interface XOBaseViewController : UIViewController

/** 设置菜单栏的角标
 *  badgeNum: 角标数  index: 要设置的BBI的位置
 */
- (void)setBadgeNum:(NSUInteger)badgeNum atIndex:(NSUInteger)index;

/**
 *  设置导航栏左边、右边按钮文字或者图片
 */
- (void)showBackBarItem:(BOOL)show;
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
    
@end

NS_ASSUME_NONNULL_END
