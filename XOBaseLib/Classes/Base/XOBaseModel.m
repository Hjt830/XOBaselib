//
//  XOBaseModel.m
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import "XOBaseModel.h"
#import <objc/runtime.h>

@implementation XOBaseModel

#pragma mark ========================= NSCoding =========================

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        //获取属性 key、value
        NSString *key = [[NSString alloc] initWithCString:property_getName(propertyList[i]) encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:key];
        // encode
        [aCoder encodeObject:value forKey:key];
    }
    free(propertyList);
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        unsigned int count;
        objc_property_t *propertyList = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++) {
            objc_property_t property = propertyList[i];
            //获取属性名
            const char *name = property_getName(property);
            NSString *key = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
            // decode
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(propertyList);
    }
    
    return self;
}

#pragma mark ========================= NSCoping =========================

- (id)copyWithZone:(nullable NSZone *)zone
{
    XOBaseModel *copy = [[[self class] allocWithZone:NULL] init];
    
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        //获取属性名
        const char *name = property_getName(property);
        NSString *key = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
        // decode
        id value = [self valueForKey:key];
        [copy setValue:value forKey:key];
    }
    free(propertyList);
    
    return copy;
}

#pragma mark ========================= Description =========================

- (NSString *)description
{
    NSMutableString * descriptionStr = [[NSMutableString alloc] initWithFormat:@"[%@] ", NSStringFromClass([self class])];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        const char *name = ivar_getName(ivars[i]);
        NSString *key = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:key];
        // 设置到成员变量身上
        [descriptionStr appendFormat:@"{%@:%@},",key,value];
    }
    free(ivars);
    
    return descriptionStr;
}

#pragma mark ====================== 实现KVC的异常方法，防止出现崩溃 ======================


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"key = %@ value= %@", key, value);
}

- (id)valueForUndefinedKey:(NSString *)key
{
    NSLog(@"key = %@", key);
    return nil;
}

- (void)setNilValueForKey:(NSString *)key
{
    NSLog(@"key = %@", key);
}

@end
