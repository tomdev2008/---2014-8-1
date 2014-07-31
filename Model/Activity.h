//
//  Activity.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-13.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

@property (nonatomic, strong) NSMutableArray *actiBuilderArray;
@property (nonatomic, strong) NSString *actiContent;
@property (nonatomic, strong) NSString *actiId;
@property (nonatomic, strong) NSString *actiJoin;
@property (nonatomic, strong) NSString *actiJoinNum;
@property (nonatomic, strong) NSString *actiLookNum;
@property (nonatomic, strong) NSString *actiPicturesArray;
@property (nonatomic, strong) NSString *actiSend_Time;
@property (nonatomic, strong) NSString *actiShareNum;
@property (nonatomic, strong) NSString *actiTitlePic;
@property (nonatomic, strong) NSString *actiTheMe;

@end
