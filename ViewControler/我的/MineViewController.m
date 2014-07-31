//
//  MineViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "MineViewController.h"
#import "MyNavigationBar.h"
#import "MyServerViewController.h"
#import "MyPointViewController.h"
#import "MySaleCarViewController.h"
#import "SetViewController.h"
#import "ChangePwdViewController.h"
#import "PersonInfoViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ZL_CONST.h"
#import "Login_480_ViewController.h"
#import "MyPrivateViewController.h"
#import "AppUtil.h"
#import "ZL_INTERFACE.h"
#import "DownLoadManager.h"
#import "UIImageView+WebCache.h"
#import "MMLocationManager.h"
#import "MyHouseViewController.h"
#import "LoginViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
    UILabel *_addressLabel;
    User *_user;
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
    _app.mtb.hidden = NO;
    
    _dm = [DownLoadManager shareDownLoadManager];
    //_app.isFirst_nei = 1; zhaoheng
    if(_dm.myUserId == nil)
    {
        if(isRetina.size.height > 480)
        {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        }
        else
        {
            Login_480_ViewController *login = [[Login_480_ViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        }
    }
    else
    {
        [self hideNeed];
        [self createTitle];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    __block MineViewController *blockSelf=  self;
    _dm = [DownLoadManager shareDownLoadManager];
    [_dm getMyUserInfo];
    [_dm setGetMyUserInfoBlock:^(User *user) {
        blockSelf -> _user = user;
        [blockSelf createTitle];
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    __block MineViewController *blockSelf=  self;
    _dm = [DownLoadManager shareDownLoadManager];
    [_dm getMyUserInfo];
    [_dm setGetMyUserInfoBlock:^(User *user) {
        blockSelf -> _user = user;

    }];

    
    // 初始化
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"我的" andLeftButtonImage:nil andRightButtonImage:@"设置.png" andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
}

// 是否是商户
- (void)hideNeed
{
    if(![_dm.loginType isEqualToString:@"0"])
    {
        self.shopPersonView.hidden = NO;
    }
    else
    {
        self.shopPersonView.hidden = YES;
    }
}

// 创建title
- (void)createTitle
{
    UIImageView *backImage = [[UIImageView alloc] init];
    backImage.frame = CGRectMake(0, is_IPHONE_6?44:64, 320, 100);
    backImage.image = [UIImage imageNamed:@"说说背景.png"];
    backImage.userInteractionEnabled = YES;
    [self.view addSubview:backImage];
    
    
    UIImageView *headButton = [[UIImageView alloc] init];
    headButton.frame = CGRectMake(10, (100-46)/2, 46, 46);
    [headButton setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,_user.userFace]]];
    headButton.tag = 101;
    [backImage addSubview:headButton];
    
    // 用户名
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(headButton.frame.origin.x+headButton.frame.size.width+20, 40, 200, 20);
    if(_dm.myUserId != nil)
    {
        label.text = _user.userNickName;
    }
    else
    {
        label.text = @"点击头像进行登录";
    }
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    [backImage addSubview:label];

}




- (void)bbiItem:(UIButton *)button
{
    if(button.tag == 2)
    {
        SetViewController *set = [[SetViewController alloc] init];
        [self.navigationController pushViewController:set animated:YES];
    }
    else if(button.tag == 101)
    {
        if(![_dm.status isEqualToString:@"200"])
        {
            if(isRetina.size.height > 480)
            {
                LoginViewController *login = [[LoginViewController alloc] init];
                login.navigationController.hidesBottomBarWhenPushed = NO;
                [self.navigationController pushViewController:login animated:YES];
            }
            else
            {
                Login_480_ViewController *login_480 = [[Login_480_ViewController alloc] init];
                [self.navigationController pushViewController:login_480 animated:YES];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 点击我的消费
- (IBAction)myServerClick:(id)sender
{
    MyServerViewController *myServer = [[MyServerViewController alloc] init];
    [self.navigationController pushViewController:myServer animated:YES];
}

// 点击我的积分
- (IBAction)myPointClick:(id)sender
{
    MyPointViewController *myPoint = [[MyPointViewController alloc] init];
    [self.navigationController pushViewController:myPoint animated:YES];
}

// 点击了我的房产
- (IBAction)mySaleCarClick:(id)sender
{
    MyHouseViewController *myHouse = [[MyHouseViewController alloc] init];
    [self.navigationController pushViewController:myHouse animated:YES];
}
// 点击修改密码
- (IBAction)changePwdClick:(id)sender
{
    ChangePwdViewController *changePwd = [[ChangePwdViewController alloc] init];
    [self.navigationController pushViewController:changePwd animated:YES];
}

// 点击二维码扫描
- (IBAction)zbarClick:(id)sender
{
    
}

// 点击我的资料
- (IBAction)myPersonInfoClick:(id)sender
{
    PersonInfoViewController *personInfo = [[PersonInfoViewController alloc] init];
    [self.navigationController pushViewController:personInfo animated:YES];
}

// 点击我的隐私
- (IBAction)myPrivateClick:(id)sender
{
    MyPrivateViewController *myPrivate = [[MyPrivateViewController alloc] init];
    [self.navigationController pushViewController:myPrivate animated:YES];
}
@end
