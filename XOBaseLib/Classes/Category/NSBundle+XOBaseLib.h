//
//  NSBundle+XOBaseLib.h
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define XOLocalizedString(key) ([NSBundle xo_localizedStringForKey:(key)])

@interface NSBundle (XOBaseLib)

+ (NSBundle *)xo_baseLibBundle;
+ (NSBundle *)xo_baseLibResourceBundle;
+ (NSString *)xo_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)xo_localizedStringForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
