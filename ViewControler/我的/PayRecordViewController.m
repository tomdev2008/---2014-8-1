//
//  PayRecordViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-9.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "PayRecordViewController.h"
#import "ZL_CONST.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"

@interface PayRecordViewController ()

@end

@implementation PayRecordViewController
{
    UITableView *_tableView;
    AppDelegate *_app;
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
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"物业缴费详情" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    [self createTableView];
}

// 创建TableView
- (void)createTableView
{
    if(isRetina.size.height > 480)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44:64, 320, 568-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    else
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44:64, 320, 480-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    cell.textLabel.text = @"203年10月：您缴纳了600块钱的物业费";
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _name;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
