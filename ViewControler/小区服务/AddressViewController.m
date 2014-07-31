//
//  AddressViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-5.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "AddressViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "DownLoadManager.h"

@interface AddressViewController ()

@end

@implementation AddressViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
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
    // Do any additional setup after loading the view from its nib.
    _dm = [DownLoadManager shareDownLoadManager];
    _dataArray = [[NSMutableArray alloc] init];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"新增地址" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    
    NSArray *array = [NSArray arrayWithObjects:@"江苏省",@"南京市",@"江宁区",@"绿水家园", nil];
    for(NSInteger i = 0; i < array.count; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20+70*i, 74, 60, 20);
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.tag = 120+i;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    self.nameText.delegate = self;
    self.phoneText.delegate = self;
    
    [self createTableView];
}

- (void)createTableView
{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(90, is_IPHONE_6?70+45:90+45, 220, 183) style:UITableViewStylePlain];
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
        cell.detailTextLabel.text = @"";
        cell.textLabel.text = comm.commName;
    }
    else if(_dataArray.count > 0 && _btnTag == 1)
    {
        Community *comm = [_dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = comm.commName;
    }
    else if(_dataArray.count > 0 && _btnTag == 2)
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
        [_mendongBtn setTitle:comm.commName forState:UIControlStateNormal];
        self.rid = comm.commId;
    }
    else if(_btnTag == 1)
    {
        [_danyuanBtn setTitle:comm.commName forState:UIControlStateNormal];
    }
    else if(_btnTag == 2)
    {
        [_roomBtn setTitle:comm.commName forState:UIControlStateNormal];
    }


}

- (void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bbiItem:(UIButton *)button
{
    NSLog(@"%d",button.tag);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 门牌
- (IBAction)roomBtn:(id)sender
{
    [_dataArray removeAllObjects];
    _btnTag = 2;
    _tableView.hidden = NO;
    _tableView.frame = CGRectMake(90, 90+35+35+20+35, 183, 150);
    __block AddressViewController *blockSelf = self;
    [_dm getCommunityRommListWithUid:1];
    [_dm setCommunityRoomListBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
    }];
}

// 单元
- (IBAction)danyuanBtn:(id)sender
{
    [_dataArray removeAllObjects];
    _btnTag = 1;
    _tableView.hidden = NO;
    _tableView.frame = CGRectMake(90, 90+35+35+10, 183, 150);
    __block AddressViewController *blockSelf = self;
    //NSString *str = ((UIButton *)([_btnArray objectAtIndex:1])).titleLabel.text;
    [_dm getCommunityUnityListWithCid:_dm.communityId andTid:1];
    [_dm setCommuntityuntityListBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
    }];

}

// 门栋
- (IBAction)mendongBtn:(id)sender
{
    [_dataArray removeAllObjects];
    _btnTag = 0;
    _tableView.hidden = NO;
    _tableView.frame = CGRectMake(90, 90+45, 183, 150);
    __block AddressViewController *blockSelf = self;
    [_dm getCommunityTentListWithCid:_dm.communityId];
    [_dm setCommunityTentListBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
    }];

}
- (IBAction)addYesClick:(id)sender
{
    self.name = _nameText.text;
    self.phone = _phoneText.text;
    __block AddressViewController *blockSelf = self;
    [_dm addAddressWithAction:@"2" andCid:[NSString stringWithFormat:@"%d",_dm.communityId] andRid:self.rid andName:self.name andPhone:self.phone];
    [_dm setAddAddressBlock:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"增加地址成功" delegate:blockSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancleClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
