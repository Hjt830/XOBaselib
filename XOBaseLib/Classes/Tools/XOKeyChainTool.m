//
//  XOKeyChainTool.m
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import "XOKeyChainTool.h"
#import "XOMacro.h"
#import "XOBaseConfig.h"
#import "NSString+XOExtension.h"

// App的token存储key
NSString * const XOAppAuthorTokenKey = @"xoKeyChain_AppAuthorTokenKey";

// App登录用户名(手机号码/邮箱)存储key
NSString * const XOAppLoginUserName  = @"xoKeyChain_AppLoginUserName";

// App登录密码存储key
NSString * const XOAppLoginPassWord  = @"xoKeyChain_AppLoginPassWord";


static NSString * XOKeyChainKey = nil;
static NSString * XOKeyChainIv = nil;

@implementation XOKeyChainTool

/**
 *  添加数据到钥匙串中
 */
+ (void)addKeychainData:(id)data forKey:(NSString *)key {
    // 获取查询字典
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    // 在添加之前先删除旧数据
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    // 添加新的数据到字典
    NSData *archiverData;
    if (@available(iOS 11.0, *)) archiverData = [NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:YES error:nil];
    else archiverData = [NSKeyedArchiver archivedDataWithRootObject:data];
    
    if (archiverData != nil) {
        [keychainQuery setObject:archiverData forKey:(__bridge id)kSecValueData];
        // 将数据字典添加到钥匙串
        SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
    } else {
        NSLog(@"archiverData is nil, 添加数据失败");
    }
}

/**
 *  根据key获取钥匙串中的数据
 */
+ (id)getKeychainDataForKey:(NSString *)key
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            if (@available(iOS 11.0, *)) {
                ret = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSData class] fromData:(__bridge NSData *)keyData error:nil];
            } else {
                ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
            }
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@",key,e);
        } @finally {
            
        }
    }
    
    if (keyData) {
        CFRelease(keyData);
    }
    
    return ret;
}

/**
 *  删除钥匙串中的数据
 */
+ (void)deleteKeychainDataForKey:(NSString *)key
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}


/**
 *  获取钥匙串中存储的数据字典
 */
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(id)kSecClass,// 标识符(kSecAttrGeneric通常值位密码)
            service, (__bridge id)kSecAttrService,// 服务(kSecAttrService)
            service, (__bridge id)kSecAttrAccount,// 账户(kSecAttrAccount)
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,// kSecAttrAccessiblein变量用来指定这个应用何时需要访问这个数据
            nil];
}

+ (NSString *)getKeychainSignKey
{
    if (XOIsEmptyString(XOKeyChainKey)) {
        NSString *keychainSign = [XOBaseConfig defaultConfig].config.keyChainSign;
        if (keychainSign.length == 1) {
            XOKeyChainKey = keychainSign;
        } else {
            NSUInteger halfIndex = (keychainSign.length%2 == 0) ? keychainSign.length/2 : (keychainSign.length/2 + 1);
            XOKeyChainKey = [keychainSign substringToIndex:halfIndex];
        }
    }
    return XOKeyChainKey;
}

+ (NSString *)getKeychainSignIv
{
    if (XOIsEmptyString(XOKeyChainIv)) {
        NSString *keychainSign = [XOBaseConfig defaultConfig].config.keyChainSign;
        if (keychainSign.length == 1) {
            XOKeyChainIv = keychainSign;
        } else {
            NSUInteger halfIndex = (keychainSign.length%2 == 0) ? keychainSign.length/2 : (keychainSign.length/2 + 1);
            XOKeyChainIv = [keychainSign substringFromIndex:halfIndex];
        }
    }
    return XOKeyChainIv;
}

#pragma mark ====================== 对数据加解密处理 ======================

/** @brief 对字符串加密处理
 *  @param param 要加密的字符串
 */
+ (NSString *_Nullable)encryptString:(nonnull NSString *)param
{
    if (XOIsEmptyString(param)) {
        return nil;
    }
    NSString *encrypt = [param aes128_encrypto:[XOKeyChainTool getKeychainSignKey] iv:[XOKeyChainTool getKeychainSignIv]];
    return encrypt;
}

/** @brief 对字符串解密处理
 *  @param param 要解密的字符串
 */
+ (NSString *_Nullable)decryptString:(nonnull NSString *)param
{
    if (XOIsEmptyString(param)) {
        return nil;
    }
    NSString *decrypt = [param aes128_decrypto:[XOKeyChainTool getKeychainSignKey] iv:[XOKeyChainTool getKeychainSignIv]];
    decrypt = [decrypt stringByTrimmingCharactersInSet:[NSCharacterSet  controlCharacterSet]];
    return decrypt;
}


#pragma mark ====================== 存取删 =======================

#pragma mark == token

// 存token
+ (void)saveToken:(NSString * _Nonnull)token
{
    if (!XOIsEmptyString(token)) {
        NSString *encrypt = [XOKeyChainTool encryptString:token];
        [XOKeyChainTool addKeychainData:encrypt forKey:XOAppAuthorTokenKey];
    } else {
        NSLog(@"token为空 ,保存失败");
    }
}
// 取token
+ (NSString * _Nullable)getToken
{
    NSString *encrypt = (NSString *)[XOKeyChainTool getKeychainDataForKey:XOAppAuthorTokenKey];
    return [XOKeyChainTool decryptString:encrypt];
}
// 删除token
+ (void)clearToken
{
    [XOKeyChainTool deleteKeychainDataForKey:XOAppAuthorTokenKey];
}

#pragma mark == username & password

// 存登录用户名和密码
+ (void)saveAppUserName:(NSString * _Nonnull)userName password:(NSString * _Nonnull)password
{
    if (!XOIsEmptyString(userName)) {
        NSString *usernameEncrypt = [XOKeyChainTool encryptString:userName];
        [XOKeyChainTool addKeychainData:usernameEncrypt forKey:XOAppLoginUserName];
    } else {
        NSLog(@"userName为空 ,保存失败");
    }
    
    if (!XOIsEmptyString(password)) {
        NSString *passwordEncrypt = [XOKeyChainTool encryptString:password];
        [XOKeyChainTool addKeychainData:passwordEncrypt forKey:XOAppLoginPassWord];
    } else {
        NSLog(@"password为空 ,保存失败");
    }
}
// 取登录用户名
+ (NSString * _Nullable)getUserName
{
    NSString *usernameEncrypt = (NSString *)[XOKeyChainTool getKeychainDataForKey:XOAppLoginUserName];
    return [XOKeyChainTool decryptString:usernameEncrypt];
}
// 取登录密码
+ (NSString * _Nullable)getPassword
{
    NSString *passwordEncrypt = (NSString *)[XOKeyChainTool getKeychainDataForKey:XOAppLoginPassWord];
    return [XOKeyChainTool decryptString:passwordEncrypt];
}

// 删除登录用户名和密码
+ (void)clearAppLoginInfo
{
    [XOKeyChainTool deleteKeychainDataForKey:XOAppLoginUserName];
    [XOKeyChainTool deleteKeychainDataForKey:XOAppLoginPassWord];
}

// 退出登录, 清除所有相关数据
+ (void)loginOut
{
    [XOKeyChainTool clearToken];
    [XOKeyChainTool clearAppLoginInfo];
}



@end
