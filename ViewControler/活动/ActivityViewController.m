//
//  ActivityViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-28.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "ActivityViewController.h"
#import "MyNavigationBar.h"
#import "ActivityCell.h"
#import "ActivityInfoViewController.h"
#import "ZL_CONST.h"
#import "DownLoadManager.h"
#import "ZL_INTERFACE.h"
#import "LoadingView.h"
#import "AppDelegate.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    DownLoadManager *_dm;
    LoadingView *_loadingView;
    AppDelegate *_app;
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

- (void)viewDidAppear:(BOOL)animated
{
    __block ActivityViewController *blockSelf = self;
    [_dm getActivityListWithCid:[NSString stringWithFormat:@"%d",_dm.communityId] andPage:@"1"];
    [_dm setActivityBlock:^(NSArray *array) {
        [blockSelf->_dataArray addObjectsFromArray:array];
        [blockSelf->_tableView reloadData];
        [blockSelf -> _loadingView loadingViewDispear:0];
    }];
    NSLog(@"-------%@-----%@",_dm.status,@"没有数据");
    if([_dm.status isEqualToString:@"400"])
    {
        [_loadingView loadingViewDispear:0.0];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // 初始化
    _dataArray = [[NSMutableArray alloc] init];
    _dm = [DownLoadManager shareDownLoadManager];
    _app = [UIApplication sharedApplication].delegate;
    //_app.isFirst_nei = 1;    // 防止邻居圈刷新 zhaoheng
    // 创建导航控制器
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"活动" andLeftButtonImage:nil andRightButtonImage:@"默认发起对话的icon.png" andSEL:@selector(bbiItem) andClass:self];
    [self.view addSubview:mnb];
    
    //　创建TableView;
    if(isRetina.size.height > 480)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44:64, 320, 568-64-49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    else
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44:64, 320, 480-64-49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self createLoadView];
}

- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
}

// tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_dataArray.count > 0)
    {
        return _dataArray.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:self options:nil] lastObject];
    }
    
    if(_dataArray.count > 0)
    {
        Activity *acti = [_dataArray objectAtIndex:indexPath.row];
        User *user = [acti.actiBuilderArray objectAtIndex:0];
        if(user.userFace.length <= 0)
        {
            cell.faceImge.image = [UIImage imageNamed:@"头像-男.png"];
        }
        else
        {
            [cell.faceImge setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,user.userFace]]];
        }
        cell.contentLabel.text = acti.actiContent;
        cell.sendTimeLabel.text = acti.actiSend_Time;
        cell.userName.text = user.userName;
        cell.joinNumLabel.text = acti.actiJoinNum;
        cell.shareNumLabel.text = acti.actiShareNum;
        cell.lookNumLabel.text = acti.actiLookNum;
        cell.themeLabel.text = acti.actiTheMe;
        [cell.titlePicImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,acti.actiTitlePic]]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_dataArray.count > 0)
    {
        Activity *acti = [_dataArray objectAtIndex:indexPath.row];
        if(acti.actiTitlePic.length > 0)
        {
            return 220.0f;
        }
        else
        {
            return 220.0 - 60.0f;
        }
    }
    return 220.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityInfoViewController *info = [[ActivityInfoViewController alloc] init];
    Activity *acti = [_dataArray objectAtIndex:indexPath.row];
    info.aid = acti.actiId;
    [self.navigationController pushViewController:info animated:YES];
}
// 点击右边按钮
- (void)bbiItem
{
    NSLog(@"按钮被点击");
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
