//
//  ActivityInfo.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-13.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityInfo : NSObject

@property (nonatomic, strong) NSMutableArray *actiInfoAddtions;
@property (nonatomic, strong) NSMutableArray *actiInfoUsers;
@property (nonatomic, strong) NSMutableArray *actiInfoComments;
@property (nonatomic, strong) NSMutableArray *actiInfoPictures;
@property (nonatomic, strong) NSString *actiInfoContent;
@property (nonatomic, strong) NSString *actiInfoEnd;
@property (nonatomic, strong) NSString *actiInfoForwordNum;
@property (nonatomic, strong) NSNumber *actiInfoCurrent;
@property (nonatomic, strong) NSString *actiInfoId;
@property (nonatomic, strong) NSString *actiInfoJoin;
@property (nonatomic, strong) NSString *actiInfoJoinNum;
@property (nonatomic, strong) NSString *actiInfoLookNum;
@property (nonatomic, strong) NSString *actiInfoSend_Time;
@property (nonatomic, strong) NSString *actiInfoShareNum;
@property (nonatomic, strong) NSString *actiInfoStart;
@property (nonatomic, strong) NSString *actiInfoTheMe;
@property (nonatomic, strong) NSString *actiInfoTitlePic;
@property (nonatomic, strong) NSNumber *actiInfoTotal;
@property (nonatomic, strong) NSString *actiInfoUrl_external;
@property (nonatomic, strong) NSString *actiInfoUrl_module;
@property (nonatomic, strong) NSString *actiInfoUrl_pid;
@property (nonatomic, strong) NSString *actiInfoUrl_redirect;
@property (nonatomic, strong) NSString *actiInfoUrl_type;

// 发布人
@property (nonatomic, strong) NSString *actiInfoUserFace;
@property (nonatomic, strong) NSString *actiInfoUserId;
@property (nonatomic, strong) NSString *actiInfoUserName;

@end
