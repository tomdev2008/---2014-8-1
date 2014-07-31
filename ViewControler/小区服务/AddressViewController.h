//
//  AddressViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-5.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>

- (IBAction)roomBtn:(id)sender;
- (IBAction)danyuanBtn:(id)sender;
- (IBAction)mendongBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *roomBtn;
@property (weak, nonatomic) IBOutlet UIButton *mendongBtn;
@property (weak, nonatomic) IBOutlet UIButton *danyuanBtn;

- (IBAction)addYesClick:(id)sender;
- (IBAction)cancleClick:(id)sender;

@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;



@end
