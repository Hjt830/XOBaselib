//
//  XOUserDefault.m
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import "XOUserDefault.h"
#import "XOMacro.h"
#import "XOBaseConfig.h"
#import "NSString+XOExtension.h"

static NSString * const KSaveKey = @"param";       // 参数
static NSString * const KTimeKey = @"timeStamp";   // 时间戳


#define XOUF    [NSUserDefaults standardUserDefaults]


@interface XOUserDefault ()
{
    NSString    *_AesSignKey;
}
@end

static XOUserDefault * __userDefault = nil;

@implementation XOUserDefault

/// 获取单例对象
+ (instancetype _Nullable )standraDefault
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __userDefault = [[XOUserDefault alloc] init];
    });
    return __userDefault;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _AesSignKey = [[XOBaseConfig defaultConfig].config.localStorageSign lowerMD5String_32];
    }
    return self;
}

#pragma mark ====================== 对数据加解密处理 ======================

/** @brief 对字符串加密处理
 *  @param param 要加密的字符串
 */
- (NSString *_Nullable)encryptString:(nonnull NSString *)param
{
    if (XOIsEmptyString(param)) {
        return nil;
    }
    NSDictionary *localDict = @{KSaveKey : param, KTimeKey : [NSDate date]};
    NSData *data = [NSJSONSerialization dataWithJSONObject:localDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *encryptParam = [json aes128_encrypto:[_AesSignKey substringToIndex:16] iv:[_AesSignKey substringFromIndex:16]];
    return encryptParam;
}

/** @brief 对字符串解密处理
 *  @param param 要解密的字符串
 */
- (NSString *_Nullable)decryptString:(nonnull NSString *)param
{
    if (XOIsEmptyString(param)) {
        return nil;
    }
    NSString *decryptParam = [param aes128_decrypto:[_AesSignKey substringToIndex:16] iv:[_AesSignKey substringFromIndex:16]];
    // 去掉空格
    decryptParam = [decryptParam stringByTrimmingCharactersInSet:[NSCharacterSet  controlCharacterSet]];
    NSData *data = [decryptParam dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        XOLog(@"取值失败: %@", error);
        return nil;
    }
    NSString *decrypt = [dict valueForKey:KSaveKey];
    return decrypt;
}



#pragma mark ====================== 自定义保存 ======================

/** @brief 保存自定义数据
 *  @param data 要保存的数据(类型必须为NSString、NSArray、NSDictionary...，或者实现了<NSCoding>协议的自定义数据类型)
 *  @param key  保存的数据对应的key
 */
- (void)saveCustomData:(id _Nonnull)data withKey:(NSString * _Nonnull)key
{
    if (!data || [data isEqual:[NSNull null]]) {
        XOLog(@"data不能为空 key:%@", key);
        return;
    }
    if (![data conformsToProtocol:@protocol(NSCoding)]) {
        XOLog(@"data未实现NSCoding协议，不能保存  key:%@", key);
        return;
    }
    if (XOIsEmptyString(key)) {
        XOLog(@"key不能为空");
        return;
    }
    // 处理字典中的一些空值null
    data = [self handlerData:data];
    
    [XOUF setObject:data forKey:[key lowerMD5String_32]];
    [XOUF synchronize];
}

/** @brief 获取自定义保存的数据
 *  @param key 对应的key
 */
- (id)getCustomData:(NSString * _Nonnull)key
{
    if (XOIsEmptyString(key)) {
        XOLog(@"key不能为空");
        return nil;
    }
    
    id data = [XOUF objectForKey:[key lowerMD5String_32]];
    return data;
}

/// 清除自定义保存的数据
- (void)clearCustomData:(NSString * _Nonnull)key
{
    if (XOIsEmptyString(key)) {
        XOLog(@"key不能为空");
        return;
    }
    
    [XOUF removeObjectForKey:[key lowerMD5String_32]];
    [XOUF synchronize];
}

#pragma mark ================ help ================

- (id)handlerData:(id)data
{
    // 处理字典中的一些空值
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dict = [(NSDictionary *)data mutableCopy];
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isEqual:[NSNull null]]) {
                [dict setValue:nil forKey:key];
            }
            else if ([obj isKindOfClass:[NSDictionary class]]) {
                id value = [self handlerData:obj];
                [dict setValue:value forKey:key];
            }
        }];
        
        return dict;
    }
    return data;
}

@end
