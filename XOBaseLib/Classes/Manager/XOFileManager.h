//
//  XOFileManager.h
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XOMacro.h"
#import "XOKeyChainTool.h"
#import "NSString+XOExtension.h"
#import "NSBundle+XOBaseLib.h"

NS_ASSUME_NONNULL_BEGIN

///////////////////////////////////////////////////////////////////
/////////////////////////// app文件管理器 ///////////////////////////
///////////////////////////////////////////////////////////////////


#define XOFM [NSFileManager defaultManager]

// 消息类型定义
typedef NS_ENUM(NSInteger, XOMsgFileType) {
    XOMsgFileTypeImage      = 0x0,
    XOMsgFileTypeAudio      = 0x1,
    XOMsgFileTypeVideo      = 0x2,
    XOMsgFileTypeLocation   = 0x3,
    XOMsgFileTypeFile       = 0x4,
};

// 沙盒Document路径
FOUNDATION_STATIC_INLINE NSString *DocumentDirectory() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

// 沙盒Library路径
FOUNDATION_STATIC_INLINE NSString *LibraryDirectory() {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

// 用户设置文件夹
FOUNDATION_STATIC_INLINE NSString * XOUserSettingDirectory() {
    NSString *path = @"/user/setting";
    NSString *userSettingDirectory = [DocumentDirectory() stringByAppendingPathComponent:path];
    // 判断目录是否存在，不存在就创建目录
    BOOL isDirectory = NO;
    BOOL isExist = [XOFM fileExistsAtPath:userSettingDirectory isDirectory:&isDirectory];
    if (!(isDirectory && isExist)) {
        NSError *error = nil;
        BOOL isCreate = [XOFM createDirectoryAtPath:userSettingDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if (!isCreate) {
            NSLog(@"文件路径创建失败: %@", userSettingDirectory);
        }
    }
    
    return userSettingDirectory;
}

#pragma mark ========================= 设置相关 =========================

// 用户设置文件路径
FOUNDATION_STATIC_INLINE NSString * XOUserSettingFilePath() {
    // 用户设置文件名
    NSString *settingFile = @"XOUserSetting.plist";
    NSString *userSettingPath = [XOUserSettingDirectory() stringByAppendingPathComponent:settingFile];
    return userSettingPath;
}

// 系统设置文件路径
FOUNDATION_STATIC_INLINE NSString *XODefaultSettingFilePath() {
    return  [[NSBundle xo_baseLibBundle] pathForResource:@"XODefaultSetting" ofType:@"plist"];
}

#pragma mark ========================= 消息相关 =========================

// 当前用户
FOUNDATION_STATIC_INLINE NSString * CurrentUserPath() {
    NSString *userId = [XOKeyChainTool getUserName];
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
FOUNDATION_STATIC_INLINE NSString * XOMsgFileDirectory(enum XOMsgFileType msgType) {
    NSString *directory = [[DocumentDirectory() stringByAppendingPathComponent:@"message"] stringByAppendingString:CurrentUserPath()];
    switch (msgType) {
        case XOMsgFileTypeImage:
            directory = [directory stringByAppendingString:@"Image"];
            break;
        case XOMsgFileTypeAudio:
            directory = [directory stringByAppendingString:@"Audio"];
            break;
        case XOMsgFileTypeVideo:
            directory = [directory stringByAppendingString:@"Video"];
            break;
        case XOMsgFileTypeLocation:
            directory = [directory stringByAppendingString:@"Location"];
            break;
        case XOMsgFileTypeFile:
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
            NSLog(@"创建(XOMsgFileType)目录失败!!!!!");
        }
    }
    
    return directory;
}

// 返回不同消息对应的文件后缀名
FOUNDATION_STATIC_INLINE NSString * XOMsgMimeName(enum XOMsgFileType msgType) {
    NSString *mime = nil;
    switch (msgType) {
        case XOMsgFileTypeImage:
            mime = @".png";
            break;
        case XOMsgFileTypeAudio:
            mime = @".amr";
            break;
        case XOMsgFileTypeVideo:
            mime = @".mp4";
            break;
        case XOMsgFileTypeLocation:
            mime = @".png";
            break;
        case XOMsgFileTypeFile:
            mime = @".*";
            break;
        default:
            break;
    }
    return mime;
}

@interface XOFileManager : NSObject

+ (instancetype)shareInstance;

/**
 *  @brief 根据原图获取聊天页缩略图尺寸
 *  @param originImage 原图
 *  @return 返回缩略图尺寸
 */
- (CGSize)getScaleImageSize:(UIImage *)originImage;

/**
 *  @brief 根据原图获取缩略图
 *  @param originImage 原图
 *  @param scaleSize 缩略图尺寸
 */
- (UIImage *)scaleOriginImage:(UIImage *)originImage toSize:(CGSize)scaleSize;

@end

NS_ASSUME_NONNULL_END
