//
//  NSBundle+XOBaseLib.h
//  JTMainProject
//
//  Created by kenter on 2019/7/1.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (XOBaseLib)

+ (NSBundle *)jt_baseLibBundle;
+ (NSString *)jt_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)jt_localizedStringForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
