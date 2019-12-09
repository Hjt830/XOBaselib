//
//  UIColor+XOExtension.m
//  AFNetworking
//
//  Created by kenter on 2019/11/19.
//

#import "UIColor+XOExtension.h"


@implementation UIColor (XOExtension)

+ (UIColor *)groupTableViewColor
{
    __block UIColor *backgroundColor = nil;
    if (@available(iOS 13.0, *)) {
        backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor systemBackgroundColor];
            } else {
                return [UIColor groupTableViewBackgroundColor];
            }
        }];
    }
    else {
        backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return backgroundColor;
}

+ (UIColor *)XOTextColor
{
    __block UIColor *textColor = nil;
    if (@available(iOS 13.0, *)) {
        textColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor whiteColor];
            } else {
                return [UIColor blackColor];
            }
        }];
    }
    else {
        textColor = [UIColor blackColor];
    }
    return textColor;
}

+ (UIColor *)XOWhiteColor
{
    __block UIColor *whiteColor = nil;
    if (@available(iOS 13.0, *)) {
        whiteColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor blackColor];
            } else {
                return [UIColor whiteColor];
            }
        }];
    }
    else {
        whiteColor = [UIColor whiteColor];
    }
    return whiteColor;
}

+ (UIColor *)XOBlackColor
{
    __block UIColor *blackColor = nil;
    if (@available(iOS 13.0, *)) {
        blackColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor whiteColor];
            } else {
                return [UIColor blackColor];
            }
        }];
    }
    else {
        blackColor = [UIColor blackColor];
    }
    return blackColor;
}




+ (UIColor *)hexColor:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
