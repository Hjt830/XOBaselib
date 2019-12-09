//
//  UIColor+XOExtension.h
//  AFNetworking
//
//  Created by kenter on 2019/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (XOExtension)

+ (UIColor *)groupTableViewColor;

+ (UIColor *)XOTextColor;

+ (UIColor *)XOWhiteColor;

+ (UIColor *)XOBlackColor;


+ (UIColor *)hexColor:(NSString *)color;

@end

NS_ASSUME_NONNULL_END
