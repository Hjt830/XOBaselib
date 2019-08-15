//
//  XOBaseNavigationController.m
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import "XOBaseNavigationController.h"

@interface XOBaseNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation XOBaseNavigationController
    
+ (void)initialize
{
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:19.0f]}];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.interactivePopGestureRecognizer.enabled = YES;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
    
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( gestureRecognizer == self.interactivePopGestureRecognizer )
    {
        //  禁用某些不支持侧滑返回的页面
//        UIViewController *vc = self.viewControllers.lastObject;
//        if ([vc isKindOfClass:[OpenContainerDoorVC class]]) {
//            return NO;
//        }
        //  禁用根目录的侧滑手势
        if ( self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0] )
        {
            return NO;
        }
    }
    return YES;
}

@end
