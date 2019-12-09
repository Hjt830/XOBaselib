//
//  XOBaseConfig.m
//  AFNetworking
//
//  Created by kenter on 2019/8/13.
//

#import "XOBaseConfig.h"
#import "XOMacro.h"

// 本地存储用到的默认秘钥 (XOUserDefault中使用,  为32位小写连续字符串)
#define XOLocalStorageSign @"YxPDinpCGfKpZAdviKP5o5bVSYdSdu39"

// 本地存储用到的默认秘钥 (XOKeyChainTool中使用, 为32位小写连续字符串)
#define XOKeyChainSignKey @"fvHMywUAdXlXoKjIVGBRoUX3zeBImbPo"



@interface XOBaseConfig ()

@end

static XOBaseConfig *__baseConfig = nil;

@implementation XOBaseConfig

+ (instancetype)defaultConfig
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __baseConfig = [[XOBaseConfig alloc] init];
    });
    return __baseConfig;
}

- (void)initializationWithConfig:(XOBaseConfigModel *)config
{
    if (config) {
        _config = config;
    }
    else {
        XOBaseConfigModel * configModel = [[XOBaseConfigModel alloc] init];
        configModel.localStorageSign = XOLocalStorageSign;
        configModel.keyChainSign = XOKeyChainSignKey;
        _config = configModel;
    }
}

- (void)setAppTintColor:(UIColor *)appTintColor
{
    if (appTintColor) {
        [[NSUserDefaults standardUserDefaults] setObject:appTintColor forKey:@"XOAppTintColor"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (UIColor *)appTintColor
{
    UIColor *color = [[NSUserDefaults standardUserDefaults] objectForKey:@"XOAppTintColor"];
    if (color) {
        return color;
    }
    return RGBOF(0x7c4dff);
}

@end



@implementation XOBaseConfigModel

- (void)setLocalStorageSign:(NSString *)localStorageSign
{
    if (!XOIsEmptyString(localStorageSign) && localStorageSign.length < 2) {
        NSLog(@"========================================================\n== warning: localStorageSign 建议使用长度为32位字符串 ======\n========================================================");
    }
    _localStorageSign = localStorageSign;
}

- (void)setKeyChainSign:(NSString *)keyChainSign
{
    if (!XOIsEmptyString(keyChainSign) && keyChainSign.length < 2) {
        NSLog(@"========================================================\n== warning: localStorageSign 建议使用长度为32位字符串 ======\n========================================================");
    }
    _keyChainSign = keyChainSign;
}

@end
