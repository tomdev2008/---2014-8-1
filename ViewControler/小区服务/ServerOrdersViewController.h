//
//  ServerOrdersViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-4.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CKCalendarView.h"

@interface ServerOrdersViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic) int sid;
@property (nonatomic, strong) NSString *rid;    // 门栋号 ID;


@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *serverTimer;

@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet UIButton *btnTime;
@property (weak, nonatomic) IBOutlet UIButton *btnAddress;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickeer;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)dateClick:(id)sender;
- (IBAction)timeClick:(id)sender;
- (IBAction)addressClick:(id)sender;
- (IBAction)datePickerClick:(id)sender;
- (IBAction)hideClic:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *hideBtn;


@property (weak, nonatomic) IBOutlet UIView *datePickerView;

@property (weak, nonatomic) IBOutlet UILabel *messageContent;



- (IBAction)serverOrderClick:(id)sender;

@end
