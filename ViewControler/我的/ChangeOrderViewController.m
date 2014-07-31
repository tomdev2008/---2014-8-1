//
//  ChangeOrderViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-14.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "ChangeOrderViewController.h"
#import "AppDelegate.h"
#import "DownLoadManager.h"
#import "MyNavigationBar.h"
#import "OrderUpdateCell.h"

@interface ChangeOrderViewController ()

@end

@implementation ChangeOrderViewController
{
    DownLoadManager *_dm;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    AppDelegate *_app;
    NSMutableDictionary *mdict; // 记录都点击了哪些
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)createNavigation
{
    _dm = [DownLoadManager shareDownLoadManager];
    _dataArray = [[NSMutableArray alloc] init];
    mdict = [[NSMutableDictionary alloc] init];
    __block ChangeOrderViewController *blockSelf = self;
    [_dm getServerPriceListWithSid:@"1" andType:@"2"];
    //[_dm getServerPriceListWithSid:self.sid andType:@"2"];
    [_dm setServerPriceListBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
    }];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"服务订单" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self createTableView];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 74, 300, 380) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.borderWidth = 1;
    _tableView.layer.borderColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f].CGColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    OrderUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[OrderUpdateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    if(_dataArray.count > 0)
    {
        Server *server = [_dataArray objectAtIndex:indexPath.row];
        cell.contentLabel.text = [NSString stringWithFormat:@"%@ (%@)",server.serName,server.serPrice];
        [cell.reduceBtn setBackgroundImage:[UIImage imageNamed:@"creduce.png"] forState:UIControlStateNormal];
        [cell.reduceBtn addTarget:self action:@selector(reduceClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.numLable.text = @"0";
        [cell.plusBtn setBackgroundImage:[UIImage imageNamed:@"cplus.png"] forState:UIControlStateNormal];
        [cell.plusBtn addTarget:self action:@selector(plusClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.indexLabel.text = [NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row];
    }

    return cell;
}

// 点击加号
- (void)plusClick:(UIButton *)button
{
    UILabel *indexLabel = (UILabel *)[[button superview] viewWithTag:99];
    NSRange temp = NSRangeFromString(indexLabel.text);
    OrderUpdateCell *cell = (OrderUpdateCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:temp.length inSection:temp.location]];
    int count = [cell.numLable.text intValue];
    NSLog(@"%d %d",temp.location,temp.length);
    count ++;
    cell.numLable.text = [NSString stringWithFormat:@"%d",count];
    [mdict setObject:[NSString stringWithFormat:@"%d",count] forKey:[NSString stringWithFormat:@"%@-%@",[[_dataArray objectAtIndex:temp.length] serName],[[_dataArray objectAtIndex:temp.length] serId]]];
}
// 点击减号
- (void)reduceClick:(UIButton *)button
{
    UILabel *indexLabel = (UILabel *)[[button superview] viewWithTag:99];
    NSRange temp = NSRangeFromString(indexLabel.text);
    OrderUpdateCell *cell = (OrderUpdateCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:temp.length inSection:temp.location]];
    int count = [cell.numLable.text intValue];
    count --;
    if(count >= 0)
    {
        cell.numLable.text = [NSString stringWithFormat:@"%d",count];
    }
    else
    {
        cell.numLable.text = @"0";
    }
    if(count >= 0)
    {
        [mdict setObject:[NSString stringWithFormat:@"%d",count] forKey:[NSString stringWithFormat:@"%@-%@",[[_dataArray objectAtIndex:temp.length] serName],[[_dataArray objectAtIndex:temp.length] serId]]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)btnClick
{
    if([self.delegate respondsToSelector:@selector(changeOrderServerWithDict:)])
    {
        if(mdict.count > 0)
        {

            [self.delegate changeOrderServerWithDict:mdict];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请正确填写信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
