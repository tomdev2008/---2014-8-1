//
//  AppDelegate.h
//  梧桐邑
//
//  Created by 陈磊 on 14-5-28.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTabBar.h"
#import "Library/PubLib/BPush.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate, BPushDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MyTabBar *mtb;
@property (strong, nonatomic) UITabBarController *tbc;

@property (nonatomic, strong) NSString *LoaginDeviceId;

@property (nonatomic) int communityId;

- (void)createMyTableBar:(NSArray *)array;



@end
