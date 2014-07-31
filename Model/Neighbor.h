//
//  Neighbor.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-9.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Neighbor : NSObject

@property (nonatomic, strong) NSString *neiCommentNum;
@property (nonatomic, strong) NSString *neiContent;
@property (nonatomic, strong) NSString *neiForwardNum;
@property (nonatomic, strong) NSString *neiId;
@property (nonatomic, strong) NSString *neiIs_Up;
@property (nonatomic, strong) NSString *neiLookNum;
@property (nonatomic, strong) NSMutableArray *neiPictureArray;
@property (nonatomic, strong) NSString *neiSend_Time;
@property (nonatomic, strong) NSString *neiShareNum;
@property (nonatomic, strong) NSString *neiShare_Id;
@property (nonatomic, strong) NSString *neiShare_module;
@property (nonatomic, strong) NSString *neiTitlePic;
@property (nonatomic, strong) NSString *neiType;
@property (nonatomic, strong) NSMutableArray *neiUserArray;
@property (nonatomic, strong) NSString *neiZan;
@property (nonatomic, strong) NSString *neiZanNum;

@end
