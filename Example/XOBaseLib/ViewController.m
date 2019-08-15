//
//  ViewController.m
//  XOBaseLib_Example
//
//  Created by kenter on 2019/8/15.
//  Copyright © 2019 kenter. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"title";
    
    [self showBackBarItem:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
