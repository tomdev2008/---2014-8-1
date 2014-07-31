//
//  DaiPay_ManagerTableViewCell.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-14.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "DaiPay_ManagerTableViewCell.h"
#import "DownLoadManager.h"
#import "AppDelegate.h"
#import "MyNavigationBar.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "OrderUpdateCell.h"

@interface DaiPay_ManagerTableViewCell ()

@end

@implementation DaiPay_ManagerTableViewCell
{
    AppDelegate *_app;
    DownLoadManager *_dm;
    ServerDetail *_sd;
    LoadingView *_loadingView;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)createNavigation
{
    _dm = [DownLoadManager shareDownLoadManager];
    _dataArray = [[NSMutableArray alloc] init];
    __block DaiPay_ManagerTableViewCell *blockSelf = self;
    [_dm getOrderServiceWithOid:self.orderId];
    [_dm setOrderServerDetailBlock:^(ServerDetail *sd) {
        blockSelf -> _sd = sd;
        [blockSelf -> _dataArray addObjectsFromArray:sd.asdEvents];
        [blockSelf getData];
        [blockSelf->_loadingView loadingViewDispear:0];
        [blockSelf -> _tableView reloadData];
    }];
    
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"服务订单" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    [self createLoadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigation];
    [self createTableView];
    [self createLoadView];
}

// 隐藏按钮  或者 view用
- (void)hideOrderType
{
    switch(self.orderType)
    {
        case 4: // 待支付
            self.paySelectView.hidden = YES;
            self.myServerBtn.hidden = YES;
            break;
        case 5://  我已提供服务
            break;
    }
}

- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
}

// 给控件赋值
- (void)getData
{
    self.orderCodeLable.text = [NSString stringWithFormat:@"订单号:%@",_sd.sdCode];
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
    
    self.orderStateLable.text = [NSString stringWithFormat:@"状态:%@",str];
    self.orderTimeLable.text = [NSString stringWithFormat:@"下订单时间:%@",_sd.sdOrder_Time];
    [self.serverImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,_sd.ssdTitlePic]]];
    self.serverName.text = _sd.ssdName;
    self.orderServerAddressLable.text = _sd.asdaddress;
    self.orderServerTimeLable.text = _sd.rsdDate_Time;
    self.faCardLable.text = _sd.sdInvoice_t;
    self.faCardContentLable.text = _sd.sdInvoice_s;
    self.orderPrice.text = [NSString stringWithFormat:@"订单金额：￥ %@",_sd.sdTotal];
    //self.orderServerPrice.text =
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 96) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.serverScrollView addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_dataArray.count > 0)
    {
        return _dataArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    OrderUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[OrderUpdateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    if(_dataArray.count > 0)
    {
        Server *server = [_dataArray objectAtIndex:indexPath.row];
        cell.contentLabel.text = server.serName;
        cell.plusBtn.hidden = YES;
        cell.reduceBtn.hidden = YES;
        cell.numLable.text = server.serCount;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

- (void)viewDidAppear:(BOOL)animated
{
    _scrollView.frame = CGRectMake(0, 44, 320, isRetina.size.height>480?568-44:480-44);
    _scrollView.contentSize = CGSizeMake(320, 770);
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
- (void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
