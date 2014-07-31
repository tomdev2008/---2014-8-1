//
//  PriceInfoViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-4.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "PriceInfoViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "DownLoadManager.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"

@interface PriceInfoViewController ()

@end

@implementation PriceInfoViewController
{
    AppDelegate *_app;
    UITableView *_tableView;
    DownLoadManager *_dm;
    NSMutableArray *_dataArray;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"价格列表" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    _dm = [DownLoadManager shareDownLoadManager];
    _dataArray = [[NSMutableArray alloc] init];
    __block PriceInfoViewController *blockSelf = self;
    [_dm getServerPriceListWithSid:_sid andType:@"2"];
    [_dm setServerPriceListBlock:^(NSArray *array) {
        [blockSelf ->_dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
    }];
    
    [self createTableView];
}


- (void)createTableView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320,548)];
    backView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:backView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(30,30, 260, 348) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [backView addSubview:_tableView];
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
            return _dataArray.count;
        }
        else
        {
            return 1;
        }
    }
    return 0;
}

- (void)createTableViewCellSection1:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath
{
    if(_dataArray.count > 0)
    {
        Server *server = [_dataArray objectAtIndex:indexPath.row];
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.frame = CGRectMake(10, 10, 200, 20);
        contentLabel.text = server.serName;
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:contentLabel];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    if(indexPath.section == 0)
    {
        UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 260, 20)];
        label.text = @"订单明细";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:label];
    }
    if(indexPath.section == 1)
    {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self createTableViewCellSection1:cell andIndexPath:indexPath];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 60.0f;
    }
    else if(indexPath.section == 1)
    {
        return 40.0f;
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
