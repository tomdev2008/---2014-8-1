//
//  PhotosPicker.m
//  PhotosPickDemo
//
//  Created by dbloong on 14-6-16.
//  Copyright (c) 2014年 dbloong. All rights reserved.
//

#import "PhotosPicker.h"

@implementation PhotosPicker

+ (void)showPhotosPickerUsingCompeletionBlock:(PhotosPickCompeletionBlock)compeletionBlock withRootViewController:(UIViewController *)root
{
    PhotosPickerViewController *photoSelectView = [[PhotosPickerViewController alloc] init];
    photoSelectView.compeletionBlock = compeletionBlock;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:photoSelectView];
    [root presentViewController:nvc animated:YES completion:nil];
}

@end
