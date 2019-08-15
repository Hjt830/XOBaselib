//
//  UIImage+XOBaseLib.h
//  AFNetworking
//
//  Created by kenter on 2019/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (XOBaseLib)

// 读取资源包图片
+ (UIImage *)xo_imageNamedFromBaseBundle:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
