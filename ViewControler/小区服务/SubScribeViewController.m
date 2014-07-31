//
//  SubScribeViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-4.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "SubScribeViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "PriceInfoViewController.h"
#import "CommentsViewController.h"
#import "ServerOrdersViewController.h"
#import "DownLoadManager.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "FillOrderInfoViewController.h"
#import "SendMessageViewController.h"

@interface SubScribeViewController ()

@end

@implementation SubScribeViewController
{
    AppDelegate *_app;
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
    NSInteger timeCount;
    UITableView *_tableView;
    
    DownLoadManager *_dm;
    NSMutableArray *_dataArray;
    LoadingView *_loadingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.hidesBottomBarWhenPushed = YES; // Custom initialization
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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"服务详情" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    
    _dm = [DownLoadManager shareDownLoadManager];
    _dataArray = [[NSMutableArray alloc] init];
    [_dm getServerDetailWithsid:_sid];
    __block SubScribeViewController *blockSelf = self;
    [_dm setServerDetailBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
        [blockSelf -> _loadingView loadingViewDispear:0];
    }];
    
    
    NSArray *array = [NSArray arrayWithObjects:@"邻居说图0.png",@"邻居说图1.png",@"邻居说图2.png",@"邻居说图3.png", nil];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 144, 320, 20)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.7f;
    
    // 创建滚动动画
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,is_IPHONE_6?44:64, 320, 120)];
    _scrollView.contentSize = CGSizeMake(320*4, 120);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    timeCount = 0;
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(220, 0, 320, 20)];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = array.count;
    [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:_pageControl];
    [self.view addSubview:view];
    
    for(NSInteger i = 0; i < array.count; i++ )
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(320*i, 0, 320, 120);
        imageView.image = [UIImage imageNamed:[array objectAtIndex:i]];
        [_scrollView addSubview:imageView];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    [self createTableView];
    [self createLoadView];
}

- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
}


- (void)createLineWithX:(float)x andY:(float)y andView:(UIView *)view andRightViewIsShow:(BOOL)isShow
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 300, 1)];
    [imageView setAlpha:0.5];
    imageView.image = [UIImage imageNamed:@"line.png"];
    [view addSubview:imageView];
    
    if(isShow)
    {
        UIImageView *rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右边.png"]];
        rightImage.frame = CGRectMake(imageView.frame.size.width-10, imageView.frame.origin.y-30, 20, 20);
        [view addSubview:rightImage];
    }
}
// 创建TablViewCell
- (void)createTabelViewCellSection:(UITableViewCell *)cell
{
    Server *server = [_dataArray objectAtIndex:0];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
    [cell.contentView addSubview:backView];
    // 1.
    UILabel *serverLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
    serverLabel.text = server.serName;
    // 获取订单内容赋值给单例
    _dm.serverContent = server.serName;
    serverLabel.textColor = [UIColor darkGrayColor];
    [backView addSubview:serverLabel];
    [self createLineWithX:10 andY:30 andView:backView andRightViewIsShow:NO];
    
    // 2.
    UILabel *contentLabel = [[UILabel alloc] init];
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    [contentLabel setNumberOfLines:0];
    NSString *content = server.serDescription;
    contentLabel.text = content;
    contentLabel.textColor = [UIColor darkGrayColor];
    contentLabel.font = font;
    CGSize size = CGSizeMake(320, 100);
    CGSize labelSize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [contentLabel setFrame:CGRectMake(10, 40, 300, labelSize.height)];
    [backView addSubview:contentLabel];
    [self createLineWithX:10 andY:contentLabel.frame.size.height+50 andView:backView andRightViewIsShow:NO];
    
    NSString *price = [NSString stringWithFormat:@"价格：%@",server.serPrice];
    NSString *brand = [NSString stringWithFormat:@"品牌故事"];
    NSString *comment = [NSString stringWithFormat:@"评价：共%@条",server.serCommentNum];
    NSString *Mername = [NSString stringWithFormat:@"商铺名称：%@",server.serMerName];
    
    // 价格
    NSArray *array = [NSArray arrayWithObjects:price,brand,comment,Mername, nil];
    for(NSInteger i = 0; i < 4; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, contentLabel.frame.size.height+55+40*i, 200, 20);
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = 101 + i;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        
        if(i < 3)
        {
            [self createLineWithX:10 andY:button.frame.origin.y+30 andView:backView andRightViewIsShow:YES];
        }
        if(i == 3)
        {
            UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            messageButton.frame = CGRectMake(320-60, button.frame.origin.y-5, 30, 30);
            messageButton.titleLabel.font = [UIFont systemFontOfSize:13];
            [messageButton setBackgroundImage:[UIImage imageNamed:@"评论过.png"] forState:UIControlStateNormal];
            [messageButton addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
            messageButton.tag = 110;
            [backView addSubview:messageButton];
            [self createLineWithX:10 andY:button.frame.origin.y + 30 andView:backView andRightViewIsShow:NO];
            
        }
    }
    
    UIButton *orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    orderButton.frame = CGRectMake(30, backView.frame.size.height+174, 260, 40);
    if(![self.orderType isEqualToString:@"0"])
    {
        [orderButton setTitle:@"呼叫预约" forState:UIControlStateNormal];
    }
    else
    {
        [orderButton setTitle:@"直接下单" forState:UIControlStateNormal];
    }
    orderButton.titleLabel.font = [UIFont systemFontOfSize:15];
    orderButton.tag = 120;
    [orderButton setBackgroundImage:[UIImage imageNamed:@"门栋号选择_07-17.png"] forState:UIControlStateNormal];
    [orderButton addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderButton];
    
    
}

// 创建TableView;
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 164, 320, 250)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    else
    {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(_dataArray.count > 0)
    {
        [self createTabelViewCellSection:cell];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250.0f;
}
//滚图的动画效果
-(void)pageTurn:(UIPageControl *)aPageControl{
    int whichPage = aPageControl.currentPage;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [_scrollView setContentOffset:CGPointMake(320.0f * whichPage, 0.0f) animated:YES];
    [UIView commitAnimations];
}

//定时滚动
-(void)scrollTimer{
    timeCount ++;
    if (timeCount == 4) {
        timeCount = 0;
        [_scrollView scrollRectToVisible:CGRectMake(timeCount * 320.0, 65.0, 320.0, 120) animated:NO];
    }
    _pageControl.currentPage = timeCount;
    [_scrollView scrollRectToVisible:CGRectMake(timeCount * 320.0, 65.0, 320.0, 120) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/320;
    _pageControl.currentPage = index;
}
- (void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)bbiItem:(UIButton *)button
{
    Server *ser = [_dataArray objectAtIndex:0];
    switch(button.tag)
    {
        case 101:
            NSLog(@"价格");
        {
            Server *server = [_dataArray objectAtIndex:0];
            if([server.serPrice_type isEqualToString:@"0"])
            {
                return;
            }
            else
            {
                PriceInfoViewController *price = [[PriceInfoViewController alloc] init];
                price.sid = [NSString stringWithFormat:@"%d",_sid];
                if(server.serPrice_type == 0)
                {
                    price.type = @"2";
                }
                else
                {
                    price.type = @"1";
                }
                [self.navigationController pushViewController:price animated:YES];
            }
        }
            break;
        case 102:
            NSLog(@"品牌故事");
            break;
        case 103:
        {
            CommentsViewController *comment = [[CommentsViewController alloc] init];
            [self.navigationController pushViewController:comment animated:YES];
            break;
        }
        case 104:
            NSLog(@"商铺名称");
            break;
        case 110:
        {
            SendMessageViewController *send = [[SendMessageViewController alloc] init];
            send.userId = ser.serMerId;
            send.name = ser.serMerName;
            send.userFace = ser.serTitlePic;
            [self.navigationController pushViewController:send animated:YES];
            break;
        }
        case 120:
        {
            if(![self.orderType isEqualToString:@"0"])
            {
                ServerOrdersViewController *serverOrder = [[ServerOrdersViewController alloc] init];
                serverOrder.sid  = _sid;
                [self.navigationController pushViewController:serverOrder animated:YES];
            }
            else
            {
                FillOrderInfoViewController *fill = [[FillOrderInfoViewController alloc] init];
                fill.serId = [NSString stringWithFormat:@"%d",self.sid];
                fill.comeId = 0;
                [self.navigationController pushViewController:fill animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
