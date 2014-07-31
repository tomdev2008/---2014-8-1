//
//  Coupon.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-25.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupon : NSObject

@property (nonatomic, strong) NSString *couType;
@property (nonatomic, strong) NSString *couName;
@property (nonatomic ,strong) NSString *couCode;
@property (nonatomic ,strong) NSString *couValue;
@property (nonatomic, strong) NSNumber *couLeft_Value;
@property (nonatomic, strong) NSString *couEnd;
@property (nonatomic ,strong) NSString *couState;
@property (nonatomic, strong) NSString *couCommentNum;
@property (nonatomic, strong) NSString *couDiscription;
@property (nonatomic, strong) NSString *couFace_Value;
@property (nonatomic, strong) NSString *couForwardNum;
@property (nonatomic, strong) NSString *couGetNum;
@property (nonatomic, strong) NSString *couId;
@property (nonatomic, strong) NSString *couLogin_Face;
@property (nonatomic, strong) NSString *couMerchant_Pic;
@property (nonatomic, strong) NSString *couMerchant;
@property (nonatomic, strong) NSMutableArray *couComments;
@property (nonatomic, strong) NSMutableArray *couUsers;
@property (nonatomic, strong) NSMutableArray *couPictures;
@property (nonatomic, strong) NSString *couPrice;
@property (nonatomic, strong) NSString *couServices;
@property (nonatomic, strong) NSString *couShareNum;
@property (nonatomic, strong) NSString *couTitlePic;
@property (nonatomic, strong) NSString *couStart;

@end
