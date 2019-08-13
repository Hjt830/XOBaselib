//
//  NSString+XOExtension.h
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

#pragma mark ====================== MD5 =======================

/**
 *  @brief 获取32位小写MD5加密串
 */
- (NSString *)lowerMD5String_32;

/**
 *  @brief 获取32位大写MD5加密串
 */
- (NSString *)upperMD5String_32;

- (id)MD5;

/**
 *  @brief 获取字符串MD5加密串
 */
- (NSString *)md5String;

#pragma mark ====================== AES128 =======================

/** @brief aes 128位 CBC PKCS7Padding加密
 *  @param key 加密秘钥
 *  @param iv 加密向量
 */
- (NSString *)aes128_encrypto:(NSString *)key iv:(NSString *)iv;

/** @brief aes 128位 CBC PKCS7Padding解密
 *  @param key 解密秘钥
 *  @param iv 解密向量
 */
- (NSString *)aes128_decrypto:(NSString *)key iv:(NSString *)iv;
    

#pragma mark ====================== HMAC =======================

/**
 *  HMAC签名
 */
- (NSString *)hmacSHA256WithSecret:(NSString *)secret;


#pragma mark ====================== URLEncode =======================
// URL encode编码
- (NSString *)URLEncodedString;
// URL encode解码
- (NSString *)URLDecodedString;


#pragma mark ====================== 随机32位字符串 =======================

+ (NSString *)creatUUID;

#pragma mark ====================== 正则表达式 =======================

// 是否为纯中文
- (BOOL)isChinese;

// 是否包含中文
- (BOOL)includeChinese;

// 是否是邮箱
- (BOOL)isEmail;

// 是否是中国大陆手机号码
- (BOOL)isChinaPhoneNumber;

#pragma mark ====================== 中文转拼音 =======================

- (NSString *)convertToPinyin;

- (NSString *)pinyinString;



@end

NS_ASSUME_NONNULL_END
