//
//  XOSmsCodeManager.m
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import "XOSmsCodeManager.h"
#import "XOMacro.h"

#define HTSmsCodeKey        @"HTSmsCodeKey"         // 验证码的key
#define HTSmsCodeRegistKey  @"HTSmsCodeRegistKey"   // 注册账号的验证码的key
#define HTSmsCodeForgotKey  @"HTSmsCodeForgotKey"   // 忘记密码的验证码的key
#define HTSmsCodeResetKey   @"HTSmsCodeResetKey"    // 重置密码的验证码的key

@interface XOSmsCodeManager()

@end

static XOSmsCodeManager *__codeManager = nil;

@implementation XOSmsCodeManager

+ (instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        __codeManager = [[super allocWithZone:NULL] init];
    });
    return __codeManager;
}

- (instancetype)copy
{
    return __codeManager;
}

- (instancetype)mutableCopy
{
    return __codeManager;
}

/** @brief 保存验证码
 *  @param smsCode 要保存的验证码数据
 */
- (void)saveSmsCode:(JTSMSCodeModel * _Nonnull)smsCode
{
    if (!smsCode) return;
    
    // 将模型转为字典
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(smsCode.codeType) forKey:@"codeType"];
    [dict setValue:smsCode.telphone forKey:@"telphone"];
    [dict setValue:@(smsCode.sendTime) forKey:@"sendTime"];
    [dict setValue:smsCode.sendID forKey:@"sendID"];
    // 取本地存储的值
    NSDictionary *codeDict = [[NSUserDefaults standardUserDefaults] objectForKey:HTSmsCodeKey];
    NSMutableDictionary *smsCodeDict = nil;
    // 如果为空，构建
    if (XOIsEmptyDictionary(codeDict)) {
        smsCodeDict = [NSMutableDictionary dictionary];
    }
    // 如果不为空，更新
    else {
        smsCodeDict = [codeDict mutableCopy];
    }
    switch (smsCode.codeType) {
        case HTSMSCodeTypeRegist:   // 注册
            [smsCodeDict setValue:dict forKey:HTSmsCodeRegistKey];
            break;
        case HTSMSCodeTypeForgot:   // 忘记密码
            [smsCodeDict setValue:dict forKey:HTSmsCodeForgotKey];
            break;
        case HTSMSCodeTypeReset:    // 重置密码
            [smsCodeDict setValue:dict forKey:HTSmsCodeResetKey];
            break;
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults] setObject:smsCodeDict forKey:HTSmsCodeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** @brief 根据类型获取验证码数据
 *  @param smsCodeType 要获取的验证码数据的类型
 */
- (JTSMSCodeModel * _Nullable)getSmsCode:(HTSMSCodeType)smsCodeType
{
    NSDictionary *codeDict = [[NSUserDefaults standardUserDefaults] objectForKey:HTSmsCodeKey];
    if (XOIsEmptyDictionary(codeDict)) {
        return nil;
    }
    NSDictionary *dict = nil;
    switch (smsCodeType) {
        case HTSMSCodeTypeRegist:   // 注册
            dict = [codeDict valueForKey:HTSmsCodeRegistKey];
            break;
        case HTSMSCodeTypeForgot:   // 忘记密码
            dict = [codeDict valueForKey:HTSmsCodeForgotKey];
            break;
        case HTSMSCodeTypeReset:    // 重置密码
            dict = [codeDict valueForKey:HTSmsCodeResetKey];
            break;
        default:
            break;
    }
    
    JTSMSCodeModel *smsCode = [[JTSMSCodeModel alloc] init];
    smsCode.codeType = smsCodeType;
    smsCode.telphone = [dict valueForKey:@"telphone"];
    smsCode.sendTime = [[dict valueForKey:@"sendTime"] doubleValue];
    smsCode.sendID = [dict valueForKey:@"sendID"];
    return smsCode;
}

@end


@implementation JTSMSCodeModel

@end
