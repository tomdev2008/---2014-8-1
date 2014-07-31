//
//  ApplyViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-7-7.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) NSString *aid;

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *addressText;

@property (weak, nonatomic) IBOutlet UIView *backView;


@property (weak, nonatomic) IBOutlet UIView *hideView;



- (IBAction)joinClick:(id)sender;


@end
