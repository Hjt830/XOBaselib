//
//  XOViewController.m
//  XOBaseLib
//
//  Created by kenter on 08/13/2019.
//  Copyright (c) 2019 kenter. All rights reserved.
//

#import "XOViewController.h"
#import <XOBaseLib/XOBaseLib.h>

@interface XOViewController ()

@end

@implementation XOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSString *str = XOLocalizedString(@"NSDateCategory.text1");
    NSLog(@"str: %@", str);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
