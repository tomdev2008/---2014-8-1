//
//  ServerOrderViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "ServerOrderViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "SubScribeViewController.h"
#import "ZL_CONST.h"
#import "DownLoadManager.h"
#import "ZL_INTERFACE.h"

@interface ServerOrderViewController ()

@end

@implementation ServerOrderViewController
{
    AppDelegate *_app;
    UITableView *_tableView;
    DownLoadManager *_dm;
    NSMutableArray *_dataArray;
    LoadingView *_loadingView;
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

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"-------%@-----%@",_dm.status,@"没有数据");
    if([_dm.status isEqualToString:@"400"])
    {
        [_loadingView loadingViewDispear:0.0];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",_orderId);
	// Do any additional setup after loading the view.
    // 初始化
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"服务订单" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    
    _dataArray = [[NSMutableArray alloc] init];
    _dm = [DownLoadManager shareDownLoadManager];
    __block ServerOrderViewController *blockSelf = self;
    [_dm getOrderServerInfoWithOsid:[_orderId intValue]];
    [_dm setOrderServerInfoBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
        [_loadingView loadingViewDispear:0];
    }];
    // 创建TabelView;
    [self createTableView];
    [self createLoadView];
}

- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
}

// 创建TabelView;
- (void)createTableView
{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44:64, 320, isRetina.size.height>480?568-44:480-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// 创建section0Cell
- (void)createSection0Cell:(UITableViewCell *)cell
{
    OrderInfo *order = [_dataArray objectAtIndex:0];
    // 订单号
    UILabel *orderLabel = [[UILabel alloc] init];
    orderLabel.frame = CGRectMake(10, 15, 200, 20);
    orderLabel.text = [NSString stringWithFormat:@"订单号：%@",order.oinfoCode];
    orderLabel.textColor = [UIColor darkGrayColor];
    orderLabel.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:orderLabel];
    
    // 状态
    UILabel *stateLabel = [[UILabel alloc] init];
    stateLabel.frame = CGRectMake(orderLabel.frame.size.width+30, 15, 100, 20);
    NSString *str;
    switch ([order.oinfoState intValue])
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
    stateLabel.text = [NSString stringWithFormat:@"状态：%@",str];
    stateLabel.textColor = [UIColor darkGrayColor];
    stateLabel.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:stateLabel];
    
    // 下订单时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.frame =  CGRectMake(10,stateLabel.frame.origin.y+35, 300, 20);
    timeLabel.text = [NSString stringWithFormat:@"下订单时间：%@",order.oinfoOrder_Time];
    timeLabel.textColor =[UIColor darkGrayColor];
    timeLabel.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:timeLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    imageView.frame = CGRectMake(0, timeLabel.frame.origin.y+35, 320, 1);
    [cell.contentView addSubview:imageView];
}

// 创建Section1Cell
- (void)createSection1Cell:(UITableViewCell *)cell
{
    OrderInfo *order = [_dataArray objectAtIndex:0];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(10, 10, 100, 20);
    titleLabel.text = @"服务内容";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [cell.contentView addSubview:titleLabel];
    
    // 背景
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10, titleLabel.frame.origin.y+30, 300, 80);
    imageView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [cell.contentView addSubview:imageView];
    
    // titleImage
    UIImageView *titleImageView = [[UIImageView alloc] init];
    titleImageView.frame = CGRectMake(10, 10, 60, 60);
    [titleImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,order.seTitlePic]]];
    [imageView addSubview:titleImageView];
    
    // content
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(titleImageView.frame.origin.x + 90, 30, 150, 20);
    contentLabel.text = order.seName;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textColor = [UIColor darkGrayColor];
    contentLabel.font = [UIFont systemFontOfSize:15];
    [imageView addSubview:contentLabel];
    
    // >
    UIImageView *rightImageView = [[UIImageView alloc] init];
    rightImageView.frame = CGRectMake(imageView.frame.size.width-30, contentLabel.frame.origin.y, 25, 25);
    rightImageView.image = [UIImage imageNamed:@"右边.png"];
    [imageView addSubview:rightImageView];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    lineImageView.frame = CGRectMake(0, 145, 320, 1);
    [cell.contentView addSubview:lineImageView];
}

- (void)createSection2Cell:(UITableViewCell *)cell
{
    OrderInfo *order = [_dataArray objectAtIndex:0];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(10, 10, 200, 20);
    titleLabel.text = @"预约服务地址及时间";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [cell.contentView addSubview:titleLabel];
    
    // 背景
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10, titleLabel.frame.origin.y+30, 300,80);
    imageView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [cell.contentView addSubview:imageView];
    
    // 地址
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.frame = CGRectMake(10, 15, 280, 40);
    addressLabel.text = [NSString stringWithFormat:@"预约服务地址：%@",order.addAddress];
    addressLabel.textColor = [UIColor darkGrayColor];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.numberOfLines = 0;
    addressLabel.font = [UIFont systemFontOfSize:13];
    [imageView addSubview:addressLabel];
    
    // 时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = [NSString stringWithFormat:@"预约服务时间：%@",order.oinfoOrder_Time];
    timeLabel.textColor = [UIColor darkGrayColor];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.frame = CGRectMake(10, addressLabel.frame.origin.y+30, 280, 20);
    [imageView addSubview:timeLabel];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    if(_dataArray.count > 0)
    {
        if(indexPath.section == 0)
        {
            // 订单号
            [self createSection0Cell:cell];
        }
        else if(indexPath.section == 1)
        {
            // 服务内容
            [self createSection1Cell:cell];
        }
        else if(indexPath.section == 2)
        {
            [self createSection2Cell:cell];
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 95.f;
    }
    else if(indexPath.section == 1)
    {
        return 146.0f;
    }
    else if(indexPath.section == 2)
    {
        return 120.0f;
    }
    return 0;
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
