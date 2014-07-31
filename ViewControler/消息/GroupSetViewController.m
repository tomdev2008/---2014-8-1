//
//  GroupSetViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-1.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "GroupSetViewController.h"
#import "AppDelegate.h"
#import "MyNavigationBar.h"
#import "DownLoadManager.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "AddressBookViewController.h"
#import "UpdatePersonInfoViewController.h"

@interface GroupSetViewController ()

@end

@implementation GroupSetViewController
{
    AppDelegate *_app;
    NSMutableArray *_dataArray;
    DownLoadManager *_dm;
    Group *_group;
    LoadingView *_loadingView;
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.hidesBottomBarWhenPushed = YES;  // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    // 初始化
    _dataArray = [[NSMutableArray alloc] init];
    _dm = [DownLoadManager shareDownLoadManager];
    _group = [[Group alloc] init];
    __block GroupSetViewController *blockSelf = self;
    [_dm selectGroupInfoWithGid:_groupId];
    [_dm setSelectGroupInfo:^(Group *group) {
        blockSelf -> _group = group;
        [blockSelf createHeadView];
        [blockSelf -> _loadingView loadingViewDispear:0];
    }];
    
    NSLog(@"-------%@-----%@",_dm.status,@"没有数据");
    if([_dm.status isEqualToString:@"400"])
    {
        [_loadingView loadingViewDispear:0.0];
    }
}

- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
}

- (void)createNavigation
{
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"群聊设置" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick:) andClass:self];
    [self.view addSubview:mnb];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self createLoadView];
    
}

- (void)createHeadView
{
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(10, 84, 300, 100);
    headView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [self.view addSubview:headView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    scrollView.contentSize = CGSizeMake(55*_group.groupArray.count+5, 50);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    [headView addSubview:scrollView];
    
    
    for(int i = 0; i < _group.groupArray.count+2; i ++)
    {
        if(i !=  _group.groupArray.count && i != _group.groupArray.count+1 )
        {
            UIImageView *headImage = [[UIImageView alloc] init];
            User *user = [ _group.groupArray objectAtIndex:i];
            headImage.frame = CGRectMake(10+50*i, 10, 45, 45);
            [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,user.userFace]]];
            [scrollView addSubview:headImage];
        }
        else if(i ==  _group.groupArray.count)
        {
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(10+50*i, 10, 45, 45);
            [addBtn setBackgroundImage:[UIImage imageNamed:@"新增.png"] forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            addBtn.tag = 30;
           [scrollView addSubview:addBtn];
        }
        else
        {
            UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            reduceBtn.frame = CGRectMake(10+50*i, 10, 45, 45);
            [reduceBtn setBackgroundImage:[UIImage imageNamed:@"解除.png"] forState:UIControlStateNormal];
            [reduceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            reduceBtn.tag = 40;
            [scrollView addSubview:reduceBtn];
        }
    }
    
    
    UIView *setView = [[UIView alloc] init];
    setView.frame = CGRectMake(10, headView.frame.origin.y+headView.frame.size.height+10, 300, 80);
    setView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [self.view addSubview:setView];
    
    // 群聊名称 系统通知
    UILabel *groupName = [[UILabel alloc] init];
    groupName.frame = CGRectMake(10, 10, 100, 20);
    groupName.text = @"群聊名称";
    groupName.font = [UIFont systemFontOfSize:15];
    groupName.textColor = [UIColor darkGrayColor];
    [setView addSubview:groupName];
    
    // 名称
    UILabel *name = [[UILabel alloc] init];
    name.frame = CGRectMake(groupName.frame.origin.x+80, 10, 180, 20);
    name.textAlignment = NSTextAlignmentRight;
    name.text = _group.groupName;
    name.font = [UIFont systemFontOfSize:15];
    name.textColor = [UIColor darkGrayColor];
    [setView addSubview:name];
    
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(groupName.frame.origin.x+80, 0, 180, 40)];
    [control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    [setView addSubview:control];
    
    UILabel *sysTation = [[UILabel alloc] init];
    sysTation.frame = CGRectMake(10, groupName.frame.origin.y+groupName.frame.size.height+10,100 , 20);
    sysTation.text = @"系统通知";
    sysTation.font = [UIFont systemFontOfSize:15];
    sysTation.textColor = [UIColor darkGrayColor];
    [setView addSubview:sysTation];
    
    // 开关
    UISwitch *swiths = [[UISwitch alloc] init];
    swiths.frame = CGRectMake(220, sysTation.frame.origin.y, 80, 30);
    if([_group.groupShield isEqualToString:@"0"])
    {
        swiths.on = YES;
    }
    else
    {
        swiths.on = NO;
    }
    [swiths addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
    [setView addSubview:swiths];
    
    
    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quitBtn.frame = CGRectMake(10, setView.frame.origin.y+setView.frame.size.height+20, 300, 30);
    quitBtn.tag = 10;
    [quitBtn setTitle:@"退出群聊" forState:UIControlStateNormal];
    [quitBtn setTintColor:[UIColor whiteColor]];
    [quitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [quitBtn setBackgroundImage:[UIImage imageNamed:@"手机注册_03.png"] forState:UIControlStateNormal];
    [self.view addSubview:quitBtn];
}

- (void)controlClick
{
    UpdatePersonInfoViewController *update = [[UpdatePersonInfoViewController alloc] init];
    update.tagNumber = 7;
    update.gid = self.groupId;
    [self.navigationController pushViewController:update animated:YES];
}

- (void)switchAction
{
    NSLog(@"switch");
}
- (void)btnClick:(UIButton *)button
{
    if(button.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(button.tag == 10)
    {
        // 退出群聊
        __block GroupSetViewController *blockSelf = self;
        [_dm quitGroupMessage:self.groupId];
        [_dm setQuetGroupSuccess:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出群组成功" delegate:blockSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }];
    }
    else if(button.tag == 30)
    {
        AddressBookViewController *address = [[AddressBookViewController alloc] init];
        address.comeType = 1;
        address.groupId = self.groupId;
        [self.navigationController pushViewController:address animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
