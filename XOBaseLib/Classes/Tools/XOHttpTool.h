//
//  JTHttpTool.h
//  JTMainProject
//
//  Created by kenter on 2019/6/20.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 请求成功Code
static int const JTHttpSuccessCode = 9999;


@interface JTHttpTool : NSObject

+ (instancetype)shareTool;



/** @brief 发起一个POST请求，并异步返回
 *  @param url 请求的地址
 *  @param parameters 请求参数
 *  @param successBlock 请求成功的回调
 *  @param failBlock 请求失败的回调
 */
- (void)POST:(nonnull NSString *)url
  parameters:(id _Nullable)parameters
     success:(void(^ _Nullable)(NSDictionary * _Nullable responseDictionary, NSData * _Nullable data))successBlock
        fail:(void(^ _Nullable)(NSError * _Nullable error))failBlock;

@end

NS_ASSUME_NONNULL_END
