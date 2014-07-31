//
//  PhotoSelectedViewController.h
//  PhotosPickDemo
//
//  Created by dbloong on 14-6-13.
//  Copyright (c) 2014年 dbloong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^PhotosPickCompeletionBlock)(NSArray *selectedPhotos);

@interface PhotoSelectedViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *photos;

@property (weak, nonatomic)PhotosPickCompeletionBlock compeletionBlock;

@end
