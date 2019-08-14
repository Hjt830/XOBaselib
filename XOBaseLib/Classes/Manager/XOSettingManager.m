//
//  XOSettingManager.m
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import "XOSettingManager.h"
#import "XOFileManager.h"
#import "XOMacro.h"
#import "XOBaseConfig.h"
#import "NSBundle+XOBaseLib.h"
#import <MJRefresh/MJRefreshConfig.h>

#pragma mark ========================= language =========================

// 语言设置key
NSString * const XOLanguageOptionKey        = @"XOLanguageOptionKey";

// 中文简体
XOLanguageName const XOLanguageNameZh_Hans  = @"zh-Hans";
// 中文繁体
XOLanguageName const XOLanguageNameZh_Hant  = @"zh_Hant";
// 英文
XOLanguageName const XOLanguageNameEn       = @"en";

// 语言改变通知中心
NSString * const XOLanguageDidChangeNotification    = @"XOLanguageDidChangeNotificaiton";


#pragma mark ========================= fontSize =========================

// 字体大小设置key
NSString * const XOFontSizeOptionKey                = @"XOFontSizeOptionKey";
// 字体大小改变通知中心
NSString * const XOFontSizeDidChangeNotification    = @"XOFontSizeDidChangeNotification";


#pragma mark ========================= background =========================

// 聊天背景设置key
NSString * const XOChatBackgroundOptionKey          = @"XOFontSizeOptionKey";
// 聊天背景改变通知中心
NSString * const XOBackgroundDidChangeNotification  = @"XOBackgroundDidChangeNotification";



static XOSettingManager * __settingManager = nil;

@interface XOSettingManager ()

// 设置表属性
@property (nonatomic, strong) NSDictionary  *settingDictionary;


@end

@implementation XOSettingManager

+ (instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __settingManager = [[XOSettingManager alloc] init];
    });
    return __settingManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadSetting];
    }
    return self;
}

#pragma mark ========================= 加载配置 =========================

// 加载配置
- (void)loadSetting
{
    // 读取用户偏好设置
    if ([XOFM fileExistsAtPath:XOUserSettingFilePath()]) {
        [self loadUserSetting];
    }
    // 如果用户偏好设置文件为空, 则加载系统默认设置
    else {
        [self loadDefaultSetting];
    }
}

// 加载用户偏好设置
- (void)loadUserSetting
{
    _settingDictionary = [NSDictionary dictionaryWithContentsOfFile:XOUserSettingFilePath()];
    _isUserSetting = YES;
    // 语言
    _language = _settingDictionary[XOLanguageOptionKey];    // 用户语言设置
    _languageBundle = [NSBundle bundleWithPath:[[NSBundle xo_baseLibResourceBundle] pathForResource:_language ofType:@"lproj"]];
    // 字体
    NSNumber *fontNumber = _settingDictionary[XOFontSizeOptionKey];
    _fontSize = [fontNumber unsignedIntegerValue];          // 用户字体设置
}

// 加载系统默认设置
- (void)loadDefaultSetting
{
    _settingDictionary = [NSDictionary dictionaryWithContentsOfFile:XODefaultSettingFilePath()];
    _isUserSetting = NO;
    // 默认跟随系统语言设置
    NSString *systemLanguage = [[NSLocale preferredLanguages] firstObject];
    if ([systemLanguage hasPrefix:XOLanguageNameZh_Hans]) { // 中文简体
        _language = XOLanguageNameZh_Hans;
    } else if ([systemLanguage hasPrefix:XOLanguageNameZh_Hant]) {
        _language = XOLanguageNameZh_Hant;
    } else {
        _language = XOLanguageNameEn;
    }
    _languageBundle = [NSBundle bundleWithPath:[[NSBundle xo_baseLibResourceBundle] pathForResource:_language ofType:@"lproj"]];
    // 字体
    _fontSize = XOFontSizeStandard;                             // 默认标准字体大小
}

#pragma mark ========================= setter =========================

// 设置语言
- (void)setAppLanguage:(XOLanguageName)language
{
    if (!XOIsEmptyString(language)) {
        // 改变语言
        _language = language;
        _languageBundle = [NSBundle bundleWithPath:[[NSBundle xo_baseLibResourceBundle] pathForResource:language ofType:@"lproj"]];
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:XOLanguageDidChangeNotification object:@{XOLanguageOptionKey: language}];
        // 更新用户设置文件
        [self updateUserSettingWithOptionKey:XOLanguageOptionKey optionValue:language];

        // 设置第三方库的语言
        [[MJRefreshConfig defaultConfig] setLanguageCode:language];
    }
}

// 设置字体大小
- (void)setAppFontSize:(XOFontSize)fontSize
{
    // 改变字体大小
    _fontSize = fontSize;
    NSNumber *fontNumber = [NSNumber numberWithUnsignedInteger:fontSize];
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:XOFontSizeDidChangeNotification object:@{XOFontSizeOptionKey: fontNumber}];
    // 更新用户设置文件
    [self updateUserSettingWithOptionKey:XOFontSizeOptionKey optionValue:fontNumber];
}

#pragma mark ========================= public =========================

// 登录成功
- (void)loginIn
{
    // 读取用户偏好设置
    if ([XOFM fileExistsAtPath:XOUserSettingFilePath()]) {
        [self loadUserSetting];
    }
    // 如果用户偏好设置文件为空, 则将系统设置拷贝一份放到用户设置路径下
    else {
        [self generateUserSettingFile];
    }
}

// 注销
- (void)loginOut
{
    // 删除用户偏好设置
    [self removeUserSettingFile];
    // 并切换到系统默认设置
    [self loadDefaultSetting];
}

#pragma mark ========================= 用户设置文件操作 =========================

// 生成一个用户设置文件, 并保存到用户设置文件路径
- (void)generateUserSettingFile
{
    // 根据系统默认设置初始化用户设置文件
    NSMutableDictionary *mutSetting = [NSDictionary dictionaryWithContentsOfFile:XODefaultSettingFilePath()].mutableCopy;
    // 语言
    NSString *systemLanguage = [[NSLocale preferredLanguages] firstObject];
    if ([systemLanguage hasPrefix:XOLanguageNameZh_Hans]) { // 中文简体
        _language = XOLanguageNameZh_Hans;
    } else if ([systemLanguage hasPrefix:XOLanguageNameZh_Hant]) {
        _language = XOLanguageNameZh_Hant;
    } else {
        _language = XOLanguageNameEn;
    }
    [mutSetting setValue:_language forKey:XOLanguageOptionKey];
    _languageBundle = [NSBundle bundleWithPath:[[NSBundle xo_baseLibResourceBundle] pathForResource:_language ofType:@"lproj"]];
    // 字体
    _fontSize = XOFontSizeStandard;
    NSNumber *fontNumber = [NSNumber numberWithFloat:XOFontSizeStandard];
    [mutSetting setValue:fontNumber forKey:XOFontSizeOptionKey];
    
    // 将更新后的设置写入到用户设置目录下
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        BOOL result = [mutSetting writeToFile:XOUserSettingFilePath() atomically:YES];
        if (result) {
            self->_settingDictionary = mutSetting;
            self->_isUserSetting = YES;
            
            NSLog(@"==================================================================");
            NSLog(@"======================== 配置用户设置文件成功 ========================");
            NSLog(@"==================================================================");
        }
    }];
}

// 删除一个用户设置文件
- (void)removeUserSettingFile
{
    if ([XOFM fileExistsAtPath:XOUserSettingFilePath()]) {
        
        [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
            NSError *removeError = nil;
            if ([XOFM removeItemAtPath:XOUserSettingFilePath() error:&removeError]) {
                NSLog(@"==================================================================");
                NSLog(@"======================== 删除用户设置文件成功 ========================");
                NSLog(@"==================================================================");
            } else {
                NSLog(@"==================================================================");
                NSLog(@"======================== 删除用户设置文件失败: %@", removeError);
                NSLog(@"==================================================================");
            }
        }];
    }
    else {
        NSLog(@"====================================================================");
        NSLog(@"======================== 删除用户设置文件成功:: ========================");
        NSLog(@"====================================================================");
    }
}

// 更新用户设置文件
- (void)updateUserSettingWithOptionKey:(NSString * _Nonnull)optionKey optionValue:(id)value
{
    NSMutableDictionary *mutSetting = [NSDictionary dictionaryWithContentsOfFile:XOUserSettingFilePath()].mutableCopy;
    [mutSetting setValue:value forKey:optionKey];
    // 将更新后的设置写入到用户设置目录下
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        // 删除旧的用户设置文件
        NSError *error = nil;
        if ([XOFM removeItemAtPath:XOUserSettingFilePath() error:&error]) {
            if ([mutSetting writeToFile:XOUserSettingFilePath() atomically:YES]) {
                NSLog(@"更新用户设置成功: %@ : %@", optionKey, value);
            } else {
                NSLog(@"更新用户设置失败: %@ --- %@", optionKey, error);
            }
        } else {
            NSLog(@"更新用户设置文件失败: %@ --- %@", optionKey, error);
        }
    }];
}




@end
