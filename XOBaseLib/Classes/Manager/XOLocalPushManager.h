//
//  XOLocalPushManager.h
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface XOLocalPushManager : NSObject

// 系统新消息铃声
+ (SystemSoundID)playNewMessageSound;

// 振动
+ (void)playVibration;

// 显示推送消息
+ (void)showNotificationWithMessage:(NSString *)notiContent;

// 显示呼叫消息
+ (void)showNotificationWithCall:(NSDictionary *)callInfo;

@end

NS_ASSUME_NONNULL_END
