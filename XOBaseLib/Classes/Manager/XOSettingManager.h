//
//  XOSettingManager.h
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


#pragma mark ========================= language =========================

// 语言设置key
extern NSString * const XOLanguageOptionKey;

// 定义语言类型
typedef NSString *XOLanguageName NS_EXTENSIBLE_STRING_ENUM;
// 中文简体
extern XOLanguageName const XOLanguageNameZh_Hans;
// 中文繁体
extern XOLanguageName const XOLanguageNameZh_Hant;
// 英文
extern XOLanguageName const XOLanguageNameEn;

// 语言改变通知中心
extern NSString * const XOLanguageDidChangeNotification;



#pragma mark ========================= fontSize =========================

// 字体大小设置key
extern NSString * const XOFontSizeOptionKey;

// 字体大小枚举
typedef NS_ENUM(NSUInteger, XOFontSize) {
    // 超大
    XOFontSizeHuge      = 21,
    // 很大
    XOFontSizeLarge     = 19,
    // 大
    XOFontSizeBig       = 17,
    // 标准
    XOFontSizeStandard  = 15,
    // 较小
    XOFontSizeSmall     = 13,
};

// 字体大小改变通知中心
extern NSString * const XOFontSizeDidChangeNotification;

#define XOTextFont [UIFont systemFontOfSize:[XOSettingManager defaultManager].fontSize]

#define XOSubTextFont [UIFont systemFontOfSize:([XOSettingManager defaultManager].fontSize - 3)]

#pragma mark ========================= background =========================

// 聊天背景设置key
extern NSString * const XOChatBackgroundOptionKey;

// 聊天背景改变通知中心
extern NSString * const XOBackgroundDidChangeNotification;




/// 通用设置改变的类型
typedef NS_ENUM(NSInteger, XOGenralChangeType) {
    XOGenralChangeLanguage      = 1,
    XOGenralChangeFontSize      = 2,
    XOGenralChangeChatBgImage   = 3,
};

///////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// app设置管理器 //////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

@interface XOSettingManager : NSObject

// app当前使用的是否为用户偏好设置 (登录状态下, 使用用户偏好设置 --- YES,  未登录状态下, 使用系统默认设置 --- NO)
@property (nonatomic, assign, readonly) BOOL               isUserSetting;


@property (nonatomic, copy, readonly) XOLanguageName       language;     // app默认设置为跟随系统设置
@property (nonatomic, strong, readonly) NSBundle           *baseBundle;
@property (nonatomic, strong, readonly) NSBundle           *languageBundle;

@property (nonatomic, assign, readonly) XOFontSize         fontSize;     // app默认设置为XOFontSizeStandard
@property (nonatomic, assign, readonly) NSString           *chatBG;      // app聊天页背景

+ (instancetype)defaultManager;

// 登录成功
- (void)loginIn;

// 注销
- (void)loginOut;

// 设置语言
- (void)setAppLanguage:(XOLanguageName)language;

// 设置字体大小
- (void)setAppFontSize:(XOFontSize)fontSize;

/**
 *  @brief 设置聊天背景
 */
- (void)setChatBGImage:(UIImage * _Nonnull)bgImage
           complection:(void(^)(BOOL finish, UIImage *bgImage, NSError *error))handler;
/**
 *  @brief 获取聊天背景图片
 */
- (void)getCurrentChatBGImage:(void(^)(BOOL finish, UIImage * _Nullable bgImage))handler;


@end

NS_ASSUME_NONNULL_END
