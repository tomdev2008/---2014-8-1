//
//  DaiOkViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-7-18.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaiOkViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *orderCode;
@property (weak, nonatomic) IBOutlet UILabel *orderState;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UIImageView *orderImage;
@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UILabel *orderRealName;
@property (weak, nonatomic) IBOutlet UILabel *orderPhone;
@property (weak, nonatomic) IBOutlet UILabel *orderAddresss;
@property (weak, nonatomic) IBOutlet UILabel *orderServerTime;
- (IBAction)serverClick:(id)sender;
- (IBAction)yesClick:(id)sender;

@property (nonatomic, strong) NSString *serId;

@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;


@end
