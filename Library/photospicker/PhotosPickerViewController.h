//
//  PhotosPickerViewController.h
//  PhotosPickDemo
//
//  Created by dbloong on 14-6-13.
//  Copyright (c) 2014年 dbloong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoSelectedViewController.h"


@interface PhotosPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)PhotosPickCompeletionBlock compeletionBlock;

@end
