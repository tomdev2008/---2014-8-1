//
//  Login_480_ViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-5.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>

@interface Login_480_ViewController : UIViewController <UITextFieldDelegate>

- (IBAction)backClick:(id)sender;

- (IBAction)loginClick:(id)sender;
- (IBAction)forgetPwdClick:(id)sender;

- (IBAction)regiestClick:(id)sender;
- (IBAction)sinaClick:(id)sender;
- (IBAction)qqZoneClick:(id)sender;

@property (nonatomic) int loginPageType;    // 1 注册 0其他


@end
