//
//  XOBaseModel.h
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


//////////////////////////////////////////////////////////////////////////////////////
/////////////////////////// 实现了coding和coping协议的模型基类 ///////////////////////////
//////////////////////////////////////////////////////////////////////////////////////


@interface XOBaseModel : NSObject <NSCoding, NSCopying>

@end

NS_ASSUME_NONNULL_END
