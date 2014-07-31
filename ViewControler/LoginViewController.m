//
//  LoginViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-28.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "LoginViewController.h"
#import "RegiestViewController.h"
#import "FindPwdViewController.h"
#import "AppDelegate.h"
#import "DownLoadManager.h"
#import "ZL_INTERFACE.h"
#import "ZL_CONST.h"
#import "CommunityViewController.h"

#import "NeighborViewController.h"
#import "PersonServerViewController.h"
#import "MessageViewController.h"
#import "ActivityViewController.h"
#import "MineViewController.h"
#import "OrderManagerViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
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
    // Do any additional setup after loading the view from its nib.
    
    // 初始化
    self.tabBarController.tabBar.hidden = YES;
    _textArray = [[NSMutableArray alloc] init];
    self.tabBarController.tabBar.hidden = YES;
    _dm = [DownLoadManager shareDownLoadManager];
    
    [self createTextFiled];
    
}


// 用户名  密码框
- (void)createTextFiled
{
    // chushiha账号 密码
    UIView *lgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    [lgView setBackgroundColor:[UIColor clearColor]];
    UIImageView *loginImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"用户名.png"]];
    loginImageView.frame = CGRectMake(10, 3, 22, 22);
    [lgView addSubview:loginImageView];

    
    UITextField *loginFiled = [[UITextField alloc] init];
    loginFiled.frame = CGRectMake(20, 143, 280, 43);
    loginFiled.borderStyle = UITextBorderStyleNone;
    loginFiled.background = [UIImage imageNamed:@"登录框.png"];
    loginFiled.leftView = lgView;
    loginFiled.delegate = self;
    loginFiled.textColor = [UIColor whiteColor];
    // 设置账户
    [loginFiled setLeftViewMode:UITextFieldViewModeAlways];
    [self.view addSubview:loginFiled];
    
    
    UIView *psView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    [psView setBackgroundColor:[UIColor clearColor]];
    UIImageView *passwordImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"密码.png"]];
    passwordImageView.frame = CGRectMake(10, 3, 22, 22);
    [psView addSubview:passwordImageView];
    
    UITextField *passwordField = [[UITextField alloc] init];
    passwordField.frame = CGRectMake(20, 200, 280, 43);
    passwordField.borderStyle = UITextBorderStyleNone;
    passwordField.background = [UIImage imageNamed:@"登录框.png"];
    passwordField.leftView = psView;
    passwordField.delegate = self;
    passwordField.secureTextEntry = YES;
    passwordField.textColor =[UIColor whiteColor];
    [passwordField setLeftViewMode:UITextFieldViewModeAlways];
    [self.view addSubview:passwordField];
    
    //
    User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:[AppUtil dataPath]];
    if(user.userId != nil)
    {
        loginFiled.text = user.userPhone;
        passwordField.text = user.userPassword;
    }
    [_textArray addObject:loginFiled];
    [_textArray addObject:passwordField];
}

// 状态栏颜色 白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


// 实现textFiled 的协议方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITextField *text in _textArray)
    {
        [text resignFirstResponder];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 点击登录
- (IBAction)loginBtnClick:(id)sender
{
    [_dm userLoginWithPhone:((UITextField *)[_textArray objectAtIndex:0]).text withPassword:((UITextField *)[_textArray objectAtIndex:1]).text andDid:_app.LoaginDeviceId andDtype:2];
    __block LoginViewController *login = self;
    [_dm setLoginSuccessBlcok:^(User *user){
        [NSKeyedArchiver archiveRootObject:user toFile:[AppUtil dataPath]];
        User *userss = [NSKeyedUnarchiver unarchiveObjectWithFile:[AppUtil dataPath]];
        userss.userPhone = ((UITextField *)[login -> _textArray objectAtIndex:0]).text;
        userss.userPassword = ((UITextField *)[login -> _textArray objectAtIndex:1]).text;
        userss.userNickName = user.userNickName;
        userss.userCommunity_Id = user.userCommunity_Id;
        userss.userLoginType = user.userLoginType;
        userss.userFace = user.userFace;
        userss.userCommunity_Type = user.userCommunity_Type;
        // 归档
        [login changeTBC];
        [NSKeyedArchiver archiveRootObject:userss toFile:[AppUtil dataPath]];
        [login judgeUser:login];
        
        
    }];
}

// 修改plist文件
- (void)changeTBC
{
    NSLog(@"%@",[_app.tbc.view subviews]);
}

- (void)judgeUser:(LoginViewController *)login
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderPerson" object:[NSNumber numberWithBool:[_dm.loginType isEqualToString:@"0"]]];

    if([_dm.loginType isEqualToString:@"0"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


// 点击注册
- (IBAction)regiestBtnClick:(id)sender
{
    RegiestViewController *regiest = [[RegiestViewController alloc] init];
    regiest.count = 1;
    [self.navigationController pushViewController:regiest animated:YES];
}

// 点击忘记密码
- (IBAction)findPwdClick:(id)sender
{
    FindPwdViewController *find = [[FindPwdViewController alloc] init];
    [self.navigationController pushViewController:find animated:YES];
}

// 点击返回按钮
- (IBAction)backClick:(id)sender
{
    if(_loginPageType != 1)
    {
        ((UIButton *)[[[_app.mtb.subviews objectAtIndex:_app.tbc.selectedIndex+1] subviews] objectAtIndex:0]).selected = NO;
        [(UILabel *)[[[_app.mtb.subviews objectAtIndex:_app.tbc.selectedIndex+1] subviews] objectAtIndex:1] setTextColor:[UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f]];
        _app.tbc.selectedIndex = 0;
        ((UIButton *)[[[_app.mtb.subviews objectAtIndex:_app.tbc.selectedIndex+1] subviews] objectAtIndex:0]).selected = YES;
        [(UILabel *)[[[_app.mtb.subviews objectAtIndex:_app.tbc.selectedIndex+1] subviews] objectAtIndex:1] setTextColor:[UIColor colorWithRed:0.12f green:0.63f blue:0.49f alpha:1.00f]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}




- (IBAction)sinaClick:(id)sender
{
//    
//    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
//                      authOptions:nil
//                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//                               
//                               if (result)
//                               {
//                                   PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
//                                   [query whereKey:@"uid" equalTo:[userInfo uid]];
//                                   [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                                       
//                                       if ([objects count] == 0)
//                                       {
//                                           PFObject *newUser = [PFObject objectWithClassName:@"UserInfo"];
//                                           [newUser setObject:[userInfo uid] forKey:@"uid"];
//                                           [newUser setObject:[userInfo nickname] forKey:@"name"];
//                                           [newUser setObject:[userInfo profileImage] forKey:@"icon"];
//                                           [newUser saveInBackground];
//                                           
//                                           NSLog(@"%@",newUser);
//                                           
//                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"你好" message:@"欢迎注册" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//                                           [alertView show];
//                                       }
//                                       else
//                                       {
//                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[userInfo nickname] message:@"欢迎回来" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//                                           [alertView show];
//                                       }
//                                   }];
//                                   
//                                   [self.navigationController popViewControllerAnimated:YES];
//                                   
//                               }
//                               
//                           }];
}

// qq空间
- (IBAction)qqZoneClick:(id)sender
{
//    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//        if(result)
//        {
//            PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
//            [query whereKey:@"uid" equalTo:[userInfo uid]];
//            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                
//                if ([objects count] == 0)
//                {
//                    PFObject *newUser = [PFObject objectWithClassName:@"UserInfo"];
//                    [newUser setObject:[userInfo uid] forKey:@"uid"];
//                    [newUser setObject:[userInfo nickname] forKey:@"name"];
//                    [newUser setObject:[userInfo profileImage] forKey:@"icon"];
//                    [newUser saveInBackground];
//                    
//                    NSLog(@"%@",newUser);
//                    
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"你好" message:@"欢迎注册" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//                    [alertView show];
//                }
//                else
//                {
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[userInfo nickname] message:@"欢迎回来" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//                    [alertView show];
//                }
//            }];
//            
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }];
}

@end

