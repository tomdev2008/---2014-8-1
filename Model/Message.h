//
//  Message.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-27.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Message : NSObject

@property (nonatomic, strong) NSString *msgContent;
@property (nonatomic, strong) NSString *msgId;
@property (nonatomic, strong) NSString *msgSend_Time;
@property (nonatomic, strong) NSString *msgStyle;
@property (nonatomic, strong) NSString *msgType;
@property (nonatomic, strong) NSString *msgUnread;

@property (nonatomic, strong) NSString *userFace;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *msgFrom_Id;
@property (nonatomic, strong) NSString *msgModule_Id;
@property (nonatomic, strong) NSString *msgPid;
@property (nonatomic, strong) NSString *msgTo_Id;

// 群消息
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic ,strong) NSString *senderId;
@property (nonatomic ,strong) NSString *senderName;
@property (nonatomic, strong) NSString *senderFace;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSData *voiceData;

@end
