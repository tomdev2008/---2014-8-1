//
//  CommunityViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-23.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "CommunityViewController.h"
#import "MyNavigationBar.h"
#import "ZL_INTERFACE.h"
#import "ZL_CONST.h"
#import "DownLoadManager.h"
#import "AppDelegate.h"
#import "RegiestViewController.h"

@interface CommunityViewController ()<UIApplicationDelegate>

@end

@implementation CommunityViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
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
- (void)viewWillDisappear:(BOOL)animated
{
    _app.mtb.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 46)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"小区选择" andLeftButtonImage:nil andRightButtonImage:nil andSEL:nil andClass:nil];
    [self.view addSubview:mnb];
    
    _dm = [DownLoadManager shareDownLoadManager];
    _dataArray = [[NSMutableArray alloc] init];
    __block CommunityViewController *blockSelf = self;
    [_dm getCommunityList];
    [_dm setCommunityListBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
    }];
    
    [self createTableView];
    
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44:64, 320, isRetina.size.height > 480?568-64-49:480-64-49) style:UITableViewStylePlain];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(_dataArray.count > 0)
    {
        for(int i = 0; i < 1; i ++)
        {
            for (int j = 0; j < 2; j ++)
            {
                Community *comm = [_dataArray objectAtIndex:indexPath.row * 2 + j];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = 100+indexPath.row * 2 + j;
                button.frame = CGRectMake(155*j+10, 10, 145, 100);
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:button.bounds];
                [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,comm.commPic]]];
                [button addSubview:imageView];
                button.tag = 100 +  indexPath.row * 2 + j;
                [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
                UILabel *label = [[UILabel alloc] init];
                label.frame = CGRectMake(150*j+5, button.frame.origin.y+button.frame.size.height+15, 145, 20);
                label.textAlignment = NSTextAlignmentCenter;
                label.text = comm.commName;
                label.font = [UIFont systemFontOfSize:13];
                [cell.contentView addSubview:label];
            }
        }
    }
    return cell;
}

- (void)btnClick:(UIButton *)button
{
    Community *comm = [_dataArray objectAtIndex:button.tag - 100];
    _dm.communityId = [comm.commId intValue];
    _app.communityId = [comm.commId intValue];
    _dm.neiFlag = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
