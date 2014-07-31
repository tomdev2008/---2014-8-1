//
//  MoreServerViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-30.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "MoreServerViewController.h"
#import "AppDelegate.h"
#import "MyNavigationBar.h"
#import "ServerOrderViewController.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "SubScribeViewController.h"
#import "DownLoadManager.h"

@interface MoreServerViewController ()

@end

@implementation MoreServerViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    LoadingView *_loadingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.hidesBottomBarWhenPushed = YES;  // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    _app = [UIApplication sharedApplication].delegate;
    _app.mtb.hidden = YES;
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
    
    _dataArray = [[NSMutableArray alloc] init];
    _dm = [DownLoadManager shareDownLoadManager];
    [_dm getServerListWithCid:_dm.communityId andRecid:0 andPage:1];
    __block MoreServerViewController *blockSelf = self;
    [_dm setServerListBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
        [_loadingView loadingViewDispear:0];
    }];
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"更多服务" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
    
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44:64, 320, isRetina.size.height>480?548-44:460-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_dataArray.count > 0)
    {
        return _dataArray.count/2;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                [cell.contentView addSubview:imageButton];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10+155*i, 80+30*j, 145, 30)];
                label.text = server.serName;
                label.font = [UIFont systemFontOfSize:15];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor darkGrayColor];
                label.backgroundColor = [UIColor colorWithRed:0.83f green:0.83f blue:0.83f alpha:1.00f];
                [cell.contentView addSubview:label];
            }
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}
- (void)bbiItem:(UIButton *)button
{
    NSLog(@"点击了返回");
    if(button.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(button.tag == 110)
    {
        ServerOrderViewController *serverOrder = [[ServerOrderViewController alloc] init];
        [self.navigationController pushViewController:serverOrder animated:YES];
    }
    else if(button.tag == 111)
    {
    
    }
}
- (void)btnClick:(UIButton *)btn
{
    SubScribeViewController *sub = [[SubScribeViewController alloc] init];
    Server *server = [_dataArray objectAtIndex:btn.tag - 130];
    // 把图片名称赋值给单例
    _dm.serverImage = [NSString stringWithFormat:@"%@%@",ZL_URLUpload,server.serTitlePic];
    sub.sid = [server.serId intValue];
    [self.navigationController pushViewController:sub animated:YES];
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
