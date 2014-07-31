//
//  AutoPayViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-30.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "AutoPayViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "PayInfoViewController.h"
#import "DownLoadManager.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"

@interface AutoPayViewController ()

@end

@implementation AutoPayViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    int _btnTag;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // 去掉下边的TabBar
    _app = [UIApplication sharedApplication].delegate;
    _app.mtb.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    _dm = [DownLoadManager shareDownLoadManager];
    // Do any additional setup after loading the view from its nib.
    
    _unitRoom = [[NSMutableString alloc] init];
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"自助缴费" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
    [self createTableView];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(80, is_IPHONE_6?70+35:90+35, 220, 200) style:UITableViewStylePlain];
    _tableView.hidden = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.borderWidth = 1;
    _tableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
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
        return _dataArray.count;
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
    if(_dataArray.count > 0 && _btnTag == 0)
    {
        Community *comm = [_dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = comm.commName;
        cell.detailTextLabel.text = @"";
    }
    else if(_dataArray.count > 0 && _btnTag == 1)
    {
        Community *comm = [_dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = comm.commName;
        cell.detailTextLabel.text = comm.commLong_Name;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tableView.hidden = YES;
    Community *comm = [_dataArray objectAtIndex:indexPath.row];
    
    if(_btnTag == 0)
    {
        [_danyuanBtn setTitle:comm.commName forState:UIControlStateNormal];
        [_unitRoom appendString:comm.commName];
    }
    else if(_btnTag == 1)
    {
        [_roomBtn setTitle:comm.commName forState:UIControlStateNormal];
        [_unitRoom appendString:comm.commName];
    }
    self.rid = [comm.commId intValue];
}

- (void)bbiItem:(UIButton *)button
{
    if(button.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 点击下一步
- (IBAction)nextButtonClick:(id)sender
{
    if([_danyuanBtn.titleLabel.text isEqualToString:@"请选择"] || [_roomBtn.titleLabel.text isEqualToString:@"请选择"])
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
        return;
    }
    else
    {
        PayInfoViewController *payInfo = [[PayInfoViewController alloc] init];
        payInfo.unitRommStr = _unitRoom;
        payInfo.rid = self.rid;
        [self.navigationController pushViewController:payInfo animated:YES];
    }
}
- (IBAction)danyuanClick:(id)sender
{
    [_dataArray removeAllObjects];
    _btnTag = 0;
    _tableView.hidden = NO;
    _tableView.frame = CGRectMake(70, 105, 230, 200);
    __block AutoPayViewController *blockSelf = self;
    [_dm getCommunityUnityListWithCid:_dm.communityId andTid:1];
    [_dm setCommuntityuntityListBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
    }];
}

- (IBAction)roomClick:(id)sender
{
    [_dataArray removeAllObjects];
    _btnTag = 1;
    _tableView.hidden = NO;
    _tableView.frame = CGRectMake(65, 105+35+20, 220, 200);
    __block AutoPayViewController *blockSelf = self;
    [_dm getCommunityRommListWithUid:1];
    [_dm setCommunityRoomListBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
    }];
}
@end
