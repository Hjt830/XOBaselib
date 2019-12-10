//
//  XOBaseConfig.h
//  AFNetworking
//
//  Created by kenter on 2019/8/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XOMacro.h"

NS_ASSUME_NONNULL_BEGIN

// 包类型
typedef NS_ENUM(int, AppType) {
    AppType_package_A = 1000,
    AppType_package_B = 2000
};

@class XOBaseConfigModel;
@interface XOBaseConfig : NSObject

@property (nonatomic, strong, readonly) XOBaseConfigModel       *config;
@property (nonatomic, assign) AppType                           appType;
@property (nonatomic, copy, readonly) UIColor                   *appTintColor;

+ (instancetype)defaultConfig;

- (void)initializationWithConfig:(XOBaseConfigModel * _Nonnull)config;


@end




@interface XOBaseConfigModel : NSObject

// 本地秘钥(设定后不要更改，否则本地存储的数据无法解密出来)
@property (nonatomic, copy) NSString        *localStorageSign;  // 本地存储用到的秘钥 (XOUserDefault中使用, 建议使用32位小写连续字符串)
@property (nonatomic, copy) NSString        *keyChainSign;      // 本地存储用到的秘钥 (XOKeyChainTool中使用, 建议使用32位小写连续字符串)

@end


NS_ASSUME_NONNULL_END
