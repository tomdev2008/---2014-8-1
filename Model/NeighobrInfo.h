//
//  NeighobrInfo.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-10.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeighobrInfo : NSObject

@property (nonatomic, strong) NSMutableArray *neiInfoCommentArray;
@property (nonatomic, strong) NSString *neiInfoCommentNum;
@property (nonatomic, strong) NSString *neiInfoContent;
@property (nonatomic) NSInteger neiInfoCurrent;
@property (nonatomic, strong) NSString *neiInfoForwardNum;
@property (nonatomic) NSInteger neiInfoId;
@property (nonatomic, strong) NSString *neiInfoLookNum;
@property (nonatomic, strong) NSString *neiInfoSend_Time;
@property (nonatomic, strong) NSMutableArray *neiInfoPictureArray;
@property (nonatomic, strong) NSString *neiInfoShareNum;
@property (nonatomic, strong) NSString *neiInfoTitlePic;
@property (nonatomic) NSInteger neiInfoTotal;
@property (nonatomic, strong) NSString *neiInfoZanNum;

@property (nonatomic, strong) NSMutableArray *neiInfoComments;  // 评论
@property (nonatomic, strong) NSMutableArray *neiInfoUsers;     // 用户
@property (nonatomic, strong) NSMutableArray *neiInfoPictures;  // 图片

@end
