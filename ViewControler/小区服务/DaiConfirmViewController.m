//
//  DaiConfirmViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-8.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "DaiConfirmViewController.h"
#import "DownLoadManager.h"
#import "AppDelegate.h"
#import "MyNavigationBar.h"

@interface DaiConfirmViewController ()

@end

@implementation DaiConfirmViewController
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

- (void)createNavigation
{
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"小区服务" andLeftButtonImage:nil andRightButtonImage:@"默认发起对话的icon.png" andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bbiItem:(UIButton *)bbi
{
    if(bbi.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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

@end
