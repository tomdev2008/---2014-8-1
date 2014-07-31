//
//  AddressInfoViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-5.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "AddressInfoViewController.h"
#import "AddressViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "addressInfoCell.h"
#import "DownLoadManager.h"
#import "FillOrderInfoViewController.h"

@interface AddressInfoViewController ()

@end

@implementation AddressInfoViewController
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

- (void)viewDidAppear:(BOOL)animated
{
    _dataArray = [[NSMutableArray alloc] init];
    __block AddressInfoViewController *blockSelf = self;
    _dm = [DownLoadManager shareDownLoadManager];
    [_dm getAddressListWith];
    [_dm setAddressBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _dataArray = [[NSMutableArray alloc] init];
    __block AddressInfoViewController *blockSelf = self;
    _dm = [DownLoadManager shareDownLoadManager];
    [_dm getAddressListWith];
    [_dm setAddressBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
    }];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"收货地址" andLeftButtonImage:@"back.png" andRightButtonImage:@"plus.png" andSEL:@selector(btnClick:) andClass:self];
    [self.view addSubview:mnb];
    
    [self createTabelView];
}

- (void)createTabelView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?54:74, 320, isRetina.size.height>480?568-64:480-64)];
    _tableView.delegate =self;
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
        return _dataArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_dataArray.count > 0)
    {
        return 100.0f;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    addressInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"addressInfo" owner:self options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(_dataArray.count > 0)
    {
        Address *address = [_dataArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = address.addName;
        cell.addressLabel.text  = address.addAddress;
        cell.phoneLabel.text = address.addContact;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Address *address = [_dataArray objectAtIndex:indexPath.row];
    _addressBlock (address.addName,address.addAddress,address.addContact);
    [self.navigationController popViewControllerAnimated:YES];
}

-   (void)bbiItem:(UIButton *)button
{
    NSLog(@"%d",button.tag);
}

- (void)btnClick:(UIButton *)button
{
    if(button.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        AddressViewController *address = [[AddressViewController alloc] init];
        [self.navigationController pushViewController:address animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
