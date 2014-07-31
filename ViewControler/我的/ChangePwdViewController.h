//
//  ChangePwdViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePwdViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *xinPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *rePassword;

- (IBAction)changeClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *backView;

- (IBAction)textDidBegin:(id)sender;



@end
