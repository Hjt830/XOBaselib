//
//  NSBundle+XOBaseLib.h.m
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import "NSBundle+XOBaseLib.h"
#import "XOSettingManager.h"
#import "XOBaseConfig.h"

@implementation NSBundle (XOBaseLib)

+ (NSBundle *)xo_baseLibBundle
{
    NSBundle *bundle = [NSBundle bundleForClass:[XOBaseConfig class]];
    NSURL *url = [bundle URLForResource:@"XOBaseLib" withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    return bundle;
}

+ (NSBundle *)xo_baseLibResourceBundle
{
    NSBundle *bundle = [NSBundle xo_baseLibBundle];
    NSURL *url = [bundle URLForResource:@"XOBaseLib" withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
}

+ (NSString *)xo_localizedStringForKey:(NSString *)key value:(NSString *)value
{
    NSBundle *bundle = [XOSettingManager defaultManager].languageBundle;
    NSString *value1 = [bundle localizedStringForKey:key value:value table:nil];
    return value1;
}

+ (NSString *)xo_localizedStringForKey:(NSString *)key
{
    return [NSBundle xo_localizedStringForKey:key value:@""];
}


@end
