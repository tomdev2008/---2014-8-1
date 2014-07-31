//
//  OrderInfo.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-24.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfo : NSObject

@property (nonatomic, strong) NSString *oinfoId;
@property (nonatomic, strong) NSString *oinfoCode;
@property (nonatomic, strong) NSString *oinfoState;
@property (nonatomic, strong) NSString *oinfoOrder_Time;
@property (nonatomic, strong) NSString *oinfoCounpon_Num;
@property (nonatomic, strong) NSString *oinfoLeft_Integral;
@property (nonatomic, strong) NSString *oinfoCounpon_Off;
@property (nonatomic, strong) NSString *oinfoIntegral_Off;
@property (nonatomic, strong) NSString *oinfoInvoice_s;
@property (nonatomic, strong) NSString *oinfoInvoice_t;
@property (nonatomic, strong) NSString *oinfoRemark;
@property (nonatomic, strong) NSString *oinfoTotal;

// Address
@property (nonatomic, strong) NSString *addAddress;
@property (nonatomic, strong) NSString *addContact;  // 联系电话
@property (nonatomic, strong) NSString *addName;     // 联系人
@property (nonatomic, strong) NSString *addId;

// reservation
@property (nonatomic, strong) NSString *reDate_time;
@property (nonatomic, strong) NSString *reId;
@property (nonatomic, strong) NSString *reName;
@property (nonatomic, strong) NSString *rePhone;
@property (nonatomic, strong) NSString *reRoom;

// service
@property (nonatomic, strong) NSString *seCoupon;
@property (nonatomic, strong) NSString *seId;
@property (nonatomic, strong) NSString *seIntegral;
@property (nonatomic, strong) NSString *seInvoice;
@property (nonatomic, strong) NSString *seName;
@property (nonatomic, strong) NSString *sePrice_Type;
@property (nonatomic, strong) NSString *seReturnable;
@property (nonatomic, strong) NSString *seTitlePic;
@property (nonatomic, strong) NSString *seType;

@property (nonatomic, strong) NSMutableArray *oinfoAddressArray;
@property (nonatomic, strong) NSMutableArray *oinfoEventsArray;
@property (nonatomic, strong) NSMutableArray *oinfoReservationArray;
@property (nonatomic, strong) NSMutableArray *oinfoServiceArray;

@end
