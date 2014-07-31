//
//  ZL_CONST.h
//  梧桐邑
//
//  Created by 陈磊 on 14-5-30.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#define isRetina [UIScreen mainScreen].applicationFrame
#define is_IPHONE_6 [[UIDevice currentDevice].systemVersion floatValue] < 7.0

#import "Neighbor.h"
#import "User.h"
#import "NeighobrInfo.h"
#import "AppUtil.h"
#import "Activity.h"
#import "ActivityInfo.h"
#import "Discount.h"
#import "RealPay.h"
#import "Server.h"
#import "Order.h"
#import "Community.h"
#import "OrderInfo.h"
#import "Coupon.h"
#import "Message.h"
#import "Group.h"
#import "Comment.h"
#import "Property.h"
#import "Address.h"
#import "ServerDetail.h"
#import "LoadingView.h"
#import "SDWebImage/UIImageView+WebCache.h"

#define TYPE_NEIGHBOR 0         // 邻居说
#define TYPE_NEIGHBORINFO 1     // 邻居说详情

#define TYPE_USERLOGIN 2        // 用户登录
#define TYPE_PERSONINFO 3       // 用户信息
