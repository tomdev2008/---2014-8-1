//
//  DaiOk_SViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-21.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "DaiOk_SViewController.h"
#import "DownLoadManager.h"
#import "AppDelegate.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "MyNavigationBar.h"
#import "ServerClassViewController.h"

@interface DaiOk_SViewController ()

@end

@implementation DaiOk_SViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
    ServerDetail *_sd;
    UITableView *_tabelView;
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
    _backScrollView.frame = CGRectMake(0, 44, 320, is_IPHONE_6?568-64:480-44);
    _backScrollView.contentSize = CGSizeMake(320, 650);
}
- (void)createNavigation
{
    _dm = [DownLoadManager shareDownLoadManager];
    _sd = [[ServerDetail alloc] init];
    __block DaiOk_SViewController *blockSelf = self;
    [_dm getOrderServiceWithOid:self.oid];
    [_dm setOrderServerDetailBlock:^(ServerDetail *sd) {
        blockSelf -> _sd = sd;
        [blockSelf getData];
    }];
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"待确认服务" andLeftButtonImage:@"back.png" andRightButtonImage:@"默认发起对话的icon.png" andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
}

- (void)getData
{
    self.orderCode.text = [NSString stringWithFormat:@"订单号：%@",_sd.sdCode];
    self.orderState.text = [NSString stringWithFormat:@"状态：%@",_sd.sdState];
    self.orderTime.text = [NSString stringWithFormat:@"下订单时间：%@",_sd.sdOrder_Time];
    [self.orderImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,_sd.ssdTitlePic]]];
    self.orderNmae.text = _sd.ssdName;
    self.orderRealName.text = _sd.rsdName;
    self.orderPhone.text = _sd.rsdPhone;
    self.orderServerAddress.text = _sd.rsdRomm;
    self.orderServerTime.text = _sd.rsdDate_Time;
    
    // 服务明细
    [_tabelView reloadData];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigation];
    [self createTableView];
}

- (void)createTableView
{
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 287, 95) style:UITableViewStylePlain];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.backView addSubview:_tabelView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _sd.asdEvents.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    Server *server = [_sd.asdEvents objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@\t\t%@",server.serName,server.serCount];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0;
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

//取消订单
- (IBAction)cancleClick:(id)sender
{
    [_dm cancleOrderWithOid:self.oid];
    [_dm setSendMessageSuccess:^{
        NSLog(@"订单取消成功");
    }];
}

// 修改订单
- (IBAction)updateClick:(id)sender
{
    ServerClassViewController *serverClass = [[ServerClassViewController alloc] init];
    serverClass.Events = [[NSMutableArray alloc] init];
    [serverClass.Events addObject:_sd.asdEvents];
    [self.navigationController pushViewController:serverClass animated:YES];
}
@end
