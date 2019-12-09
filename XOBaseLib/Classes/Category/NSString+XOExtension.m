//
//  NSString+XOExtension.m
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import "NSString+XOExtension.h"
#import "XOMacro.h"
#import <CommonCrypto/CommonCrypto.h>
#import <GTMBase64/GTMBase64.h>
#import "sys/utsname.h"
#include "stdio.h"

@implementation NSString (XOExtension)
    
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
- (NSString * _Nullable)aes128_encrypto:(NSString *)key iv:(NSString *)iv
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
        //        XOLog(@"加密前:%@ \n加密后:%@", self, encrypted);
        
        return encrypted;
    }
    free(buffer);
    
    return nil;
}

/** @brief aes 128位 CBC nopadding解密
 *  @param key 解密秘钥
 *  @param iv 解密向量
 */
- (NSString * _Nullable)aes128_decrypto:(NSString *)key iv:(NSString *)iv
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
        //        XOLog(@"解密前:%@ \n解密后:%@", self, decrypted);
        
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
    CFStringRef res = CFStringCreateCopy(NULL, uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    NSString *result = (__bridge NSString *)res;
    CFRelease(res);
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

- (NSString * _Nullable)convertToPinyin
{
    if (XOIsEmptyString(self)) return nil;
    
    NSMutableString * pinYin = [[NSMutableString alloc]initWithString:self];
    //1.先转换为带声调的拼音
    if(CFStringTransform((__bridge CFMutableStringRef)pinYin, NULL, kCFStringTransformMandarinLatin, NO)) {
        XOLog(@"带声调的pinyin: %@", pinYin);
    }
    //2.再转换为不带声调的拼音
    if (CFStringTransform((__bridge CFMutableStringRef)pinYin, NULL, kCFStringTransformStripDiacritics, NO)) {
        XOLog(@"不带声调的pinyin: %@", pinYin);
    }
    //3.去除掉首尾的空白字符和换行字符
    NSString * pinYinStr = [pinYin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //4.去除掉其它位置的空白字符和换行字符
    pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    //5.首字母大写
    [pinYinStr capitalizedString];
    XOLog(@"最终的拼音: %@", pinYinStr);
    
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

// 十进制数字转十六进制字符串
- (NSString *)stringWithHexNumber:(NSUInteger)hexNumber
{
    char hexChar[6];
    sprintf(hexChar, "%x", (int)hexNumber);
    NSString *hexString = [NSString stringWithCString:hexChar encoding:NSUTF8StringEncoding];
    return hexString;
}
// 十六进制字符串转十进制数字
- (NSInteger)numberWithHexString:(NSString *)hexString
{
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (NSInteger)hexNumber;
}

#pragma mark ========================= 获取设备名称 =========================

/**
 *  设备版本
 *
 *  @return e.g. iPhone 5S
 */
+ (NSString *)getDeviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"] ||
        [deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"] ||
        [deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"] ||
        [deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"] ||
        [deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"] ||
        [deviceString isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,8"])    return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"])    return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"] ||
        [deviceString isEqualToString:@"iPhone11,6"])    return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone12,1"])    return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])    return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])    return @"iPhone 11 Pro Max";
    
    //iPod touch
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([deviceString isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    if ([deviceString isEqualToString:@"iPod9,1"])      return @"iPod Touch 7G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"] ||
        [deviceString isEqualToString:@"iPad4,2"] ||
        [deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"] ||
        [deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"] ||
        [deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro (9.7-inch)";
    if ([deviceString isEqualToString:@"iPad6,7"] ||
        [deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro (12.9-inch)";
    if ([deviceString isEqualToString:@"iPad6,11"] ||
        [deviceString isEqualToString:@"iPad6,12"])     return @"iPad 5";
    if ([deviceString isEqualToString:@"iPad7,1"] ||
        [deviceString isEqualToString:@"iPad7,2"])      return @"iPad Pro 2 (12.9-inch)";
    if ([deviceString isEqualToString:@"iPad7,3"] ||
        [deviceString isEqualToString:@"iPad7,4"])      return @"iPad Pro (10.5-inch)";
    if ([deviceString isEqualToString:@"iPad7,5"] ||
        [deviceString isEqualToString:@"iPad7,6"])      return @"iPad 6";
    if ([deviceString isEqualToString:@"iPad8,1"] ||
        [deviceString isEqualToString:@"iPad8,2"] ||
        [deviceString isEqualToString:@"iPad8,3"] ||
        [deviceString isEqualToString:@"iPad8,4"])      return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,7"] ||
        [deviceString isEqualToString:@"iPad8,8"])      return @"iPad Pro 3 (12.9-inch)";
    if ([deviceString isEqualToString:@"iPad11,3"] ||
        [deviceString isEqualToString:@"iPad11,4"])      return @"iPad Air 2";
    
    
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    if ([deviceString isEqualToString:@"iPad4,4"] ||
        [deviceString isEqualToString:@"iPad4,5"] ||
        [deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"] ||
        [deviceString isEqualToString:@"iPad4,8"] ||
        [deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"] ||
        [deviceString isEqualToString:@"iPad5,2"])      return @"iPad mini 4";
    if ([deviceString isEqualToString:@"iPad11,1"] ||
        [deviceString isEqualToString:@"iPad11,2"])     return @"iPad mini 4";
    
    return deviceString;
}

@end
