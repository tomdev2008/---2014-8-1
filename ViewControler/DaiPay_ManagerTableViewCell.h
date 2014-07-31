//
//  DaiPay_ManagerTableViewCell.h
//  梧桐邑
//
//  Created by 陈磊 on 14-7-14.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaiPay_ManagerTableViewCell : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic) int orderType;    // 订单状态

// 订单号
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLable;
// 状态
@property (weak, nonatomic) IBOutlet UILabel *orderStateLable;
// 下订单时间
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLable;
// 服务图片
@property (weak, nonatomic) IBOutlet UIImageView *serverImage;
// 服务名称
@property (weak, nonatomic) IBOutlet UILabel *serverName;
// 服务view
@property (weak, nonatomic) IBOutlet UIScrollView *serverScrollView;
// 预约人
@property (weak, nonatomic) IBOutlet UILabel *orderPersonLable;
// 联系电话
@property (weak, nonatomic) IBOutlet UILabel *orderPhoneLable;
// 预约服务地址
@property (weak, nonatomic) IBOutlet UILabel *orderServerAddressLable;
// 预约服务时间
@property (weak, nonatomic) IBOutlet UILabel *orderServerTimeLable;
// 发票抬头
@property (weak, nonatomic) IBOutlet UILabel *faCardLable;
// 发票内容
@property (weak, nonatomic) IBOutlet UILabel *faCardContentLable;
// 订单金额
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;
// 服务总金额
@property (weak, nonatomic) IBOutlet UILabel *orderServerPriceLable;
// 优惠券抵扣
@property (weak, nonatomic) IBOutlet UILabel *orderCouponLable;
// 积分抵扣
@property (weak, nonatomic) IBOutlet UILabel *orderPointLable;

// 付款方式
@property (weak, nonatomic) IBOutlet UIView *paySelectView;
// 我一提供服务按钮
@property (weak, nonatomic) IBOutlet UIButton *myServerBtn;

@end
