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
	
    NSArray <NSString *>*arr = @[@"camera", @"pick", @"multiplePick"];
    for (int i = 0; i < arr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((self.view.width - 120.0)/2.0, 150 + 120 * i, 120, 56);
        [button setTitleColor:[UIColor XOTextColor] forState:UIControlStateNormal];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button.tag = i;
    }
}

- (void)pick:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            [self takePhotoInCamera:YES handler:^(NSDictionary<UIImagePickerControllerInfoKey,id> * _Nonnull info) {
                
            }];
            break;
        case 1:
            [self pickSinglePicture:YES handler:^(NSDictionary<UIImagePickerControllerInfoKey,id> * _Nonnull info) {
                
            }];
            break;
        case 2:
            [self pickMultiplePicture:9 handler:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> * _Nonnull infos) {
                
            }];
            break;
            
        default:
            break;
    }
}


@end
