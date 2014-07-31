//
//  PhotosPicker.h
//  PhotosPickDemo
//
//  Created by dbloong on 14-6-16.
//  Copyright (c) 2014年 dbloong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotosPickerViewController.h"


@interface PhotosPicker : NSObject

/*
 调用此方法弹出相册，操作完成后执行compeletionBlock
 PhotosPickCompeletionBlock中的参数为选中照片的UIImage，取消操作或不选都返回空数组
 */
+ (void)showPhotosPickerUsingCompeletionBlock:(PhotosPickCompeletionBlock)compeletionBlock withRootViewController:(UIViewController *)root;

@end
