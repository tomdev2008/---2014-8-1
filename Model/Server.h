//
//  Server.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-23.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Server : NSObject

@property (nonatomic, strong) NSString *serId;
@property (nonatomic, strong) NSString *serName;
@property (nonatomic, strong) NSString *serOrder_type;
@property (nonatomic, strong) NSString *serTitlePic;
@property (nonatomic, strong) NSString *serCommentNum;
@property (nonatomic, strong) NSString *serDescription;
@property (nonatomic, strong) NSString *serPrice;
@property (nonatomic, strong) NSString *serPrice_type;
@property (nonatomic, strong) NSString *serMerId;
@property (nonatomic, strong) NSString *serMerName;
@property (nonatomic, strong) NSMutableArray *serPicturesArray;
@property (nonatomic, strong) NSMutableArray *serEvents;
@property (nonatomic, strong) NSString *serCount;    // 数量

// 呼叫成功
@property (nonatomic, strong) NSString *serMessage;
@property (nonatomic, strong) NSString *serOrder_Code;
@property (nonatomic, strong) NSString *serOrder_Id;
@property (nonatomic, strong) NSString *serStatus;

// 获取小区服务时间
@property (nonatomic, strong) NSString *serServerTime;

@end
