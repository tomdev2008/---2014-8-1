//
//  Order.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-24.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic, strong) NSString *orderUid; // 订单ID
@property (nonatomic, strong) NSString *orderUface;
@property (nonatomic) int orderAuthenticate;
@property (nonatomic, strong) NSString *orderName;
@property (nonatomic, strong) NSString *orderOsid;
@property (nonatomic, strong) NSString *orderCode;  // 订单号
@property (nonatomic, strong) NSString *orderState;
@property (nonatomic, strong) NSString *orderMoney;
@property (nonatomic, strong) NSString *buyId;  
@property (nonatomic, strong) NSString *buyLogo;
@property (nonatomic ,strong) NSString *buyName;

@property (nonatomic, strong) NSString *sign;   // 签名字符串

@end
