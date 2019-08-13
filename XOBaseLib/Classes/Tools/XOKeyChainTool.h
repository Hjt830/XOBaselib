//
//  XOKeyChainTool.h
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/************** 一些机密数据存储key ***************/

// App的token存储key
extern NSString * const XOAppAuthorTokenKey;

// App登录用户名(手机号码/邮箱)存储key
extern NSString * const XOAppLoginUserName;

// App登录密码存储key
extern NSString * const XOAppLoginPassWord;

/********************* end ********************/





///////////////////////////////////////////////////////////////////
//////////////////////// 保存秘钥数据到钥匙串中 ///////////////////////
///////////////////////////////////////////////////////////////////

@interface XOKeyChainTool : NSObject

/// 添加数据
+ (void)addKeychainData:(id)data forKey:(NSString *)key;

/// 根据key获取相应的数据
+ (id)getKeychainDataForKey:(NSString *)key;

/// 删除数据
+ (void)deleteKeychainDataForKey:(NSString *)key;


#pragma mark ========================= 存取删 =========================

// 存取token
+ (void)saveToken:(NSString * _Nonnull)token;
+ (NSString * _Nullable)getToken;
// 删除session
+ (void)clearToken;


// 存取登录用户名和密码
+ (void)saveAppUserName:(NSString * _Nonnull)userName password:(NSString * _Nonnull)password;
+ (NSString * _Nullable)getUserName;
+ (NSString * _Nullable)getPassword;
// 删除登录用户名和密码
+ (void)clearAppLoginInfo;


// 退出登录, 清除相关数据
+ (void)loginOut;


@end

NS_ASSUME_NONNULL_END
