//
//  PersonServerViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-28.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "PersonServerViewController.h"
#import "MyNavigationBar.h"
#import "MoreServerViewController.h"
#import "Real_PayViewController.h"
#import "DisCountViewController.h"
#import "SubScribeViewController.h"
#import "ServerOrdersViewController.h"
#import "FillOrderInfoViewController.h"
#import "ZL_CONST.h"
#import "DownLoadManager.h"
#import "ZL_INTERFACE.h"
#import "Login_480_ViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
@interface PersonServerViewController ()

@end

@implementation PersonServerViewController
{
    UITableView *_tableView;
    DownLoadManager *_dm;
    NSMutableArray *_dataArray;
    int _indexPath;
    int _isReservition; // 是下单还是预约
    NSString *_orderId;
    LoadingView *_loadingView;
    AppDelegate *_app;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     self.hidesBottomBarWhenPushed = YES;   // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"小区服务" andLeftButtonImage:nil andRightButtonImage:@"默认发起对话的icon.png" andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
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
	// Do any additional setup after loading the view.
    
    _indexPath = 0;
    _app = [UIApplication sharedApplication].delegate;
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"小区服务" andLeftButtonImage:nil andRightButtonImage:@"默认发起对话的icon.png" andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
    _dataArray = [[NSMutableArray alloc] init];
    _dm = [DownLoadManager shareDownLoadManager];
    //_app.isFirst_nei = 1;    //   zhaoheng
    [_dm getServerListWithCid:_dm.communityId andRecid:1 andPage:1];
    __block PersonServerViewController *blockSelf = self;
    [_dm setServerListBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
        [_loadingView loadingViewDispear:0.0];
    }];
    
    // 创建TableView
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

// 创建TableView
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44:64, 320, isRetina.size.height>480?600:600) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}

- (void)createSectionOne:(UITableViewCell *)cell
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for(NSInteger i = 0; i < 2; i ++)
    {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10+155*i,10, 145, 90);
        [button setBackgroundImage:[UIImage imageNamed:i == 0?@"物业缴费.png":@"优惠劵.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [cell.contentView addSubview:button];
        
        UIButton *hotButton = [UIButton buttonWithType:UIButtonTypeCustom];
        hotButton.frame = CGRectMake(215*i, 120, 100, 20);
        hotButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [hotButton setTitle:i == 0?@"热门服务":@"更多服务>" forState:UIControlStateNormal];
        [hotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        hotButton.tag = 103+i;
        [hotButton addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:hotButton];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        if(_dataArray.count > 0)
        {
            return _dataArray.count/2;
        }
        return 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(indexPath.section == 0)
    {
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        }
        [self createSectionOne:cell];
    }
    else if(indexPath.section == 1)
    {
        static NSString *cell_next_name = @"Cell_next";
        UITableViewCell *cell_next = [tableView dequeueReusableCellWithIdentifier:cell_next_name];
        if(!cell_next)
        {
            cell_next = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell_next_name];
        }
        cell_next.selectionStyle = UITableViewCellSelectionStyleNone;
        if(_dataArray.count > 0)
        {
            for(NSInteger j = 0; j < 1 ; j ++)
            {
                for(NSInteger i = 0; i < 2; i ++)
                {
                    Server *server = [_dataArray objectAtIndex:indexPath.row * 2 + i];
                    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    imageButton.frame = CGRectMake(5+155*i, 5+110*j, 145, 100);
                    imageButton.tag = 130+indexPath.row * 2 + i;
                    [imageButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageButton.frame];
                    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,server.serTitlePic]]];
                    [imageButton addSubview:imageView];
                    [cell_next.contentView addSubview:imageButton];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10+155*i, 100, 145, 30)];
                    label.text = server.serName;
                    label.font = [UIFont systemFontOfSize:15];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor darkGrayColor];
                    label.backgroundColor = [UIColor colorWithRed:0.83f green:0.83f blue:0.83f alpha:1.00f];
                    [cell_next.contentView addSubview:label];
                }
            }
        }
        return cell_next;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 150.0f;
    }
    else if(indexPath.section == 1)
    {
        return 130.0f;
    }
    return 0;
}


- (void)bbiItem:(UIButton *)button
{
    switch (button.tag) {
        case 100:
        {
            NSLog(@"物业缴费");
            if(_dm.myUserId != nil)
            {
                Real_PayViewController *real = [[Real_PayViewController alloc] init];
                [self.navigationController pushViewController:real animated:YES];
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
            break;
        }
        case 101:
        {
            NSLog(@"优惠券");
            if(_dm.myUserId != nil)
            {
                DisCountViewController *disCount = [[DisCountViewController alloc] init];
                [self.navigationController pushViewController:disCount animated:YES];
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

            
            break;
        }
        case  103:
            NSLog(@"热门服务");
            break;
        case 104:
        {
            NSLog(@"更多服务");
            if(_dm.myUserId != nil)
            {
                MoreServerViewController *more = [[MoreServerViewController alloc] init];
                [self.navigationController pushViewController:more animated:YES];
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

            break;
        }
        default:
            break;
    }
}

- (void)btnClick:(UIButton *)button
{

    
    if(_dm.myUserId != nil)
    {
        SubScribeViewController *sub = [[SubScribeViewController alloc] init];
        Server *server = [_dataArray objectAtIndex:button.tag - 130];
        // 把图片名称赋值给单例
        sub.orderType = server.serOrder_type;
        _dm.serverImage = [NSString stringWithFormat:@"%@%@",ZL_URLUpload,server.serTitlePic];
        NSLog(@"%@",server.serId);
        sub.sid = [server.serId intValue];
        [self.navigationController pushViewController:sub animated:YES];

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
