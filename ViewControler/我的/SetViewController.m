//
//  SetViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "SetViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "ZL_CONST.h"
#import "DownLoadManager.h"

@interface SetViewController ()

@end

@implementation SetViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.hidesBottomBarWhenPushed = YES; // Custom initialization
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
    _dm = [DownLoadManager shareDownLoadManager];
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"设置" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];

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

- (IBAction)aboutClick:(id)sender {
}

- (IBAction)versionClick:(id)sender {
}

- (IBAction)messagePullClick:(id)sender {
}

// 退出登录
- (IBAction)loginOutClick:(id)sender
{
    //User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:[AppUtil dataPath]];
    _dm.myUserId = nil;
    User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:[AppUtil dataPath]];
    user.userCommunity_Id =  0;
    [NSKeyedArchiver archiveRootObject:user toFile:[AppUtil dataPath]];
    
    
    UIAlertView *alerver = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出登录成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alerver show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ((UIButton *)[[[_app.mtb.subviews objectAtIndex:_app.tbc.selectedIndex+1] subviews] objectAtIndex:0]).selected = NO;
    [(UILabel *)[[[_app.mtb.subviews objectAtIndex:_app.tbc.selectedIndex+1] subviews] objectAtIndex:1] setTextColor:[UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f]];
    _app.tbc.selectedIndex = 0;
    ((UIButton *)[[[_app.mtb.subviews objectAtIndex:_app.tbc.selectedIndex+1] subviews] objectAtIndex:0]).selected = YES;
    [(UILabel *)[[[_app.mtb.subviews objectAtIndex:_app.tbc.selectedIndex+1] subviews] objectAtIndex:1] setTextColor:[UIColor colorWithRed:0.12f green:0.63f blue:0.49f alpha:1.00f]];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
