//
//  XOMacro.h
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#ifndef XOMacro_h
#define XOMacro_h

#import <Foundation/Foundation.h>

#define XOLocalizedString(key) ([NSBundle xo_localizedStringForKey:(key)])

#pragma mark ====================== 字体 ======================

#define XOSystemFont(f)         [UIFont systemFontOfSize:f]

#define kAppLargeTextFont       XOSystemFont(16.0)  // 文字较大
#define kAppMiddleTextFont      XOSystemFont(14.0)  // 文字中等大小
#define kAppSmallTextFont       XOSystemFont(12.0)  // 文字较小


#pragma mark ====================== 尺寸 ======================

/// 设备的宽
#define KWIDTH      [UIScreen mainScreen].bounds.size.width
/// 设备的高
#define KHEIGHT     [UIScreen mainScreen].bounds.size.height
/// 设备的缩放比例
#define KSCALE      [UIScreen mainScreen].scale

/// 是否是iphone5系列
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

/// 是否是iOS10
#define isiOS10 ([[UIDevice currentDevice].systemVersion floatValue] >= 10)

/// 导航栏高度
#define NavigationHeight    (self.navigationController  == nil ?  \
                            self.tabBarController.navigationController.navigationBar.height : self.navigationController.navigationBar.height)
/// tabbar高度
#define TabbarHeight        (self.tabBarController.tabBar.height)

/// 状态栏高度
#define StatusBarHeight     ([UIApplication sharedApplication].statusBarFrame.size.height)


#define HEIGHT_STATUSBAR    20 // 状态栏
#define HEIGHT_TABBAR       49 // 标签
#define HEIGHT_NAVBAR       44 // 导航
#define HEIGHT_CHATBOXVIEW  215// 更多 view

#pragma mark ====================== 颜色 ======================

// 取色值(RGB颜色)
#define RGB(r,g,b)          [UIColor colorWithRed:(r)/255.f \
                                            green:(g)/255.f \
                                             blue:(b)/255.f \
                                            alpha:1.f]

#define RGBA(r,g,b,a)       [UIColor colorWithRed:(r)/255.f \
                                            green:(g)/255.f \
                                             blue:(b)/255.f \
                                            alpha:(a)]
// 取色值(十六进制颜色)
#define RGBOF(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                            green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                             blue:((float)(rgbValue & 0xFF))/255.0 \
                                            alpha:1.0]

#define RGBA_OF(rgbValue)   [UIColor colorWithRed:((float)(((rgbValue) & 0xFF000000) >> 24))/255.0 \
                                            green:((float)(((rgbValue) & 0x00FF0000) >> 16))/255.0 \
                                             blue:((float)(rgbValue & 0x0000FF00) >> 8)/255.0 \
                                            alpha:((float)(rgbValue & 0x000000FF))/255.0]

#define RGBAOF(v, a)        [UIColor colorWithRed:((float)(((v) & 0xFF0000) >> 16))/255.0 \
                                            green:((float)(((v) & 0x00FF00) >> 8))/255.0 \
                                             blue:((float)(v & 0x0000FF))/255.0 \
                                            alpha:a]

/////////////////// App相关配色

#define AppTinColor                     RGBOF(0x7c4dff)         // App主题色

#define MainPurpleColor                 RGBOF(0x7c4dff)         // 主色,紫色
#define MainPurpleLightColor            RGBOF(0xb388ff)         // 明亮主色,紫色

#define SubPinkColor                    RGBOF(0xff4081)         // 辅助色,粉红色
#define SubOrangeColor                  RGBOF(0xff7034)         // 辅助色,橙色

#define SubPinkLightColor               RGBOF(0xff80ab)         // 明亮辅助色,粉红色
#define SubOrangeLightColor             RGBOF(0xff9e80)         // 明亮辅助色,橙色

#define TxtBackColor                    RGBOF(0x121213)         // 文字颜色,黑色
#define TxtGrayColor                    RGBOF(0x7c7e86)         // 文字icon,浅灰
#define BGSeparateGrayColor             RGBOF(0xf5f5f7)         // 背影和分隔线,浅浅灰
#define DeleteRedColor                  RGBOF(0xfe3f59)         // 删除色,红色

#define DEFAULT_CHAT_BACKGROUND_COLOR   RGBA(235.0, 235.0, 235.0, 1.0)
#define DEFAULT_CHATBOX_COLOR           RGBA(244.0, 244.0, 246.0, 1.0)
#define DEFAULT_SEARCHBAR_COLOR         RGBA(239.0, 239.0, 244.0, 1.0)
#define DEFAULT_GREEN_COLOR             RGBA(2.0, 187.0, 0.0, 1.0f)
#define DEFAULT_LINE_GRAY_COLOR         RGBA(188.0, 188.0, 188.0, 0.6f)

/////////////////// UITableView定义


#define BG_TableColor           [UIColor groupTableViewBackgroundColor]                                 // 网格背景色 颜色
#define BG_TableCellColor       [UIColor whiteColor]                                                    // 网格行 颜色
#define BG_TableSeparatorColor  RGB(240, 240, 240)                                                      // 网格 线 颜色


#define BtnBorderWidth          0.5     // 按钮边缘线宽
#define LineBorderWidth         0.5     // 线条粗细
#define RadiusIcon              3.5     // 头像圆角（全局）
#define RadiusBig               8.0     // 大圆角


#pragma mark ====================== 判断是否为空字符串、空数组、空字典 ======================

/**
 *  是否是空字符串 或者 不是字符串
 */
#define XOIsEmptyString(str)    ((!(str) \
                                || ([(str) isEqual:[NSNull null]]) \
                                || (![(str) isKindOfClass:[NSString class]]) \
                                || ([(str) isKindOfClass:[NSString class]] && 0 == [(str) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) \
                                || ([(str) isKindOfClass:[NSString class]] && 0 == (str).length) \
                                || ([(str) isKindOfClass:[NSString class]] && ([(str) isEqualToString:@""] || [(str) isEqualToString:@"null"] || [(str) isEqualToString:@"<null>"]))) \
                                ? YES : NO)
/**
 *  是否是空数组  或者 不是数组
 */
#define XOIsEmptyArray(arr)     ((!(arr) \
                                || ([(arr) isEqual:[NSNull null]]) \
                                || (![(arr) isKindOfClass:[NSArray class]]) \
                                || ([(arr) isKindOfClass:[NSArray class]] && 0 == (arr).count)) \
                                ? YES : NO)
/**
 *  是否是空字典  或者 不是字典
 */
#define XOIsEmptyDictionary(dic)    ((!(dic) \
                                    || ([(dic) isEqual:[NSNull null]]) \
                                    || (![(dic) isKindOfClass:[NSDictionary class]]) \
                                    || ([(dic) isKindOfClass:[NSDictionary class]] && 0 == (dic).count)) \
                                    ? YES : NO)





#pragma mark ====================== 对self指针的强弱转换 ======================

/**
 对self在Block中强弱指针的引用转换
 Example:
     @XOWeakify(self)  // 强引用转弱引用
     [self doSomething^{
        @XOStrongify(self)  // 弱引用转强引用
        if (!self) return;
        ...
     }];
 */
#if DEBUG
#define xo_keywordify autoreleasepool {}
#else
#define xo_keywordify try {} @catch (...) {}
#endif

#define xo_weakify_(INDEX, CONTEXT, VAR) \
CONTEXT __typeof__(VAR) metamacro_concat(VAR, _weak_) = (VAR);

#define xo_strongify_(INDEX, VAR) \
__strong __typeof__(VAR) VAR = metamacro_concat(VAR, _weak_);


#ifndef XOWeakify
    #define XOWeakify(...) \
            xo_keywordify \
            metamacro_foreach_cxt(xo_weakify_,, __weak, __VA_ARGS__)
#endif

#ifndef XOStrongify
    #define XOStrongify(...) \
            xo_keywordify \
            _Pragma("clang diagnostic push") \
            _Pragma("clang diagnostic ignored \"-Wshadow\"") \
            metamacro_foreach(xo_strongify_,, __VA_ARGS__) \
            _Pragma("clang diagnostic pop")
#endif

#pragma mark ====================== 打印日志(打印类名、方法名、代码行数) ======================

#ifdef DEBUG
    #define XOLog(fmt, ...) NSLog((@"[%@]  %s [Line %d]  " fmt), NSStringFromClass([self class]),  __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define XOLog(...) NSLog(__VA_ARGS__)
#endif







#endif /* XOMarco_h */
