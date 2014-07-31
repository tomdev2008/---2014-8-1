//
//  MyServerViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "MyServerViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "FillOrderInfoViewController.h"
#import "ZL_CONST.h"
#import "PayRecordViewController.h"
#import "DownLoadManager.h"
#import "LoadingView.h"
#import "MyServer.h"
#import "ZL_INTERFACE.h"
#import "DZQCell.h"
#import "OrderInfoViewController.h"
// 待下单
#import "FillOrderInfoViewController.h"
// 待支付
#import "DaiPayViewController.h"
// 已呼叫
#import "ServerOrderViewController.h"
// 待确认
#import "DaiOkViewController.h"

@interface MyServerViewController ()

@end

@implementation MyServerViewController
{
    UIView *_backView;
    AppDelegate *_app;
    UITableView *_tableView;
    DownLoadManager *_dm;
    NSMutableArray *_dataArray;
    NSMutableArray *_allArray;
    LoadingView *_loadingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    self.hidesBottomBarWhenPushed = YES;    // Custom initialization
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
	// Do any additional setup after loading the view.
    
    // 初始化
    _dm = [DownLoadManager shareDownLoadManager];
    _dataArray = [[NSMutableArray alloc] init];
    _allArray = [[NSMutableArray alloc] init];
    _tagState = 100;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"我的服务" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    
    // 创建排序 筛选 搜索
    [self createAnimation];
    
    // 下载数据
    [self downLoadDataWithPage:1 andSelectTag:1];
    
    // 创建tableView
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

// 得到总数据
- (void)getAllArray
{
    for(int i = 0; i < _dataArray.count; i ++)
    {
        Order *order = [_dataArray objectAtIndex:i];
        [_allArray addObject:order];
    }
}
// 下载数据
- (void)downLoadDataWithPage:(int)page andSelectTag:(int)tag
{
    __block MyServerViewController *blockSelf = self;
    switch (tag)
    {
        case 1:
        {
            [_dm getMyOrderServeListWithPage:page];
            [_dm setMyOrderServerListBlock:^(NSArray *array) {
                [blockSelf -> _dataArray addObjectsFromArray:array];
                [blockSelf getAllArray];
                [blockSelf -> _tableView reloadData];
                [blockSelf -> _loadingView loadingViewDispear:0];
            }];
            break;
        }
        case 2:
        {
            [_dm getMyCouponListWithPage:page];
            [_dm setMyCouponListBlock:^(NSArray *array) {
                [blockSelf -> _dataArray addObjectsFromArray:array];
                [blockSelf getAllArray];
                [blockSelf -> _tableView reloadData];
                [blockSelf -> _loadingView loadingViewDispear:0];
            }];
            break;
        }
    }
    if(_dataArray.count >= 10)
    {
        [_loadingView createLoadingView:YES andAlpha:1.0];
    }

}


// 创建排序 筛选 搜索
- (void)createAnimation
{
    NSArray *array = [NSArray arrayWithObjects:@"我的服务   |",@"电子券   |",@"物业缴费   |",@"维权记录", nil];
    _backView = [[UIView alloc] init];
    _backView.frame = CGRectMake(0, is_IPHONE_6?44:64, 640, 40);
    _backView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    [self.view addSubview:_backView];
    
    for(NSInteger i = 0; i < array.count; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(5+80*i, 10, 80, 20);
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        button.selected = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:button];
    }
    
    ((UIButton *)[_backView.subviews objectAtIndex:0]).selected = NO;
    [[_backView.subviews objectAtIndex:0] setTitleColor:[UIColor colorWithRed:0.74f green:0.48f blue:0.25f alpha:1.00f] forState:UIControlStateNormal];
}

// 创建TableView
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44+40:104, 320, isRetina.size.height>480?568-64-40:480-64-40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if(_tagState == 103)
    {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_tagState)
    {
        case 100:   // 我的服务
            if(_allArray.count > 0)
            {
                NSLog(@"%d",_allArray.count);
                return _allArray.count;
            }
            return 0;
            break;
        case 101:   // 电子券
            if(_allArray.count > 0)
            {
                return _allArray.count;
            }
            return 0;
            break;
        case 102:   // 物业缴费
        {
            return 1;
            break;
        }
        case 103:   // 维权记录
            if(section == 0)
            {
                return 1;
            }
            else if(section == 1)
            {
                return 6;
            }
            break;
        default:
            break;
    }
    return 0;
}

- (void)createCellAnimation:(UITableViewCell *)cell
{
    NSArray *array = [NSArray arrayWithObjects:@"2013年10月：你缴纳了600块钱物业费",@"2013年10月：你缴纳了600块钱物业费",@"2013年10月：你缴纳了600块钱物业费",@"2013年10月：你缴纳了600块钱物业费",@"2013年10月：你缴纳了600块钱物业费", nil];
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, array.count *40+30)];
    _backView.hidden = YES;
    [cell.contentView addSubview:_backView];
    
    for(NSInteger i = 0; i < array.count; i ++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = [array objectAtIndex:i];
        [_backView addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
        imageView.frame = CGRectMake(label.frame.origin.x-10, label.frame.size.height+10, 280, 1);
        [_backView addSubview:imageView];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, _backView.frame.size.height-30, 320, 20)];
    label.text = @"你当前的物业费缴至2015年5月1号";
    label.textColor = [UIColor colorWithRed:0.12f green:0.63f blue:0.49f alpha:1.00f];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    [_backView addSubview:label];
    
    for(UIView *view in _backView.subviews)
    {
        view.hidden = YES;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName_Server = @"Cell_0";
    static NSString *cellName_DZQ = @"Cell_1";
    static NSString *cellName_Real = @"Cell_2";
    static NSString *cellName_Record = @"Cell_3";
    MyServer *cell = [tableView dequeueReusableCellWithIdentifier:cellName_Server];
    if(_tagState == 100)
    {
        
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyServer" owner:self options:nil] lastObject];
        }
        if(_allArray.count > 0)
        {
            Order *order = [_allArray objectAtIndex:indexPath.row];
            cell.serverTitleLable.text = order.orderName;
            cell.serverCodeLable.text = [NSString stringWithFormat:@"%@",order.orderCode];
            cell.serverPriceLable.text = [NSString stringWithFormat:@"订单金额：%@",order.orderMoney];
            NSString *str;
            switch ([order.orderState intValue])
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
            cell.serverStateLabel.text =[NSString stringWithFormat:@"状态：%@",str];
            [cell.serverImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,order.buyLogo]]];
            cell.serverNameLable.text = order.buyName;
        }
        return cell;
    }
    else if(_tagState == 101)
    {
        DZQCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName_DZQ];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DZQCell" owner:self options:nil] lastObject];
        }
        if(_allArray.count > 0)
        {
            Coupon *cou = [_allArray objectAtIndex:indexPath.row];
            cell.couEnd.text = [NSString stringWithFormat:@"截止到%@",cou.couEnd];
            cell.couNameLable.text = cou.couName;
            cell.couCodeLable.text = cou.couCode;
            cell.couLeft_ValueLable.text = [NSString stringWithFormat:@"%@",cou.couLeft_Value];
            cell.couValueLable.text = cou.couValue;
            NSString *str;
            switch ([cou.couState intValue])
            {
                case 1:str = @"可使用";break;
                case 2:str = @"已使用";break;
                case 3:str = @"已过期";break;
            }
            [cell.couStateBtn setTitle:str forState:UIControlStateNormal];
        }
        return cell;
    }
    else if(_tagState == 102)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName_Real];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName_Real];
        }
        cell.textLabel.text = @"8单元8栋888";
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textColor = [UIColor darkGrayColor];
       
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右边.png"]];
        imageView.frame = CGRectMake(320-50, (66-25)/2, 25, 25);
        [cell.contentView addSubview:imageView];
        return cell;
    }
    else if(_tagState == 103)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName_Record];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName_Record];
        }
        if(indexPath.section == 0)
        {
            cell.textLabel.text = @"维权记录列表";
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
            cell.textLabel.textColor = [UIColor colorWithRed:0.72f green:0.45f blue:0.20f alpha:1.00f];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        else if(indexPath.section == 1)
        {
            cell.textLabel.text = @"2013年10月：您申请了维权，进行中";
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
            cell.textLabel.textColor = [UIColor colorWithRed:0.62f green:0.64f blue:0.66f alpha:1.00f];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;

        }
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_tagState)
    {
        case 100:
            return 120.0f;
            break;
        case 101:
            return 150.0f;
            break;
        case 102:
        {
            return 66;
            break;
        }
        case 103:
            if(indexPath.section == 0)
            {
                return 50;
            }
            else if(indexPath.section == 1)
            {
                return 40;
            }
            break;
        default:
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_tagState == 100)
    {
        Order *order = [_allArray objectAtIndex:indexPath.row];
        switch ([order.orderState intValue])
        {
            case 1: // 已呼叫
            {
                ServerOrderViewController *server = [[ServerOrderViewController alloc] init];
                server.orderId = order.orderUid;
                [self.navigationController pushViewController:server animated:YES];
                break;
            } 
            case 3: // 待下单
            {
                FillOrderInfoViewController *fill = [[FillOrderInfoViewController alloc] init];
                fill.oid = order.orderUid;
                fill.comeId = 1;
                [self.navigationController pushViewController:fill animated:YES];
                break;
            }
            case 4: // 待支付
            {
                DaiPayViewController *daiPay = [[DaiPayViewController alloc] init];
                daiPay.orderId = order.orderUid;    // 订单id
                daiPay.orderType = 4;
                [self.navigationController pushViewController:daiPay animated:YES];
                break;
            }
            case 2: // 待确认
            {
                DaiOkViewController *daiOk = [[DaiOkViewController alloc] init];
                daiOk.serId = order.orderUid;// 待确认
                [self.navigationController pushViewController:daiOk animated:YES];
                break;
            }
            default:
                break;
        }
    }
    else if(_tagState == 102)
    {
        PayRecordViewController *payRecord = [[PayRecordViewController alloc] init];
        payRecord.name = @"8单元8栋888";
        [self.navigationController pushViewController:payRecord animated:YES];
    }
}

// 选中变颜色
- (void)bbiItem:(UIButton *)button
{
    _tagState = button.tag ;
    NSArray *buttons = button.superview.subviews;
    for(UIButton *btn in buttons)
    {
        btn.selected = YES;
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    [_dataArray removeAllObjects];
    [_allArray removeAllObjects];
    [self downLoadDataWithPage:1 andSelectTag:button.tag-99];
     button.selected = NO;
    [button setTitleColor:[UIColor colorWithRed:0.74f green:0.48f blue:0.25f alpha:1.00f] forState:UIControlStateNormal];
    [_tableView reloadData];

}
- (void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
