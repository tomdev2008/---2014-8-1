//
//  ServerDetail.h
//  梧桐邑
//
//  Created by 陈磊 on 14-7-9.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerDetail : NSObject

@property (nonatomic, strong) NSString *sdId;           // 订单
@property (nonatomic, strong) NSString *sdCode;         // 订单号
@property (nonatomic, strong) NSString *sdState;        // 订单状态
@property (nonatomic, strong) NSString *sdOrder_Time;   // 下单时间
@property (nonatomic, strong) NSString *sdCoupon_Num;   // 优惠券数量
@property (nonatomic, strong) NSString *sdLeft_Integral;// 可用积分
@property (nonatomic, strong) NSString *sdTotal;
@property (nonatomic, strong) NSString *sdIntegral_off; // 积分抵扣数
@property (nonatomic, strong) NSString *sdCoupon_off;   // 优惠券抵扣数
@property (nonatomic, strong) NSString *sdInvoice_t;    // 发票抬头
@property (nonatomic, strong) NSString *sdInvoice_s;    // 发票事由
@property (nonatomic, strong) NSString *sdRemark;       // 备注

@property (nonatomic, strong) NSMutableArray *sdServices;// 订单所属服务信息
@property (nonatomic, strong) NSString *ssdId;           // 服务id
@property (nonatomic, strong) NSString *ssdType;         // 服务类型
@property (nonatomic, strong) NSString *ssdName;         // 服务名称
@property (nonatomic, strong) NSString *ssdPrice_Type;
@property (nonatomic, strong) NSString *ssdIntegral;
@property (nonatomic, strong) NSString *ssdCoupon;
@property (nonatomic, strong) NSString *ssdInvoice;
@property (nonatomic, strong) NSString *ssdTitlePic;
@property (nonatomic, strong) NSString *ssdReturnable;

@property (nonatomic, strong) NSString *rsdId;          // 预约信息 id
@property (nonatomic, strong) NSString *rsdName;        // 预约人姓名
@property (nonatomic, strong) NSString *rsdPhone;
@property (nonatomic, strong) NSString *rsdRomm;
@property (nonatomic, strong) NSString *rsdDate_Time;

@property (nonatomic, strong) NSString *asdId;          // 收货信息
@property (nonatomic, strong) NSString *asdName;
@property (nonatomic, strong) NSString *asdContact;     // 联系方式
@property (nonatomic, strong) NSString *asdaddress;

@property (nonatomic, strong) NSMutableArray *asdEvents;// 如果实习类价格则有
@property (nonatomic, strong) NSString *esdId;
@property (nonatomic, strong) NSString *esdName;
@property (nonatomic, strong) NSString *esdNum;
@property (nonatomic, strong) NSString *esdTotal;        // 小计金额

@end
