//
//  NeighborPageViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-7.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "NeighborPageViewController.h"
#import "DownLoadManager.h"
#import "AppDelegate.h"
#import "MyNavigationBar.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "LoadingView.h"
#import "SendMessageViewController.h"
#import "Login_480_ViewController.h"
#import "LoginViewController.h"

@interface NeighborPageViewController ()

@end

@implementation NeighborPageViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
    User *_user;
    LoadingView *_loadingView;
}
- (void)createNavigation
{
    _dm = [DownLoadManager shareDownLoadManager];
    __block NeighborPageViewController *blockSelf = self;
    [_dm getSayUserInfoWithUid:self.neighobrId];
    [_dm setSayUserInfoBlock:^(User *user) {
        blockSelf -> _user = user;
        [blockSelf createContent];
        [_loadingView loadingViewDispear:0];
    }];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"邻居信息" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
}

- (void)createContent
{
    self.userNickName.text = _user.userNickName;
    [self.userFace setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,_user.userFace]]];
    self.userSex.text = [_user.userSex isEqualToString:@"0"]?@"女":@"男";
    self.userAge.text = @"不知道";
    self.userProfession.text = _user.userProfession;
    self.userFavorite.text = @"不知道";
    self.userContent.text = @"不知道";
    self.userphone.text = _user.userPhone;
    self.userRealName.text = _user.userName;
    self.userSay.text = @"不知道";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.hidesBottomBarWhenPushed = YES;  // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigation];
    [self createLoadView];
}

- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)bbiItem:(UIButton *)button
{
    if(button.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    _scrollView.frame = CGRectMake(0, 44, 320, 480);
    if(isRetina.size.height > 480)
    {
        _scrollView.contentSize = CGSizeMake(320, 450);
    }
    else
    {
         _scrollView.contentSize = CGSizeMake(320, 500);
    }
    NSLog(@"-------%@-----%@",_dm.status,@"没有数据");
    if([_dm.status isEqualToString:@"400"])
    {
        [_loadingView loadingViewDispear:0.0];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if([self.neighobrId isEqualToString:_dm.myUserId])
    {
        self.sendMsgBtn.hidden = YES;
    }
    _app = [UIApplication sharedApplication].delegate;
    _app.mtb.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    _app.mtb.hidden = NO;
}

// 发消息
- (IBAction)sendMessageClick:(id)sender
{
    if(_dm.myUserId != nil)
    {
        SendMessageViewController *send = [[SendMessageViewController alloc]init];
        send.userId = self.neighobrId;
        send.userFace = _user.userFace;
        send.name = _user.userName;
        [self.navigationController pushViewController:send animated:YES];
    }
    else
    {
        if(isRetina.size.height > 480)
        {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:NO];
        }
        else
        {
            Login_480_ViewController *login = [[Login_480_ViewController alloc] init];
            [self.navigationController pushViewController:login animated:NO];
        }

    }
}
@end
