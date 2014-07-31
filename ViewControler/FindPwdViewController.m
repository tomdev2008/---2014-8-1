//
//  FindPwdViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-28.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "FindPwdViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "ZL_CONST.h"
#import "DownLoadManager.h"

@interface FindPwdViewController ()

@end

@implementation FindPwdViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
    UITextField *phoneText;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     self.hidesBottomBarWhenPushed = YES;   // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createUI];
}

- (void)createUI
{
    // 导航条
    _dm = [DownLoadManager shareDownLoadManager];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 46)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"找回密码" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem) andClass:self];
    [self.view addSubview:mnb];
    
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, 17, 20);
    leftView.backgroundColor = [UIColor clearColor];
    
    phoneText = [[UITextField alloc] init];
    phoneText.frame = CGRectMake(20, mnb.frame.size.height+40, 280, 35);
    phoneText.placeholder = @"请输入您的手机号码";
    [phoneText setLeftViewMode:UITextFieldViewModeAlways];
    [phoneText setBorderStyle:UITextBorderStyleNone];
    phoneText.keyboardType = UIKeyboardTypeNumberPad;
    [phoneText setBackground:[UIImage imageNamed:@"输入框.png"]];
    phoneText.leftViewMode = UITextFieldViewModeAlways;
    phoneText.clearButtonMode = UITextFieldViewModeAlways;
    phoneText.leftView = leftView;
    [self.view addSubview:phoneText];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(20, mnb.frame.size.height+95, 280, 35);
    [okBtn setBackgroundImage:[UIImage imageNamed:@"门栋号选择_07-17.png"] forState:UIControlStateNormal];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];

}

- (void)bbiItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnClick
{
    [_dm userForgetPwd:phoneText.text];
    [_dm setSendMessageSuccess:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
