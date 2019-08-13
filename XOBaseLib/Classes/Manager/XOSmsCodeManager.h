//
//  XOSmsCodeManager.h
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


///////////////////////////////////////////////////////////////////
/////////////////////////// app验证码管理器 /////////////////////////
///////////////////////////////////////////////////////////////////


typedef NS_ENUM(NSUInteger, HTSMSCodeType) {
    HTSMSCodeTypeRegist = 100,  // 注册验证码
    HTSMSCodeTypeForgot = 101,  // 忘记密码验证码
    HTSMSCodeTypeReset  = 102,  // 重置密码验证码
};

@class XOSMSCodeModel;
@interface XOSmsCodeManager : NSObject

+ (instancetype _Nonnull )defaultManager;

/** @brief 保存验证码
 *  @param smsCode 要保存的验证码数据
 */
- (void)saveSmsCode:(XOSMSCodeModel * _Nonnull)smsCode;

/** @brief 根据类型获取验证码数据
 *  @param smsCodeType 要获取的验证码数据的类型
 */
- (XOSMSCodeModel * _Nullable)getSmsCode:(HTSMSCodeType)smsCodeType;

@end




@interface XOSMSCodeModel : NSObject

// 验证码类型
@property (nonatomic, assign) HTSMSCodeType         codeType;
// 验证码手机
@property (nonatomic, copy) NSString                * _Nullable telphone;
// 发送时间
@property (nonatomic, assign) NSTimeInterval        sendTime;
// 发送ID
@property (nonatomic, copy) NSString                * _Nullable sendID;


@end

NS_ASSUME_NONNULL_END
