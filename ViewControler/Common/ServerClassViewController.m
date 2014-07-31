//
//  ServerClassViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-10.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "ServerClassViewController.h"
#import "DownLoadManager.h"
#import "AppDelegate.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "MyNavigationBar.h"
#import "OrderUpdateCell.h"

@interface ServerClassViewController ()

@end

@implementation ServerClassViewController
{
    AppDelegate *appDelegate;
    DownLoadManager *downLoadManager;
    NSMutableArray *dataArray;
    UITableView *_tableView;
    UILabel *numLabel;
    
    NSMutableDictionary *mdict; // 存 id 和  数量
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
    // 初始化
    __block ServerClassViewController *blockSelf = self;
    mdict = [NSMutableDictionary dictionary];
    dataArray = [[NSMutableArray alloc] init];
    downLoadManager = [DownLoadManager shareDownLoadManager];
    //[downLoadManager getServerPriceListWithSid:self.sid andType:@"2"];
    [downLoadManager getServerPriceListWithSid:@"1" andType:@"1"];
    [downLoadManager setServerPriceListBlock:^(NSArray *array) {
        [blockSelf -> dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
    }];
    
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"服务价格列表" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem) andClass:self];
    [self.view addSubview:mnb];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self createScrollView];
}

- (void)createScrollView
{
    UIView *backView = [[UIScrollView alloc] init];
    backView.frame = CGRectMake(10, is_IPHONE_6?50:70, 300, 400);
    backView.layer.borderWidth = 1;
    backView.tag = 10;
    backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:backView];
    
    UILabel *orderLabel = [[UILabel alloc] init];
    orderLabel.frame = CGRectMake(0, 10, 300, 20);
    orderLabel.font = [UIFont systemFontOfSize:15];
    orderLabel.textAlignment = NSTextAlignmentCenter;
    orderLabel.textColor = [UIColor darkGrayColor];
    orderLabel.text = @"订单列表";
    [backView addSubview:orderLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 300, 380) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [backView addSubview:_tableView];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, isRetina.size.height>480?568-64:480-64, 320, 40);
    footerView.backgroundColor = [UIColor blackColor];
    footerView.alpha = 0.3;
    footerView.tag = 11;
    [self.view addSubview:footerView];
    
    UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yesBtn.frame = CGRectMake(250, isRetina.size.height>480?568-64:480-64, 30, 30);
    [yesBtn setBackgroundImage:[UIImage imageNamed:@"我的购物车_06.png"] forState:UIControlStateNormal];
    yesBtn.tag = 12;
    [yesBtn addTarget:self action:@selector(yesClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yesBtn];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(dataArray.count > 0)
    {
        return dataArray.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    for(int i = 0; i < dataArray.count; i ++)
    {
        if(section == i)
        {
            Server *server = [dataArray objectAtIndex:i];
            for(int i = 0; i < server.serEvents.count; i ++)
            {
                return server.serEvents.count;
            }
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLable = [[UILabel alloc] init];
    headerLable.textAlignment = NSTextAlignmentCenter;
    headerLable.font = [UIFont systemFontOfSize:14];
    headerLable.textColor = [UIColor darkGrayColor];
    headerLable.backgroundColor = [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.00f];
    for(int i = 0; i < dataArray.count; i ++)
    {
        Server *server = [dataArray objectAtIndex:i];
        if(section == i)
        {
            headerLable.text = server.serPrice_type;
            return headerLable;
        }
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    OrderUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[OrderUpdateCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    if(dataArray.count > 0)
    {
        Server *server = [dataArray objectAtIndex:indexPath.section];
        Server *ser = [server.serEvents objectAtIndex:indexPath.row];
        [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"非选择.png"] forState:UIControlStateNormal];
        [cell.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.contentLabel.text = [NSString stringWithFormat:@"%@ (%@)",ser.serName,ser.serPrice];
        [cell.reduceBtn setBackgroundImage:[UIImage imageNamed:@"reduce.png"] forState:UIControlStateNormal];
        [cell.reduceBtn addTarget:self action:@selector(reduceClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.numLable.text = @"0";
        [cell.plusBtn setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        [cell.plusBtn addTarget:self action:@selector(plusClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.indexLabel.text = [NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 点击事件
- (void)bbiItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)yesClick
{
    NSString *id_name = nil;
    NSMutableString *id_names = [NSMutableString string];
    for(NSString *string in mdict.allKeys)
    {
        NSLog(@"%@_%@,",string,[mdict objectForKey:string]);
        id_name = [NSString stringWithFormat:@"%@_%@,",string,[mdict objectForKey:string]];
        [id_names appendString:id_name];
    }
    //NSLog(@"%@",[id_names substringToIndex:id_names.length-1]);
    [downLoadManager saveOrderEventWithOid:self.sid andInfo:[id_names substringToIndex:id_names.length-1]];
    [downLoadManager setSendMessageSuccess:^{
        NSLog(@"下订单成功");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
}
- (void)selectClick:(UIButton *)button
{
    if(!button.selected)
    {
        for(UIButton *btn in button.superview.subviews)
        {
            if([btn isKindOfClass:[UIButton class]])
            {
                btn.selected = NO;
            }
        }
        button.selected = YES;
        [button setTitleColor:[UIColor colorWithRed:0.05f green:0.64f blue:0.49f alpha:1.00f] forState: UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"选择.png"] forState:UIControlStateSelected];
    }
    else
    {
        button.selected = NO;
    }
}
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:temp.length inSection:temp.location];
    Server *server = [dataArray objectAtIndex:indexPath.section];
    Server *ser = [server.serEvents objectAtIndex:indexPath.row];
    NSLog(@"减号:%@_%d",ser.serId,count);
    [mdict setObject:[NSString stringWithFormat:@"%d",count] forKey:ser.serId];
}
- (void)plusClick:(UIButton *)button
{
    UILabel *indexLabel = (UILabel *)[[button superview] viewWithTag:99];
    NSRange temp = NSRangeFromString(indexLabel.text);
    OrderUpdateCell *cell = (OrderUpdateCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:temp.length inSection:temp.location]];
    int count = [cell.numLable.text intValue];
    count ++;
    cell.numLable.text = [NSString stringWithFormat:@"%d",count];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:temp.length inSection:temp.location];
    Server *server = [dataArray objectAtIndex:indexPath.section];
    Server *ser = [server.serEvents objectAtIndex:indexPath.row];
    NSLog(@"加号:%@_%d",ser.serId,count);
    [mdict setObject:[NSString stringWithFormat:@"%d",count] forKey:ser.serId];
}
- (void)viewWillAppear:(BOOL)animated
{
    appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.mtb.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    appDelegate.mtb.hidden = NO;
}

@end
