//
//  XOHttpTool.m
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import "XOHttpTool.h"
#import "XOMacro.h"
#import "XOKeyChainTool.h"
#import <AFNetworking/AFNetworking.h>
#import "sys/utsname.h"

@interface XOHttpTool ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) NSMutableArray <NSURLSessionTask *> *taskArray;

@end

static XOHttpTool *__httpTool = nil;

@implementation XOHttpTool

/// 单例对象
+ (instancetype)shareTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __httpTool = [[XOHttpTool alloc] init];
    });
    return __httpTool;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        NSLog(@"requestSerializer: %@", _manager.requestSerializer.HTTPRequestHeaders);
        
        _manager.requestSerializer.timeoutInterval = 10.0f;  // 设置超时时间为10s
        [_manager.requestSerializer setValue:@"3" forHTTPHeaderField:@"_app_request"];
        if (!XOIsEmptyString([self deviceVersion])) {
            [_manager.requestSerializer setValue:@"iPhone X" forHTTPHeaderField:@"_app_request_name"];
        }
        if (!XOIsEmptyString([XOKeyChainTool getToken])) {
            [_manager.requestSerializer setValue:[XOKeyChainTool getToken] forHTTPHeaderField:@"_token"];
        }
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        
        // 初始化任务数组
        _taskArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark ====================== POST请求 =======================

/** @brief 发起一个POST请求，并异步返回
 *  @param url 请求的地址
 *  @param parameters 请求参数
 *  @param successBlock 请求成功的回调
 *  @param failBlock 请求失败的回调
 */
- (void)POST:(nonnull NSString *)url
  parameters:(id _Nullable)parameters
     success:(void(^ _Nullable)(NSDictionary * _Nullable responseDictionary, NSData * _Nullable data))successBlock
        fail:(void(^ _Nullable)(NSError * _Nullable error))failBlock
{
    if (XOIsEmptyString(url)) {
        NSLog(@"url is empty...");
        return;
    }
    
    // 对请求地址URLEncode编码处理
    NSString *requestUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"请求地址: %@", requestUrl);
    NSLog(@"请求参数: %@", parameters);
    
    NSURLSessionDataTask *postTask = [self.manager POST:requestUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 从任务列表中移除该请求任务
        @synchronized (self) {
            [self.taskArray removeObject:task];
        }
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSError *jsonError = nil;
            id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError) {
                NSLog(@"解析失败: %@", jsonError);
                if (failBlock) {
                    failBlock (jsonError);
                }
            }
            else {
                int code = [[response valueForKey:@"code"] intValue];
                if (JTHttpSuccessCode != code) {
                    if (failBlock) {
                        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:@{@"session": @"session已经过期"}];
                        failBlock (error);
                    }
                }
                else {
                    NSLog(@"请求成功:%@ --- responseObject: \n%@", url, response);
                    if (successBlock) {
                        successBlock (response, responseObject);
                    }
                }
            }
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"请求成功:%@ --- responseObject: \n%@", url, responseObject);
            if (successBlock) {
                successBlock (responseObject, nil);
            }
        }
        else {
            NSLog(@"请求成功:%@ --- responseObject: \n%@", url, responseObject);
            if (successBlock) {
                successBlock (responseObject, nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 从任务列表中移除该请求任务
        @synchronized (self) {
            [self.taskArray removeObject:task];
        }
        
        NSLog(@"请求失败:%@ --- error: \n%@", url, error);
        if (failBlock) {
            failBlock (error);
        }
    }];
    [postTask resume];
    
    // 添加任务到请求列表
    @synchronized (self) {
        [self.taskArray addObject:postTask];
    }
}



// 取消所有请求
- (void)cancelAllRequest
{
    [self.taskArray enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(cancel)]) {
            [obj cancel];
        }
    }];
    [self.taskArray removeAllObjects];
}


/**
 *  设备版本
 *
 *  @return e.g. iPhone 5S
 */
- (NSString *)deviceVersion
{
    // 需要
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"] ||
        [deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"] ||
        [deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"] ||
        [deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"] ||
        [deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"] ||
        [deviceString isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,8"])    return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"])    return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"] ||
        [deviceString isEqualToString:@"iPhone11,6"])    return @"iPhone XS Max";
    
    //iPod touch
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([deviceString isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    if ([deviceString isEqualToString:@"iPod9,1"])      return @"iPod Touch 7G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"] ||
        [deviceString isEqualToString:@"iPad4,2"] ||
        [deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"] ||
        [deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"] ||
        [deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro (9.7-inch)";
    if ([deviceString isEqualToString:@"iPad6,7"] ||
        [deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro (12.9-inch)";
    if ([deviceString isEqualToString:@"iPad6,11"] ||
        [deviceString isEqualToString:@"iPad6,12"])     return @"iPad 5";
    if ([deviceString isEqualToString:@"iPad7,1"] ||
        [deviceString isEqualToString:@"iPad7,2"])      return @"iPad Pro 2 (12.9-inch)";
    if ([deviceString isEqualToString:@"iPad7,3"] ||
        [deviceString isEqualToString:@"iPad7,4"])      return @"iPad Pro (10.5-inch)";
    if ([deviceString isEqualToString:@"iPad7,5"] ||
        [deviceString isEqualToString:@"iPad7,6"])      return @"iPad 6";
    if ([deviceString isEqualToString:@"iPad8,1"] ||
        [deviceString isEqualToString:@"iPad8,2"] ||
        [deviceString isEqualToString:@"iPad8,3"] ||
        [deviceString isEqualToString:@"iPad8,4"])      return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,7"] ||
        [deviceString isEqualToString:@"iPad8,8"])      return @"iPad Pro 3 (12.9-inch)";
    if ([deviceString isEqualToString:@"iPad11,3"] ||
        [deviceString isEqualToString:@"iPad11,4"])      return @"iPad Air 2";
    
    
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    if ([deviceString isEqualToString:@"iPad4,4"] ||
        [deviceString isEqualToString:@"iPad4,5"] ||
        [deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"] ||
        [deviceString isEqualToString:@"iPad4,8"] ||
        [deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"] ||
        [deviceString isEqualToString:@"iPad5,2"])      return @"iPad mini 4";
    if ([deviceString isEqualToString:@"iPad11,1"] ||
        [deviceString isEqualToString:@"iPad11,2"])     return @"iPad mini 4";
    
    return deviceString;
}


@end
