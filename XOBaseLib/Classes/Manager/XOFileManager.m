//
//  XOFileManager.m
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import "XOFileManager.h"

static float MAXScaleWidth = 150.0;     // 缩略图最大宽度
static float MAXScaleHeight = 240.0;    // 缩略图最大高度


static XOFileManager * __manager = nil;

@implementation XOFileManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[XOFileManager alloc] init];
    });
    return __manager;
}

/**
 *  @brief 根据原图获取聊天页缩略图尺寸
 *  @param originImage 原图
 *  @return 返回缩略图尺寸
 */
- (CGSize)getScaleImageSize:(UIImage *)originImage
{
    float width = originImage.size.width;
    float height = originImage.size.height;
    
    // 宽 < 高
    if (width < height) {
        float scaleHeight = MAXScaleHeight;
        float scaleWidth = (width * MAXScaleHeight)/height;
        return CGSizeMake(scaleWidth, scaleHeight);
    }
    // 高 < 宽
    else {
        float scaleWidth = MAXScaleWidth;
        float scaleHeight = (height * MAXScaleHeight)/width;
        return CGSizeMake(scaleWidth, scaleHeight);
    }
}

/**
 *  @brief 根据原图获取缩略图
 *  @param originImage 原图
 *  @param scaleSize 缩略图尺寸
 */
- (UIImage *)scaleOriginImage:(UIImage *)originImage toSize:(CGSize)scaleSize
{
    if (image.size.width > size.width) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaleImage;
    }
    else {
        return originImage;
    }
}

@end
