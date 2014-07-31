//
//  DaiOkViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-18.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "DaiOkViewController.h"
#import "DownLoadManager.h"
#import "AppDelegate.h"
#import "ZL_CONST.h"
#import "LoadingView.h"
#import "ChangeNumViewController.h"
#import "MyNavigationBar.h"
#import "FillOrderInfoViewController.h"

@interface DaiOkViewController ()

@end

@implementation DaiOkViewController
{
    DownLoadManager *_dm;
    AppDelegate *_app;
    NSMutableArray *_dataArray;
    ServerDetail *_sd;
    LoadingView *_loadingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)viewDidAppear:(BOOL)animated
{
    _backScrollView.frame = CGRectMake(0, 44, 320, isRetina.size.height>480?568-44:480-44);
    _backScrollView.contentSize = CGSizeMake(320, 568);
    
    NSLog(@"-------%@-----%@",_dm.status,@"没有数据");
    if([_dm.status isEqualToString:@"400"])
    {
        [_loadingView loadingViewDispear:0.0];
    }
}

- (void)createNavigation
{
    
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"确认订单" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    _dm = [DownLoadManager shareDownLoadManager];
    _dataArray = [[NSMutableArray alloc] init];
    __block DaiOkViewController *blockSelf = self;
    [_dm getOrderServiceWithOid:self.serId];
    [_dm setOrderServerDetailBlock:^(ServerDetail *sd) {
        blockSelf -> _sd = sd;
        [blockSelf -> _dataArray addObjectsFromArray:sd.asdEvents];
        [blockSelf getData];
        [blockSelf->_loadingView loadingViewDispear:0];
    }];
}

- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
}

- (void)getData
{
    self.orderCode.text = _sd.sdCode;
    NSString *str;
    switch ([_sd.sdState intValue])
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

    self.orderState.text = [NSString stringWithFormat:@"%@",str];
    self.orderTime.text = _sd.sdOrder_Time;
    [self.orderImage setImageWithURL:[NSURL URLWithString:_sd.ssdTitlePic]];
    self.orderName.text = _sd.ssdName;
    self.orderRealName.text = _sd.rsdName;
    self.orderPhone.text = _sd.rsdPhone;
    self.orderAddresss.text = _sd.rsdRomm;
    self.orderServerTime.text = _sd.rsdDate_Time;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigation];
    [self createLoadView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)yesClick:(id)sender
{
    __block DaiOkViewController *blockSelf = self;
    [_dm conFirmOrderWithOid:self.serId];
    [_dm setSendMessageSuccess:^{
        FillOrderInfoViewController *fill = [[FillOrderInfoViewController alloc] init];
        fill.oid = blockSelf.serId;
        fill.comeId = 1;
        [blockSelf.navigationController pushViewController:fill animated:YES];
    }];
    
}
- (IBAction)serverClick:(id)sender
{
    ChangeNumViewController *changeNum = [[ChangeNumViewController alloc] init];
    changeNum.Events = [[NSMutableArray alloc] init];
    [changeNum.Events addObjectsFromArray:_sd.asdEvents];
    [self.navigationController pushViewController:changeNum animated:YES];
}
@end
