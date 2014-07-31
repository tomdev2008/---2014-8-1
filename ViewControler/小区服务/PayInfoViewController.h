//
//  PayInfoViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-5-30.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayInfoViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) NSString *unitRommStr;
@property (weak, nonatomic) IBOutlet UIButton *unitRoomBtn;

@property (nonatomic) int rid;

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *sign;

@property (nonatomic, strong) NSString *start;
@property (nonatomic, strong) NSString *end;
@property (nonatomic, strong) NSString *pMoney;

@end
