//
//  MyPrivateViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-9.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "MyPrivateViewController.h"
#import "AppDelegate.h"
#import "ZL_CONST.h"
#import "MyNavigationBar.h"
#import "BlackListViewController.h"

@interface MyPrivateViewController ()

@end

@implementation MyPrivateViewController
{
    AppDelegate *_app;
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
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"我的隐私" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
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

// 不看他的邻居说
- (IBAction)neighborClick:(id)sender
{
    BlackListViewController *black = [[BlackListViewController alloc] init];
    black.type = 0;
    [self.navigationController pushViewController:black animated:YES];
}

// 不看他的消息
- (IBAction)messageClick:(id)sender
{
    BlackListViewController *black = [[BlackListViewController alloc] init];
    black.type = 1;
    [self.navigationController pushViewController:black animated:YES];
}
@end
