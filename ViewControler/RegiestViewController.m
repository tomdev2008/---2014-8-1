//
//  RegiestViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-28.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "RegiestViewController.h"
#import "ShareManager.h"
#import "PhoneViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "DownLoadManager.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"

@interface RegiestViewController ()

@end

@implementation RegiestViewController
{
    NSMutableArray *_btnArray;
    BOOL _isNULL;
    AppDelegate *_app;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    DownLoadManager *_dm;
    int _btnTag;
    NSMutableString *_address;
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
    
    // 初始化
    _dm = [DownLoadManager shareDownLoadManager];
    _address = [[NSMutableString alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    self.tabBarController.tabBar.hidden = YES;
    _btnArray = [[NSMutableArray alloc] init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    __block RegiestViewController *blockSelf = self;
    [_dm getCommunityTentListWithCid:_dm.communityId];
    [_dm setCommunityTentListBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
    }];
    
    [self createUI];
    [self createTableView];
}

- (void)createTableView
{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(85, is_IPHONE_6?70+35:90+35, 220, 200) style:UITableViewStylePlain];
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
        [((UIButton *)([_btnArray objectAtIndex:_btnTag])) setTitle:comm.commName forState:UIControlStateNormal];
        ((UIButton *)([_btnArray objectAtIndex:_btnTag+1])).enabled = YES;
        
    }
    else if(_btnTag == 1)
    {
        [((UIButton *)([_btnArray objectAtIndex:_btnTag])) setTitle:comm.commName forState:UIControlStateNormal];
        _commId = comm.commId;
        ((UIButton *)([_btnArray objectAtIndex:_btnTag+1])).enabled = YES;

    }
    else if(_btnTag == 2)
    {
        [((UIButton *)([_btnArray objectAtIndex:_btnTag])) setTitle:comm.commName forState:UIControlStateNormal];
    }
    [_address appendString:comm.commName];
    if(self.count == 0)
    {
        _addressBlock(_address,_date,_time,_commId);
    }
}

// 创建注册界面
- (void)createUI
{

    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 46)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"门栋号选择" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    
    NSArray *titleName = [NSArray arrayWithObjects:@"门栋号:",@"单元:",@"门牌:", nil];
    for(NSInteger i = 0; i < 3; i++ )
    {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(20, 50*i+90, 80, 30);
        label.text = [titleName objectAtIndex:i];
        label.textColor = [UIColor colorWithRed:0.56f green:0.58f blue:0.61f alpha:1.00f];
        [self.view addSubview:label];

        
        UIImageView *backImageView = [[UIImageView alloc] init];
        backImageView.frame = CGRectMake(85, 50*i+90, 220, 35);
        backImageView.image = [UIImage imageNamed:@"输入框.png"];
        backImageView.userInteractionEnabled = YES;
        [self.view addSubview:backImageView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0,0, 190, 35);
        [button setTitle:@"请选择" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.56f green:0.58f blue:0.61f alpha:1.00f] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(bbiClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        
        if(i == 1 || i == 2)
        {
            button.enabled = NO;
        }
        
        [backImageView addSubview:button];
        [_btnArray addObject:button];
        
        UIImageView *rightImageView = [[UIImageView alloc] init];
        rightImageView.frame = CGRectMake(190, 5,25, 25);
        if(i == 0)
        {
            rightImageView.image = [UIImage imageNamed:@"下.png"];
        }
        else
        {
            rightImageView.image = [UIImage imageNamed:@"右边.png"];
        }
        [backImageView addSubview:rightImageView];
    }
    if(self.count != 0)
    {
    
        UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jumpBtn.frame = CGRectMake(85, 250, 90, 30);
        [jumpBtn setBackgroundImage:[UIImage imageNamed:@"门栋号选择_07.png"] forState:UIControlStateNormal];
        [jumpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [jumpBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [jumpBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        jumpBtn.tag = 103;
        [self.view addSubview:jumpBtn];
        
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextBtn.frame = CGRectMake(210, 250, 90, 30);
        [nextBtn setBackgroundImage:[UIImage imageNamed:@"门栋号选择_07-17.png"] forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        nextBtn.tag = 104;
        [self.view addSubview:nextBtn];
    }
}

// 触发点击事件
- (void)btnClick:(UIButton *)button
{
    NSLog(@"button.tag = %d",button.tag);
    switch (button.tag)
    {
        case 103:   // 跳过
        {
            PhoneViewController *phone = [[PhoneViewController alloc] init];
            [self.navigationController pushViewController:phone animated:YES];
            break;
        }
        case 104:   // 下一步
        {
            // 判断是否为空
            [self isChooseNULL];
            if(_isNULL)
            {
                PhoneViewController *phone = [[PhoneViewController alloc] init];
                [self.navigationController pushViewController:phone animated:YES];
            }
            break;
        }
        default:
            break;
    }
}

// 判断是否为空
- (void)isChooseNULL
{
    for(UIButton *button in _btnArray)
    {
        if(button.titleLabel.text == nil)
        {
            _isNULL = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请正确填写信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else
        {
            _isNULL = YES;
        }
    }
}

// 测试
- (void)bbiClick:(UIButton *)button
{
    if(button.tag == 100)
    {
        [_dataArray removeAllObjects];
        _tableView.hidden = NO;
        _btnTag = 0;
        _tableView.frame = CGRectMake(85, 90+35, 220, 200);
        __block RegiestViewController *blockSelf = self;
        [_dm getCommunityTentListWithCid:1];
        [_dm setCommunityTentListBlock:^(NSArray *array) {
            [blockSelf -> _dataArray addObjectsFromArray:array];
            [blockSelf -> _tableView reloadData];
        }];
    }
    else if(button.tag == 101)
    {
        [_dataArray removeAllObjects];
        _btnTag = 1;
        _tableView.hidden = NO;
        _tableView.frame = CGRectMake(85, 90+35+35+20, 220, 200);
        __block RegiestViewController *blockSelf = self;
        //NSString *str = ((UIButton *)([_btnArray objectAtIndex:1])).titleLabel.text;
        [_dm getCommunityUnityListWithCid:1 andTid:1];
        [_dm setCommuntityuntityListBlock:^(NSArray *array) {
            [blockSelf -> _dataArray addObjectsFromArray:array];
            [blockSelf -> _tableView reloadData];
        }];
    }
    else if(button.tag == 102)
    {
        [_dataArray removeAllObjects];
        _btnTag = 2;
        _tableView.hidden = NO;
        _tableView.frame = CGRectMake(85, 90+35+35+20+35+20, 220, 200);
        __block RegiestViewController *blockSelf = self;
        [_dm getCommunityRommListWithUid:1];
        [_dm setCommunityRoomListBlock:^(NSArray *array) {
            [blockSelf -> _dataArray addObjectsFromArray:array];
            [blockSelf -> _tableView reloadData];
        }];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    
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
