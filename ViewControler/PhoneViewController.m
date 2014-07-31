//
//  PhoneViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-28.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "PhoneViewController.h"
#import "ShareManager.h"
#import "MyNavigationBar.h"
#import "MineViewController.h"
#import "NeighborViewController.h"
#import "AppDelegate.h"
#import "ZL_CONST.h"
#import "DownLoadManager.h"
#import "Login_480_ViewController.h"
#import "LoginViewController.h"

@interface PhoneViewController ()

@end

@implementation PhoneViewController
{
    NSMutableArray *_textArray;
    AppDelegate *_app;
    DownLoadManager *_dm;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.hidesBottomBarWhenPushed = YES;  // Custom initialization
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
    
    // 初始化
    _dm = [DownLoadManager shareDownLoadManager];
    _textArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    
}
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI
{
    // 导航条
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 46)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"手机注册" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(backClick) andClass:self];
    [self.view addSubview:mnb];
    
    // 内容
    
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, 17, 20);
    leftView.backgroundColor = [UIColor clearColor];
    
    UIView *leftView_auth = [[UIView alloc] init];
    leftView_auth.frame = CGRectMake(0, 0, 17, 20);
    leftView_auth.backgroundColor = [UIColor clearColor];
    
    UITextField *phoneNoText = [[UITextField alloc] init];
    phoneNoText.frame = CGRectMake(20, mnb.frame.size.height+40, 280, 35);
    phoneNoText.placeholder = @"请输入您的手机号码";
    [phoneNoText setLeftViewMode:UITextFieldViewModeAlways];
    phoneNoText.leftView = leftView;
    phoneNoText.clearButtonMode = UITextFieldViewModeAlways;
    [phoneNoText setBorderStyle:UITextBorderStyleNone];
    [phoneNoText setBackground:[UIImage imageNamed:@"输入框.png"]];
    phoneNoText.delegate = self;
    [self.view addSubview:phoneNoText];
    
    UIButton *senderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    senderBtn.frame = CGRectMake(25, mnb.frame.size.height+75+20, 110, 35);
    [senderBtn setBackgroundImage:[UIImage imageNamed:@"门栋号选择_07.png"] forState:UIControlStateNormal];
    [senderBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    senderBtn.tag = 101;
    [senderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [senderBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:senderBtn];
    
    UITextField *authCodeText = [[UITextField alloc] init];
    authCodeText.frame = CGRectMake(20, mnb.frame.size.height+150, 280, 35);
    authCodeText.placeholder = @"验证码";
    [authCodeText setLeftViewMode:UITextFieldViewModeAlways];
    authCodeText.leftView = leftView_auth;
    [authCodeText setBorderStyle:UITextBorderStyleNone];
    [authCodeText setBackground:[UIImage imageNamed:@"输入框.png"]];
    authCodeText.delegate = self;
    [self.view addSubview:authCodeText];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(20, mnb.frame.size.height+205, 280, 35);
    [okBtn setBackgroundImage:[UIImage imageNamed:@"门栋号选择_07-17.png"] forState:UIControlStateNormal];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    okBtn.tag = 102;
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    [_textArray addObject:phoneNoText];
    [_textArray addObject:authCodeText];
}


// 触发点击事件
- (void)btnClick:(UIButton *)button
{
    __block PhoneViewController *blockSelf = self;
    switch (button.tag)
    {
        case 101:
        {
            if(((UITextField *)[_textArray objectAtIndex:0]).text !=nil)
            {
                [_dm sendCaptchaWithPhone:((UITextField *)[_textArray objectAtIndex:0]).text];
                [_dm setSendMessageSuccess:^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"验证码已经发送" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            break;
        }
        case 102:
        {
            if(((UITextField *)[_textArray objectAtIndex:0]).text !=nil && ((UITextField *)[_textArray objectAtIndex:1]).text !=nil)
            {
                [_dm getCheckCaptchaWithPhone:((UITextField *)[_textArray objectAtIndex:0]).text andCid:_dm.communityId andCode:((UITextField *)[_textArray objectAtIndex:1]).text];
                [_dm setSendMessageSuccess:^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"注册成功" delegate:blockSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请将信息填写完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            break;
        }
        case 103: case 104:
        {
            
            break;
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(isRetina.size.height > 480)
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.loginPageType = 0;    // 注册
        [self.navigationController pushViewController:login animated:YES];
    }
    else
    {
        Login_480_ViewController *login = [[Login_480_ViewController alloc] init];
        login.loginPageType = 0;    // 注册
        [self.navigationController pushViewController:login animated:YES];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITextField *text in _textArray)
    {
        [text resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
