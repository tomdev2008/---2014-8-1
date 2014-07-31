//
//  DaiOk_SViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-7-21.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaiOk_SViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *oid;

@property (weak, nonatomic) IBOutlet UILabel *orderCode;
@property (weak, nonatomic) IBOutlet UILabel *orderState;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;

@property (weak, nonatomic) IBOutlet UILabel *orderNmae;
@property (weak, nonatomic) IBOutlet UIImageView *orderImage;
@property (weak, nonatomic) IBOutlet UIScrollView *serverScrollView;
@property (weak, nonatomic) IBOutlet UILabel *orderRealName;
@property (weak, nonatomic) IBOutlet UILabel *orderPhone;
@property (weak, nonatomic) IBOutlet UILabel *orderServerAddress;
@property (weak, nonatomic) IBOutlet UILabel *orderServerTime;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;
- (IBAction)cancleClick:(id)sender;
- (IBAction)updateClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
