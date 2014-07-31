//
//  DaiPayViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-7-9.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeOrderViewController.h"

@interface DaiPayViewController : UIViewController <changeOrderViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) int orderType;    // 订单类型

@property (nonatomic, strong) NSString *orderId;    // 订单Id;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *serverScrollView;
// 价格View
@property (weak, nonatomic) IBOutlet UIView *priceView;
// 发票View
@property (weak, nonatomic) IBOutlet UIView *FaCardView;
// 发票信息
@property (weak, nonatomic) IBOutlet UILabel *FaCardLable;
// 订单金额



@property (weak, nonatomic) IBOutlet UIButton *daiUpdateBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderCode;
@property (weak, nonatomic) IBOutlet UILabel *orderState;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UIImageView *orderTitlePic;
@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UILabel *orderAddress;
@property (weak, nonatomic) IBOutlet UILabel *orderServerTiem;
@property (weak, nonatomic) IBOutlet UILabel *orderFaName;
@property (weak, nonatomic) IBOutlet UILabel *orderFaContent;
@property (weak, nonatomic) IBOutlet UILabel *orderTotal;
@property (weak, nonatomic) IBOutlet UILabel *orderServerPrice;
@property (weak, nonatomic) IBOutlet UILabel *orderCouponPice;
@property (weak, nonatomic) IBOutlet UILabel *orderPointPrice;
- (IBAction)payBtn:(id)sender;
- (IBAction)updateClick:(id)sender;

// 三个按钮
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiquanBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

//待确认
@property (weak, nonatomic) IBOutlet UILabel *daiOkLable;
@property (weak, nonatomic) IBOutlet UIButton *daiOkBtn;



@end
