//
//  JTFileManager.h
//  JTMainProject
//
//  Created by kenter on 2019/7/1.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTMacro.h"
#import "JTKeyChainTool.h"
#import "NSString+JTExtension.h"

NS_ASSUME_NONNULL_BEGIN

///////////////////////////////////////////////////////////////////
/////////////////////////// app文件管理器 ///////////////////////////
///////////////////////////////////////////////////////////////////


#define JTFM [NSFileManager defaultManager]

// 消息类型定义
typedef NS_ENUM(NSInteger, JTMsgFileType) {
    JTMsgFileTypeImage      = 0x0,
    JTMsgFileTypeAudio      = 0x1,
    JTMsgFileTypeVideo      = 0x2,
    JTMsgFileTypeLocation   = 0x3,
    JTMsgFileTypeFile       = 0x4,
};

// 沙盒Document路径
FOUNDATION_STATIC_INLINE NSString *DocumentDirectory() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

// 沙盒Library路径
FOUNDATION_STATIC_INLINE NSString *LibraryDirectory() {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

#pragma mark ========================= 设置相关 =========================

// 用户设置文件路径
FOUNDATION_STATIC_INLINE NSString * JTFileUserSettingPath() {
    NSString *path = @"/user/setting";
    NSString *userSettingPath = [DocumentDirectory() stringByAppendingPathComponent:path];
    // 判断目录是否存在，不存在就创建目录
    BOOL isDirectory = NO;
    BOOL isExist = [JTFM fileExistsAtPath:userSettingPath isDirectory:&isDirectory];
    if (!(isDirectory && isExist)) {
        NSError *error = nil;
        BOOL isCreate = [JTFM createDirectoryAtPath:userSettingPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!isCreate) {
            NSLog(@"文件路径创建失败: %@", userSettingPath);
        }
    }
    // 用户设置文件名
    NSString *settingFile = @"JTUserSetting.plist";
    userSettingPath = [userSettingPath stringByAppendingPathComponent:settingFile];
    
    return userSettingPath;
}

// 系统设置文件路径
FOUNDATION_STATIC_INLINE NSString *JTFileDefaultSettingPath() {
    return  [[NSBundle mainBundle] pathForResource:@"JTDefaultSetting" ofType:@"plist"];
}

#pragma mark ========================= 消息相关 =========================

// 当前用户
FOUNDATION_STATIC_INLINE NSString * CurrentUserPath() {
    NSString *userId = [JTKeyChainTool getUserName];
    return [userId upperMD5String_32];
}

/**
 *  创建并返回不同消息对应的文件的存储目录
 *  Image:      Document/message/MD5(currentUserId)/Image
 *  Audio:      Document/message/MD5(currentUserId)/Audio
 *  Video:      Document/message/MD5(currentUserId)/Video
 *  Location:   Document/message/MD5(currentUserId)/Location
 *  File:       Document/message/MD5(currentUserId)/File
 */
FOUNDATION_STATIC_INLINE NSString * WXMsgFileDirectory(enum JTMsgFileType msgType) {
    NSString *directory = [[DocumentDirectory() stringByAppendingPathComponent:@"message"] stringByAppendingString:CurrentUserPath()];
    switch (msgType) {
        case JTMsgFileTypeImage:
            directory = [directory stringByAppendingString:@"Image"];
            break;
        case JTMsgFileTypeAudio:
            directory = [directory stringByAppendingString:@"Audio"];
            break;
        case JTMsgFileTypeVideo:
            directory = [directory stringByAppendingString:@"Video"];
            break;
        case JTMsgFileTypeLocation:
            directory = [directory stringByAppendingString:@"Location"];
            break;
        case JTMsgFileTypeFile:
            directory = [directory stringByAppendingString:@"File"];
            break;
        default:
            break;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 判断路径是否存在
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:directory isDirectory:&isDir];
    if (!(isDirExist && isDir)) {
        // 不存在则创建路径
        BOOL result = [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
        if(!result){
            NSLog(@"创建(JTMsgFileType)目录失败!!!!!");
        }
    }
    
    return directory;
}

// 返回不同消息对应的文件后缀名
FOUNDATION_STATIC_INLINE NSString * JTMsgMimeName(enum JTMsgFileType msgType) {
    NSString *mime = nil;
    switch (msgType) {
        case JTMsgFileTypeImage:
            mime = @".png";
            break;
        case JTMsgFileTypeAudio:
            mime = @".amr";
            break;
        case JTMsgFileTypeVideo:
            mime = @".mp4";
            break;
        case JTMsgFileTypeLocation:
            mime = @".png";
            break;
        case JTMsgFileTypeFile:
            mime = @".*";
            break;
        default:
            break;
    }
    return mime;
}

@interface JTFileManager : NSObject

@end

NS_ASSUME_NONNULL_END
