//
//  XOUserDefault.h
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XOUserDefault : NSObject

/// 获取单例对象
+ (instancetype _Nullable )standraDefault;





#pragma mark ====================== 自定义保存 ======================

/** @brief 保存设备推送Token
 *  @param data 要保存的自定义数据(类型必须为BOOL、NSInteger、NSString、NSArray、NSDictionary...，或者实现了<NSCoding>协议的自定义数据类型)
 *  @param key  保存的数据对应的key
 */
- (void)saveCustomData:(id _Nonnull)data withKey:(NSString * _Nonnull)key;

/** @brief 获取自定义保存的数据
 *  @param key 对应的key
 */
- (id _Nullable )getCustomData:(NSString * _Nonnull)key;

/// 清除自定义保存的数据
- (void)clearCustomData:(NSString * _Nonnull)key;

@end

NS_ASSUME_NONNULL_END
