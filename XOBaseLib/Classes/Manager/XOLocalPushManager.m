//
//  XOLocalPushManager.m
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import "XOLocalPushManager.h"
#import "XOMacro.h"
#import "NSBundle+XOBaseLib.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


// 播放铃声完成的回调函数
void systemSoundFinishedPlayingCallback(SystemSoundID sound_id, void* user_data)
{
    AudioServicesDisposeSystemSoundID(sound_id);
}

@implementation XOLocalPushManager

// 系统新消息铃声
+ (SystemSoundID)playNewMessageSound
{
    // 默认播放三全音
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"sms-received1",@"caf"];
    NSURL * audioPath = [NSURL fileURLWithPath:path];
    // Path for the audio file
    //    NSURL *bundlePath = [[NSBundle mainBundle] URLForResource:@"EaseUIResource" withExtension:@"bundle"];
    //    NSURL *audioPath = [[NSBundle bundleWithURL:bundlePath] URLForResource:@"in" withExtension:@"caf"];
    
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(audioPath), &soundID);
    // Register the sound completion callback.
    AudioServicesAddSystemSoundCompletion(soundID,
                                          NULL, // uses the main run loop
                                          NULL, // uses kCFRunLoopDefaultMode
                                          systemSoundFinishedPlayingCallback, // the name of our custom callback function
                                          NULL // for user data, but we don't need to do that in this case, so we just pass NULL
                                          );
    
    AudioServicesPlaySystemSound(soundID);
    
    return soundID;
}

+ (void)playVibration
{
    // Register the sound completion callback.
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate,
                                          NULL, // uses the main run loop
                                          NULL, // uses kCFRunLoopDefaultMode
                                          systemSoundFinishedPlayingCallback, // the name of our custom callback function
                                          NULL // for user data, but we don't need to do that in this case, so we just pass NULL
                                          );
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (void)showNotificationWithMessage:(NSString *)notiContent
{
    if (@available(iOS 10, *)) {
        //触发推送方式，此处设置为5s后推送
        UNTimeIntervalNotificationTrigger *trigger =[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
        
        //创建通知的内容
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
        content.body = notiContent;
        UIApplication *application = [UIApplication sharedApplication];
        content.badge = @(++application.applicationIconBadgeNumber);
        content.sound = [UNNotificationSound defaultSound];
        NSError *error = nil;
        if (error) {
            NSLog(@"本地推送失败");
        }
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"request" content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"本地推送成功 ");
            }
        }];
    }
    else
    {
        UILocalNotification * localNotification = [[UILocalNotification alloc] init];
        //设置属性
        //发送的时间
        localNotification.fireDate = [NSDate new];
        //通知的标题
        if (@available(iOS 8.2, *)) {
            localNotification.alertTitle = XOLocalizedString(@"noti.newMsgTitle");  //IOS_8.2
        }
        //发送的内容
        localNotification.alertBody = notiContent;
        //通知的声音
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        //设置APP图标显示的消息数量
        UIApplication *application = [UIApplication sharedApplication];
        localNotification.applicationIconBadgeNumber = ++application.applicationIconBadgeNumber;
        //发送通知
        UIApplication * app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:localNotification];
    }
    
}


+ (void)showNotificationWithCall:(NSDictionary *)callInfo
{
    if (@available(iOS 10.0, *)) {
        //触发推送方式，此处设置为5s后推送
        UNTimeIntervalNotificationTrigger *trigger =[ UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
        
        //创建通知的内容
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
        content.body = XOLocalizedString(@"noti.newMsgContent");
        UIApplication *application = [UIApplication sharedApplication];
        content.badge = @(++application.applicationIconBadgeNumber);
        content.sound = [UNNotificationSound defaultSound];
        NSError *error = nil;
        if (error) {
            NSLog(@"本地推送失败");
        }
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"request" content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"本地推送成功");
            }
        }];
    }
    else
    {
        UILocalNotification * localNotification = [[UILocalNotification alloc] init];
        //设置属性
        //发送的时间
        localNotification.fireDate = [NSDate new];
        //通知的标题
        if (@available(iOS 8.2, *)) {
            localNotification.alertTitle = XOLocalizedString(@"noti.newMsgTitle");  //IOS_8.2
        }
        //发送的内容
        localNotification.alertBody = XOLocalizedString(@"noti.newMsgContent");
        //通知的声音
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        //设置APP图标显示的消息数量
        UIApplication *application = [UIApplication sharedApplication];
        localNotification.applicationIconBadgeNumber = ++application.applicationIconBadgeNumber;
        //发送通知
        UIApplication * app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:localNotification];
    }
}

@end
