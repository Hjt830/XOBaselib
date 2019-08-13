//
//  NSDateFormatter+XOExtension.m
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import "NSDateFormatter+XOExtension.h"

@implementation NSDateFormatter (XOExtension)

+ (instancetype)dateFormatter
{
    return [[self alloc] init];
}

+ (instancetype)dateFormatterWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[self alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

+ (instancetype)defaultDateFormatter
{
    return [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

@end
