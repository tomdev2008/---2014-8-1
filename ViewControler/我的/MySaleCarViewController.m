//
//  MySaleCarViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "MySaleCarViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "MySaleCarCell.h"
#import "ZL_CONST.h"

@interface MySaleCarViewController ()

@end

@implementation MySaleCarViewController
{
    UITableView *_tableView;
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
    _app = [UIApplication sharedApplication].delegate;
    _app.mtb.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 初始化
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"我的购物车" andLeftButtonImage:@"back" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    
    [self createTableView];
}

- (void)createTableView
{
    
    NSLog(@"%@",[_numberLabel_xib.text substringFromIndex:3]);
    if(isRetina.size.height > 480)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44+76:140, 320, 548-130) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_tableView];
    }
    else
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44+76:140, 320, 480-130) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_tableView];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    MySaleCarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [[MySaleCarCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    [cell setChangeLabelBlock:^(NSString * text) {
        cell.numberLabel_Real.text = text;
    }];
    [cell setChangeNumberLabelBlock:^(NSString *text) {
        _numberLabel_xib.text  = [NSString stringWithFormat:@"数量：%@",text];
    }];
    return cell;
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
