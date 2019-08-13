//
//  NSString+JTExtension.m
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import "NSString+XOExtension.h"
#import "XOMacro.h"
#import <CommonCrypto/CommonCrypto.h>
#import <GTMBase64/GTMBase64.h>

@implementation NSString (Extension)
    
#pragma mark ====================== MD5 =======================
    
/**
*  @brief 获取32位小写MD5加密串
*/
- (NSString *)lowerMD5String_32
{
    const char *origin_str = [self UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH];
    CC_MD5(origin_str, (uint)strlen(origin_str), digist);
    NSMutableString *outPutStr = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [outPutStr appendFormat:@"%02x", digist[i]];
    }
    return [outPutStr lowercaseString];
}

/**
 *  @brief 获取32位大写MD5加密串
 */
- (NSString *)upperMD5String_32
{
    const char *origin_str = [self UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH];
    CC_MD5(origin_str, (uint)strlen(origin_str), digist);
    NSMutableString *outPutStr = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [outPutStr appendFormat:@"%02x", digist[i]];
    }
    return [outPutStr uppercaseString];
}

- (id)MD5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (uint32_t)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (NSString *)md5String
{
    const char *cstring = self.UTF8String;
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstring, (CC_LONG)strlen(cstring), bytes);
    // 拼接
    NSMutableString *md5String = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5String appendFormat:@"%02x", bytes[i]];
    }
    return md5String;
}

#pragma mark ====================== AES128 =======================

/** @brief aes 128位 CBC PKCS7Padding加密
 *  @param key 加密秘钥
 *  @param iv 加密向量
 */
- (NSString *)aes128_encrypto:(NSString *)key iv:(NSString *)iv
{
    char keyPtr[kCCKeySizeAES128 + 1];  // C的数组有一位是空格
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = data.length;
    
    size_t bufferSize = data.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        NSString *encrypted = [GTMBase64 stringByEncodingData:resultData];
        //        JTLog(@"加密前:%@ \n加密后:%@", self, encrypted);
        
        return encrypted;
    }
    free(buffer);
    
    return nil;
}

/** @brief aes 128位 CBC nopadding解密
 *  @param key 解密秘钥
 *  @param iv 解密向量
 */
- (NSString *)aes128_decrypto:(NSString *)key iv:(NSString *)iv
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [GTMBase64 decodeData:[self dataUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptorStatus = CCCrypt(kCCDecrypt,
                                            kCCAlgorithmAES128,
                                            kCCOptionPKCS7Padding,
                                            keyPtr,
                                            kCCBlockSizeAES128,
                                            ivPtr,
                                            [data bytes],
                                            dataLength,
                                            buffer,
                                            bufferSize,
                                            &numBytesCrypted);
    
    if (cryptorStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        NSString *decrypted = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        //        JTLog(@"解密前:%@ \n解密后:%@", self, decrypted);
        
        return decrypted;
    }
    free(buffer);
    return nil;
}


#pragma mark ====================== HMAC =======================

/**
 *  HMAC签名
 */
- (NSString *)hmacSHA256WithSecret:(NSString *)secret
{
    const char *cKey  = [secret UTF8String];
    const char *cData = [self UTF8String];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    //关键部分
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    //将加密结果进行一次BASE64编码。
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];
    
    return hash;
}


#pragma mark ====================== URLEncode =======================

/**
 *  URLEecode
 */
- (NSString *)URLEncodedString
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

/**
 *  URLDecode
 */
- (NSString *)URLDecodedString
{
    return [self stringByRemovingPercentEncoding];
}


#pragma mark ====================== 随机32位字符串 =======================

+ (NSString *)creatUUID
{
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (__bridge NSString *)CFStringCreateCopy(NULL, uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

#pragma mark ====================== 正则表达式 =======================

// 是否为纯中文
- (BOOL)isChinese
{
    if (XOIsEmptyString(self)) return NO;
    
    NSString *match = @"(^[\u4e00-\u9fff]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

// 是否包含中文
- (BOOL)includeChinese
{
    if (XOIsEmptyString(self)) return NO;
    
    for(int i = 0; i < [self length]; i++)
    {
        int a =[self characterAtIndex:i];
        if( a > 0x4e00 && a <0x9fff){
            return YES;
        }
    }
    return NO;
}

// 是否是邮箱
- (BOOL)isEmail
{
    if (XOIsEmptyString(self)) return NO;
    
    NSString *match = @"(\\w[-\\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\\.)+[A-Za-z]{2,14})";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

// 是否是中国大陆手机号码
- (BOOL)isChinaPhoneNumber
{
    if (XOIsEmptyString(self)) return NO;
    
    NSString *match = @"(0?(13|14|15|16|17|18|19)[0-9]{9})";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

#pragma mark ====================== 中文转拼音 =======================

- (NSString *)convertToPinyin
{
    if (XOIsEmptyString(self)) return nil;
    
    NSMutableString * pinYin = [[NSMutableString alloc]initWithString:self];
    //1.先转换为带声调的拼音
    if(CFStringTransform((__bridge CFMutableStringRef)pinYin, NULL, kCFStringTransformMandarinLatin, NO)) {
        JTLog(@"带声调的pinyin: %@", pinYin);
    }
    //2.再转换为不带声调的拼音
    if (CFStringTransform((__bridge CFMutableStringRef)pinYin, NULL, kCFStringTransformStripDiacritics, NO)) {
        JTLog(@"不带声调的pinyin: %@", pinYin);
    }
    //3.去除掉首尾的空白字符和换行字符
    NSString * pinYinStr = [pinYin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //4.去除掉其它位置的空白字符和换行字符
    pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    //5.首字母大写
    [pinYinStr capitalizedString];
    JTLog(@"最终的拼音: %@", pinYinStr);
    
    return pinYinStr;
}

// 中文转拼音
- (NSString *)pinyinString
{
    if ([self isChinese] || [self includeChinese]) {
        NSMutableString *str = [self mutableCopy];
        CFStringTransform(( CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
        NSString *pinyin = [[str stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
        return pinyin;
    }
    return [self lowercaseString];
}


@end
