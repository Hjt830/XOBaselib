//
//  UIImage+XOBaseLib.m
//  AFNetworking
//
//  Created by kenter on 2019/8/15.
//

#import "UIImage+XOBaseLib.h"
#import "XOSettingManager.h"

@implementation UIImage (XOBaseLib)

+ (UIImage *)xoBase_1xImageNamed:(NSString *)name
{
    NSBundle *imageBundle = [XOSettingManager defaultManager].baseBundle;
    NSString *imagePath = [imageBundle pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

+ (UIImage *)xoBase_2xImageNamed:(NSString *)name
{
    NSBundle *imageBundle = [XOSettingManager defaultManager].baseBundle;
    name = [name stringByAppendingString:@"@2x"];
    NSString *imagePath = [imageBundle pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

+ (UIImage *)xoBase_3xImageNamed:(NSString *)name
{
    NSBundle *imageBundle = [XOSettingManager defaultManager].baseBundle;
    name = [name stringByAppendingString:@"@3x"];
    NSString *imagePath = [imageBundle pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

// 读取资源包图片
+ (UIImage *)xo_imageNamedFromBaseBundle:(NSString *)name
{
    // 根据设备分辨率选择图片
    CGFloat scale = [UIScreen mainScreen].scale;
    if (scale >= 3.0) {
        // 取三倍图
        UIImage *image = [UIImage xoBase_3xImageNamed:name];
        
        if (nil == image) {
            // 没有三倍图, 取二倍图
            image = [UIImage xoBase_2xImageNamed:name];
            
            if (nil == image) {
                // 没有二倍图, 取一倍图
                image = [UIImage xoBase_1xImageNamed:name];
            }
        }
        
        return image;
    }
    else if (scale >= 2.0) {
        // 取二倍图
        UIImage *image = [UIImage xoBase_2xImageNamed:name];
        
        if (nil == image) {
            // 没有二倍图, 取一倍图
            image = [UIImage xoBase_1xImageNamed:name];
            
            if (nil == image) {
                // 没有一倍图, 取三倍图
                image = [UIImage xoBase_1xImageNamed:name];
            }
        }
        
        return image;
    }
    else {
        // 取一倍图
        UIImage *image = [UIImage xoBase_1xImageNamed:name];
        
        if (nil == image) {
            // 没有一倍图, 取二倍图
            image = [UIImage xoBase_2xImageNamed:name];
            
            if (nil == image) {
                // 没有二倍图, 取三倍图
                image = [UIImage xoBase_3xImageNamed:name];
            }
        }
        
        return image;
    }
}

@end
