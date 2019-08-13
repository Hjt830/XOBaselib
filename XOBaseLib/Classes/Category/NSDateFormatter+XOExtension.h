//
//  NSDateFormatter+XOExtension.h
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter (XOExtension)

+ (instancetype)dateFormatter;

+ (instancetype)dateFormatterWithFormat:(NSString *)dateFormat;

+ (instancetype)defaultDateFormatter;/*yyyy-MM-dd HH:mm:ss*/

@end

NS_ASSUME_NONNULL_END
