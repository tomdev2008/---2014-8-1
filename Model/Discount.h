//
//  Discount.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-19.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Discount : NSObject

@property (nonatomic, strong) NSString *disEnd;
@property (nonatomic, strong) NSString *disGot;
@property (nonatomic, strong) NSString *disId;
@property (nonatomic, strong) NSString *disName;
@property (nonatomic, strong) NSString *disPrice;
@property (nonatomic, strong) NSString *disStart;
@property (nonatomic, strong) NSString *disTitlePic;

// 详情
@property (nonatomic, strong) NSMutableArray *disCommentArray;
@property (nonatomic, strong) NSMutableArray *disPictures;
@property (nonatomic, strong) NSString *disCommentNum;
@property (nonatomic, strong) NSString *disCurrent;
@property (nonatomic, strong) NSString *disCription;
@property (nonatomic, strong) NSString *disFace_Value;
@property (nonatomic, strong) NSString *disForwardNum;
@property (nonatomic, strong) NSString *disGetNum;
@property (nonatomic, strong) NSString *disLogin_Face;
@property (nonatomic, strong) NSString *disMerchant;
@property (nonatomic, strong) NSString *disServices;
@property (nonatomic, strong) NSString *disShareNum;
@property (nonatomic, strong) NSString *disTotal;

// 评论
@property (nonatomic, strong) NSMutableArray *disComments;
@property (nonatomic, strong) NSMutableArray *disUsers;

@end
