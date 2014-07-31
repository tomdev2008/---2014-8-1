//
//  OrderManagerViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-24.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "OrderManagerViewController.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "DownLoadManager.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "OrderCell.h"
#import "LoadingView.h"
#import "OrderInfoViewController.h"
#import "DaiOk_SViewController.h"
#import "Login_480_ViewController.h"
#import "LoginViewController.h"
#import "FillOrderInfoViewController.h"
#import "DaiPayViewController.h"

@interface OrderManagerViewController ()

@end

@implementation OrderManagerViewController
{
    DownLoadManager *_dm;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    BOOL _reloading;
    NSMutableArray *_allArray;
    int _pageCount;
    LoadingView *_loadingView;
    
    int _page;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;// Custom initialization
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
- (void)downLoadDataWithCid:(int)cid andPage:(int)page
{
    __block OrderManagerViewController *blockSelf = self;
    [_dm getOrderServerListWithCid:cid andMid:[_dm.myUserId intValue] andPage:page];
    [_dm setOrderServerListBlock:^(NSArray *array) {
        blockSelf -> _page = 1;
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf getAllArray];
        [blockSelf -> _tableView reloadData];
        blockSelf -> _loadingView.alpha  = 0;
    }];
    // 保证不是最后一页
    if(_dataArray.count >= 10)
    {
        [_loadingView createLoadingView:YES andAlpha:1.0];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"呼叫管理" andLeftButtonImage:nil andRightButtonImage:@"默认发起对话的icon.png" andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    
    _dm = [DownLoadManager shareDownLoadManager];
    _dataArray = [[NSMutableArray alloc] init];
    _allArray = [[NSMutableArray alloc] init];
    _pageCount = 1;
    
    // 暂时是1
    [self downLoadDataWithCid:_dm.communityId andPage:_pageCount];
    [self createTableView];
}

- (void)createTableView
{
    _egoRefresh = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -_tableView.frame.size.height, 320, _tableView.frame.size.height)];
    _egoRefresh.delegate = self;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44:64, 320, isRetina.size.height>480?548-49-44:480-49-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView addSubview:_egoRefresh];
    [self.view addSubview:_tableView];
    
    // 点击加载更多
    UIView *loadView = [[UIView alloc] init];
    loadView.frame = CGRectMake(0, 0, 320, 30);
    loadView.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((loadView.frame.size.width-94)/2, 5, 94, 20);
    [button setTitle:@"点击加载更多" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(addMoreClick) forControlEvents:UIControlEventTouchUpInside];
    [loadView addSubview:button];
    _tableView.tableFooterView = loadView;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_allArray.count > 0)
    {
        return _allArray.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 订单详情
    Order *order = [_allArray objectAtIndex:indexPath.row];
    if(_dm.myUserId != nil)
    {
        switch ([order.orderState intValue])
        {
            case 1: // 已呼叫
            {
                OrderInfoViewController *orderInfo = [[OrderInfoViewController alloc] init];
                orderInfo.osid = [order.orderOsid intValue];
                [self.navigationController pushViewController:orderInfo animated:YES];
                break;
            }
            case 2: // 待确认
            {
                DaiOk_SViewController *daiOk = [[DaiOk_SViewController alloc] init];
                daiOk.oid = order.orderOsid;
                [self.navigationController pushViewController:daiOk animated:YES];
                break;
            }
            case 3: // 待下单
            {
                FillOrderInfoViewController *fill = [[FillOrderInfoViewController alloc] init];
                fill.serId = order.orderOsid;
                fill.comeId = 2;
                [self.navigationController pushViewController:fill animated:YES];
                break;
            }
            case 4: // 代付款
            {
                DaiPayViewController *daiPay = [[DaiPayViewController alloc] init];
                daiPay.orderId = order.orderOsid;
                [self.navigationController pushViewController:daiPay animated:YES];
                break;
            }
            case 5: // 待提供服务
            {
                break;
            }
            case 9: // 已完成
            {
                break;
            }
        }
    }
    else
    {
        if(isRetina.size.height > 480)
        {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        }
        else
        {
            Login_480_ViewController *login = [[Login_480_ViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        }

    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:self options:nil] lastObject];
    }
    if(_allArray.count > 0)
    {
        Order *order = [_allArray objectAtIndex:indexPath.row];
        [cell.ufaceImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,order.orderUface]]];
        cell.titleLable.text = order.orderName;
        cell.orderCodeLabel.text = order.orderCode;
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
        cell.stateLabel.text = str;
    }
    else
    {
        cell.textLabel.text = @"没有数据";
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)btnClick
{
    
}
//---------------------------------下拉刷新START-----------------------------------
// 触发刷新事件
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    if(!_reloading)
    {
        // 做刷新工作  必须是异步线程
        [_dataArray removeAllObjects];
        [_allArray removeAllObjects];
        _pageCount = 1;
        [self performSelectorInBackground:@selector(download) withObject:nil];
        [self downLoadDataWithCid:_dm.communityId andPage:1];
    }
}
- (void)download
{
    [NSThread sleepForTimeInterval:2];
    [self reloadTableViewDataSoure];
    if(_reloading)
    {
        [self doneLoadingTableViewData];
    }
    else
    {
        NSLog(@"NO");
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}
// 得到刷新日期
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}
// 判断拖拉是否触发事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_egoRefresh egoRefreshScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_egoRefresh egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)reloadTableViewDataSoure
{
    _reloading = YES;
}
- (void)doneLoadingTableViewData
{
    NSLog(@"Finish");
    _reloading = NO;
    [self performSelectorOnMainThread:@selector(finish) withObject:nil waitUntilDone:NO];
}
- (void)finish
{
    [_tableView reloadData];
    // 刷新完成收起控件
    [_egoRefresh egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}
//----------------------------------下拉刷新END------------------------
//----------------------------------点击加载更多
- (void)addMoreClick
{
    [_dataArray removeAllObjects];
    _pageCount ++;
    [self downLoadDataWithCid:_dm.communityId andPage:_pageCount];
}

@end
