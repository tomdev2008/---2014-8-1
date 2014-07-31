//
//  FillOrderInfoViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-7-8.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceViewController.h"
#import "OrderInfo.h"
#import "ChangeNumViewController.h"

@interface FillOrderInfoViewController : UIViewController <InvoiceViewControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate, ChangeNumViewControllerDelegate>

- (void)changeAddressAndInvoiceInfoWithName:(NSString *)name;
@property (nonatomic, strong) NSString *serId;
@property (nonatomic) int comeId;   // 如果是从我的 1  否则是0;  商户版  2
@property (nonatomic, strong) NSString *oid;        // 订单Id;

@end
