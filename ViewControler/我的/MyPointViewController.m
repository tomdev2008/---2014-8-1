//
//  MyPointViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "MyPointViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "DownLoadManager.h"

@interface MyPointViewController ()

@end

@implementation MyPointViewController
{
    UITableView *_tableView;
    UISegmentedControl *_segmentedControl;
    AppDelegate *_app;
    DownLoadManager *_dm;
    User *_user;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // 初始化
    
    _tagState = 0;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"我的积分" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    _dm = [DownLoadManager shareDownLoadManager];
    _user = [[User alloc] init];
    __block MyPointViewController *blockSelf = self;
    [_dm getMyPointInfo];
    [_dm setMyPointINfoBlock:^(User *user) {
        blockSelf -> _user = user;
        // 创建Title
        [blockSelf createTitle];
        // 创建TableView
        [blockSelf createMyPoint];
    }];
    

}
- (void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 创建title
- (void)createTitle
{
    User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:[AppUtil dataPath]];
    
    UIImageView *backImage = [[UIImageView alloc] init];
    backImage.frame = CGRectMake(0, is_IPHONE_6?44:64, 320, 150);
    backImage.image = [UIImage imageNamed:@"beij.png"];
    backImage.userInteractionEnabled = YES;
    [self.view addSubview:backImage];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = CGRectMake(20, 15, 80 , 80);
    headButton.tag = 101;
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,user.userFace]]];
    [headButton addSubview:imageView];
    [backImage addSubview:headButton];
    
    // 用户名
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(headButton.frame.origin.x+headButton.frame.size.width+10, 25, 200, 20);
    label.text = user.userNickName;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor darkGrayColor];
    [backImage addSubview:label];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y+30, 200, 20);
    addressLabel.text = [NSString stringWithFormat:@"历史积分:%@ 当前积分:%@",_user.userTotal,_user.userLeave];
    
    addressLabel.textColor = [UIColor darkGrayColor];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.font = [UIFont systemFontOfSize:13];
    [backImage addSubview:addressLabel];
    
    NSArray *segments = [NSArray arrayWithObjects:@"积分获取详情",@"积分消费详情", nil];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
    _segmentedControl.frame = CGRectMake(10, 110, 300, 30);
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.segmentedControlStyle =   UISegmentedControlStyleBar;
    [_segmentedControl addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor colorWithRed:0.12f green:0.63f blue:0.49f alpha:1.00f];
    [backImage addSubview:_segmentedControl];
}


- (void)createMyPoint
{
    if(isRetina.size.height > 480)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?150+44:150+64, 320, 548-150-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    else
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?150+44:150+64, 320, 480-150-64) style:UITableViewStylePlain];
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
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName_get = @"Cell_get";
    static NSString *cellName_out = @"Cell_out";
    if(_tagState == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName_get];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName_get];
        }
        cell.textLabel.text = @"点击广告获取20积分";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithRed:0.62f green:0.64f blue:0.66f alpha:1.00f];
        return cell;
    }
    else if(_tagState == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName_out];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName_out];
        }
        cell.textLabel.text = @"购买优惠券消费200积分";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithRed:0.62f green:0.64f blue:0.66f alpha:1.00f];
        return cell;
    }
    return nil;
}
- (void)segClick:(UISegmentedControl *)seg
{
    _tagState = seg.selectedSegmentIndex;
    [_tableView reloadData];
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
