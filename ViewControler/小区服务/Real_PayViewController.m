//
//  Real_PayViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-30.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "Real_PayViewController.h"
#import "AppDelegate.h"
#import "MyNavigationBar.h"
#import "AutoPayViewController.h"
#import "DownLoadManager.h"
#import "ZL_CONST.h"
#import "PayInfoViewController.h"

@interface Real_PayViewController ()

@end

@implementation Real_PayViewController
{
    AppDelegate *_app;
    BOOL _recordTag;   // 记录是否点击过
    UITextField *_text;
    UIButton *speedBtn;
    NSMutableArray *_dataArray;
    DownLoadManager *_dm;
    LoadingView *_loadingView;
    
    //
    NSString *rid;
    NSString *name;
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
    NSLog(@"-------%@-----%@",_dm.status,@"没有数据");
    if([_dm.status isEqualToString:@"400"])
    {
        [_loadingView loadingViewDispear:0.0];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    _app = [UIApplication sharedApplication].delegate;
    _app.mtb.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.tabBarController.tabBar.hidden = YES;
    _dataArray = [[NSMutableArray alloc] init];
    _dm = [DownLoadManager shareDownLoadManager];
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"物业缴费" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];

    [_dm getRealPayListWithCid:_dm.communityId andPage:1];
    __block Real_PayViewController *blockSelf = self;
    [_dm setRealPayListBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf createContent];
        [_loadingView loadingViewDispear:0];
    }];

    // 创建页面内容
    [self createLoadView];
    
}

- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
}

// 创建页面内容
- (void)createContent
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44:64, 320, 548-44)];
    scrollView.contentSize = CGSizeMake(320, 580);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 50)];
    messageLabel.text = @"注：古铜色为催缴用户，如果您的门牌号是古铜色，请尽快缴费。";
    messageLabel.textColor = [UIColor darkGrayColor];
    messageLabel.numberOfLines = 2;
    messageLabel.font = [UIFont systemFontOfSize:15];
    [scrollView addSubview:messageLabel];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, 320, 1)];
    lineImageView.image = [UIImage imageNamed:@"line.png"];
    [scrollView addSubview:lineImageView];
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 80, 320, 330);
    [scrollView addSubview:backView];
    
    UIScrollView *roomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, 300, 260)];
    roomScrollView.contentSize = CGSizeMake(300, 400);
    roomScrollView.showsHorizontalScrollIndicator = YES;
    roomScrollView.showsVerticalScrollIndicator = YES;
    [backView addSubview:roomScrollView];
    
    // 创建Button按钮
    static int count = 0;
    for(int j = 0; j < _dataArray.count/3; j ++)
    {
        for(int i = 0; i < _dataArray.count; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(105*i,30*j, 90, 30);
            [button setTitle:[[_dataArray objectAtIndex:count] realName] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            if([[[_dataArray objectAtIndex:count] realUrge] isEqualToString:@"0"])
            {
                [button setBackgroundImage:[UIImage imageNamed:@"03.png"] forState:UIControlStateNormal];
            }
            else
            {
                [button setBackgroundImage:[UIImage imageNamed:@"01.png"] forState:UIControlStateNormal];
            }
            button.tag = 100+count;
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [roomScrollView addSubview:button];
        }
        count ++;
    }

    
    // 自助缴费
    UIButton *autoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    autoBtn.frame = CGRectMake(40, 350, 100, 30);
    [autoBtn setBackgroundImage:[UIImage imageNamed:@"立即参加.png"] forState:UIControlStateNormal];
    autoBtn.tag = 102;
    [autoBtn setTitle:@"自助缴费" forState:UIControlStateNormal];
    [autoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [autoBtn addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:autoBtn];
    
    // 快速缴费
    speedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    speedBtn.frame = CGRectMake(180, 350, 100, 30);
    [speedBtn setBackgroundImage:[UIImage imageNamed:@"门栋号选择_07-17.png"] forState:UIControlStateNormal];
    speedBtn.tag = 103;
    speedBtn.enabled = NO;
    [speedBtn setTitle:@"快速缴费" forState:UIControlStateNormal];
    [speedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [speedBtn addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:speedBtn];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_dataArray.count != 0)
    {
        return _dataArray.count/3;
    }
    else
    {
        return 1;
    }
}

- (void)bbiItem:(UIButton *)button
{
    if(button.tag == 1)
    {
        NSLog(@"您点击了返回按钮");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(button.tag == 103)
    {
        PayInfoViewController *payInfo = [[PayInfoViewController alloc] init];
        payInfo.unitRommStr = name;
        payInfo.rid = [rid intValue];
        [self.navigationController pushViewController:payInfo animated:YES];
        
    }
    else if(button.tag == 102)
    {
        AutoPayViewController *autoPay = [[AutoPayViewController alloc] init];
        [self.navigationController pushViewController:autoPay animated:YES];
    }
}

// 选择缴费点击触发事件
- (void)btnClick:(UIButton *)button
{
    if(!button.selected)
    {
        for(UIButton *btn in button.superview.subviews)
        {
            if([btn isKindOfClass:[UIButton class]])
            {
                btn.selected = NO;
            }
            else
            {
                continue;
            }
        }
        button.selected = YES;
        [button setTitleColor:[UIColor colorWithRed:0.05f green:0.64f blue:0.49f alpha:1.00f] forState: UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"02.png"] forState:UIControlStateSelected];
        speedBtn.enabled = YES;
    }
    else
    {
        button.selected = NO;
        speedBtn.enabled = NO;
    }
    rid = [[_dataArray objectAtIndex:button.tag-100] realId];
    name = [[_dataArray objectAtIndex:button.tag-100] realName];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _app.mtb.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
