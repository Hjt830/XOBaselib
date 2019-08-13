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
extern NSString * const JTLanguageOptionKey;

// 定义语言类型
typedef NSString *JTLanguageName NS_EXTENSIBLE_STRING_ENUM;
// 中文简体
extern JTLanguageName const JTLanguageNameZh_Hans;
// 中文繁体
extern JTLanguageName const JTLanguageNameZh_Hant;
// 英文
extern JTLanguageName const JTLanguageNameEn;

// 语言改变通知中心
extern NSString * const JTLanguageDidChangeNotification;



#pragma mark ========================= fontSize =========================

// 字体大小设置key
extern NSString * const JTFontSizeOptionKey;

// 字体大小枚举
typedef NS_ENUM(NSUInteger, JTFontSize) {
    // 超大
    JTFontSizeHuge      = 21,
    // 很大
    JTFontSizeLarge     = 19,
    // 大
    JTFontSizeBig       = 17,
    // 标准
    JTFontSizeStandard  = 15,
    // 较小
    JTFontSizeSmall     = 13,
};

// 字体大小改变通知中心
extern NSString * const JTFontSizeDidChangeNotification;

#define JTTextFont [UIFont systemFontOfSize:[XOSettingManager defaultManager].fontSize]

#define JTSubTextFont [UIFont systemFontOfSize:([XOSettingManager defaultManager].fontSize - 3)]

#pragma mark ========================= background =========================

// 聊天背景设置key
extern NSString * const JTChatBackgroundOptionKey;

// 聊天背景改变通知中心
extern NSString * const JTBackgroundDidChangeNotification;




/// 通用设置改变的类型
typedef NS_ENUM(NSInteger, JTGenralChangeType) {
    JTGenralChangeLanguage      = 1,
    JTGenralChangeFontSize      = 2,
    JTGenralChangeChatBgImage   = 3,
};

///////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// app设置管理器 //////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

@interface XOSettingManager : NSObject

// app当前使用的是否为用户偏好设置 (登录状态下, 使用用户偏好设置 --- YES,  未登录状态下, 使用系统默认设置 --- NO)
@property (nonatomic, assign, readonly) BOOL               isUserSetting;


@property (nonatomic, copy, readonly) JTLanguageName       language;    // app默认设置为跟随系统设置
@property (nonatomic, strong, readonly) NSBundle           *languageBundle;

@property (nonatomic, assign, readonly) JTFontSize         fontSize;     // app默认设置为JTFontSizeStandard


+ (instancetype)defaultManager;

// 登录成功
- (void)loginIn;

// 注销
- (void)loginOut;

// 设置语言
- (void)setAppLanguage:(JTLanguageName)language;

// 设置字体大小
- (void)setAppFontSize:(JTFontSize)fontSize;


@end

NS_ASSUME_NONNULL_END
