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

@end
