//
//  XOBaseConfig.h
//  AFNetworking
//
//  Created by kenter on 2019/7/25.
//

#import <Foundation/Foundation.h>
#import "JTMacro.h"

NS_ASSUME_NONNULL_BEGIN


@class XOBaseConfigModel;
@interface XOBaseConfig : NSObject

@property (nonatomic, strong, readonly) XOBaseConfigModel       *config;

+ (instancetype)defaultConfig;

- (void)initializationWithConfig:(XOBaseConfigModel * _Nonnull)config;


@end




@interface XOBaseConfigModel : NSObject

// 本地秘钥(设定后不要更改，否则本地存储的数据无法解密出来)
@property (nonatomic, copy) NSString        *localStorageSign;  // 本地存储用到的秘钥 (JTUserDefault中使用, 建议使用32位小写连续字符串)
@property (nonatomic, copy) NSString        *keyChainSign;      // 本地存储用到的秘钥 (JTKeyChainTool中使用, 建议使用32位小写连续字符串)

@end


NS_ASSUME_NONNULL_END
