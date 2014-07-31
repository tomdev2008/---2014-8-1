//
//  ChangePwdViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "ZL_CONST.h"
#import "DownLoadManager.h"
#import "ZL_INTERFACE.h"

@interface ChangePwdViewController ()

@end

@implementation ChangePwdViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    _app = [UIApplication sharedApplication].delegate;
    _app.mtb.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    _app.mtb.hidden = NO;
}
- (void)createNavigation
{
    
    _dm = [DownLoadManager shareDownLoadManager];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"修改密码" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    
    self.passwordText.delegate = self;
    self.xinPasswordText.delegate = self;
    self.rePassword.delegate = self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigation];
}

- (void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        _backView.frame = CGRectMake(0, 64, _backView.frame.size.width, _backView.frame.size.height);
    }];
    return  [textField resignFirstResponder];
}

// 确认修改
- (IBAction)changeClick:(id)sender
{
    __block ChangePwdViewController *blockSelf = self;
    if([self.passwordText.text isEqualToString:@""] || [self.xinPasswordText.text isEqualToString:@""] || [self.rePassword.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请正确输入信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        [_dm editPasswordWithPassword:self.passwordText.text andNewPassword:self.xinPasswordText.text andRePassword:self.rePassword.text];
        [_dm setSendMessageSuccess:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功" delegate:blockSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }];
    }
}

- (IBAction)textDidBegin:(id)sender
{
    // 开始编辑
    [UIView animateWithDuration:0.25 animations:^{
        _backView.frame = CGRectMake(0, -100, 320, 480);
    }];
}
@end
