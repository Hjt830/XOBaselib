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
	
    
    UIImage *image = [UIImage xo_imageNamedFromBaseBundle:@"back"];
    NSLog(@"image: %@", image);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
