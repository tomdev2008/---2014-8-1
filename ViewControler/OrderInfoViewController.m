//
//  OrderInfoViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-24.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "DownLoadManager.h"
#import "serverPriceView.h"
#import "ServerClassViewController.h"

@interface OrderInfoViewController ()

@end

@implementation OrderInfoViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
    NSMutableArray *_dataArray;
    serverPriceView *_serverPriceView;
    LoadingView *_loadingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     self.hidesBottomBarWhenPushed = YES;   // Custom initialization
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated
{
    self.scrollVIew.frame = CGRectMake(0, 44, 320, 480);
    [self.scrollVIew setContentSize:CGSizeMake(320,480)];
    NSLog(@"-------%@-----%@",_dm.status,@"没有数据");
    if([_dm.status isEqualToString:@"400"])
    {
        [_loadingView loadingViewDispear:0.0];
    }

}
-  (void)viewWillAppear:(BOOL)animated
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
    
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"订单详情" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    
    [self createLoadView];
    
    _serverPriceView = [[serverPriceView alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    _dm = [DownLoadManager shareDownLoadManager];
    __block OrderInfoViewController *blockSelf = self;
    [_dm getOrderServerInfoWithOsid:_osid];
    [_dm setOrderServerInfoBlock:^(NSArray *array) {
        OrderInfo *orderInfo = [array objectAtIndex:0];
       blockSelf->_orderCodeLable.text = orderInfo.oinfoCode;
        NSString *str;
        switch ([orderInfo.oinfoState intValue])
        {
            case 0:str = @"无效";break;
            case 1:str = @"已呼叫";break;
            case 2:str = @"待确认";break;
            case 3:str = @"待下单";break;
            case 4:str = @"待付款";break;
            case 5:str = @"待提供服务";break;
            case 6:str = @"待确认服务";break;
            case 7:str = @"待评价";break;
            case 8:str = @"退换货";break;
            case 9:str = @"已完成";break;
        }
        blockSelf->_stateLable.text =  str;
        blockSelf->_orderTimeLable.text = orderInfo.oinfoOrder_Time;
        [blockSelf->_serverImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,orderInfo.seTitlePic]]];
        blockSelf->_contentLable.text = orderInfo.seName;
        blockSelf->_nameLable.text = orderInfo.reName;
        blockSelf->_phoneLable.text = orderInfo.rePhone;
        blockSelf->_addressLable.text = @"。。。";    // 地址暂无
        blockSelf->_serverTimeLable.text = orderInfo.reDate_time;
        [blockSelf -> _loadingView loadingViewDispear:0];
    }];
    if([_dm.loginType isEqualToString:@"0"])
    {
        _nameLable.hidden = YES;
        _phoneLable.hidden = YES;
    }
    if(self.orderType == 2)
    {
        [self.changeBtn setTitle:@"确认" forState:UIControlStateNormal];
    }
}
- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
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

// 下订单
- (IBAction)orderClick:(id)sender
{
    ServerClassViewController *serverClass = [[ServerClassViewController alloc] init];
    serverClass.sid = [NSString stringWithFormat:@"%d",self.osid];
    [self.navigationController pushViewController:serverClass animated:YES];
}

// 点击服务内容
- (IBAction)tgrClick:(id)sender
{
    NSLog(@"点击服务内容");
}
@end
