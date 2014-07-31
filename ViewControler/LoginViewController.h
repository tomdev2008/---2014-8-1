//
//  LoginViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-5-28.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
@interface LoginViewController : UIViewController <UITextFieldDelegate>

- (IBAction)loginBtnClick:(id)sender;
- (IBAction)regiestBtnClick:(id)sender;
- (IBAction)findPwdClick:(id)sender;
- (IBAction)backClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)sinaClick:(id)sender;
- (IBAction)qqZoneClick:(id)sender;

// 跳转的类型
@property (nonatomic) int loginPageType;    // 1 注册  0 其他

@end
