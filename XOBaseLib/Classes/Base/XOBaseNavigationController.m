//
//  XOBaseNavigationController.m
//  XOBaseLib
//
//  Created by kenter on 2019/8/13.
//  Copyright © 2019 KENTER. All rights reserved.
//

#import "XOBaseNavigationController.h"
#import "UIImage+XOBaseLib.h"

@interface XOBaseNavigationController ()

@property(nonatomic,strong)UIImage * shadowView;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 如果滑动移除控制器的功能失效，清空代理(让导航控制器重新设置这个功能)
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        // 如果push进来的不是第一个控制器
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage xo_imageNamedFromBaseBundle:@"back"] forState:UIControlStateNormal];
        button.bounds = CGRectMake(0, 0, 40, 30);
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // [button sizeToFit];
        // 让按钮的内容往左边偏移10
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        // 修改导航栏左边的item
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationBar setShadowImage:self.shadowView];
    }
    else {
        if(self.isAlwaysShadow) {
            [self.navigationBar setShadowImage:self.shadowView];
        } else {
            [self.navigationBar setShadowImage:[[UIImage alloc]init]];
        }
    }
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (self.childViewControllers.count > 2) {
        [self.navigationBar setShadowImage:self.shadowView];
    }
    else {
        if(self.isAlwaysShadow) {
            [self.navigationBar setShadowImage:self.shadowView];
        } else {
            [self.navigationBar setShadowImage:[[UIImage alloc]init]];
        }
    }
    return [super popViewControllerAnimated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
