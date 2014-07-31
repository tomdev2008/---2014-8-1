//
//  NeighborViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-28.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "NeighborViewController.h"
#import "MyNavigationBar.h"
#import "PublishViewController.h"
#import "ActivityInfoViewController.h"
#import "MySpeakViewController.h"
#import "NeighborPageViewController.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "DownLoadManager.h"
#import "NeighborCell.h"
#import "UIImageView+WebCache.h"
#import "AppUtil.h"
#import "AppDelegate.h"
#import "LoadingView.h"
#import "PictureViewController.h"
#import "NeighborInfoViewController.h"
#import "CommunityViewController.h"
#import "Login_480_ViewController.h"
#import "LoginViewController.h"
#import "SendMessageViewController.h"

@interface NeighborViewController ()

@end

@implementation NeighborViewController
{
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
    UITableView *_tableView;
    UIView *_view;
    DownLoadManager *_dm;
    NSMutableArray *_dataArray;
    NSInteger _count;
    float _autoHeight;  // 自适应高度
    LoadingView *_lodingView;
    BOOL _reloading;
    NSInteger _pageCount;
    NSMutableArray *_allArray;
    AppDelegate *_app;
    UIView *_backView;
    NSMutableArray *_uidArray;
    
    BOOL _isOpen;   //
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
    _isOpen = YES;
    if(_dm.neiFlag)
    {
        [self downLoadDataWithCid:_dm.communityId andPage:1];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    _isOpen = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // 初始化
    self.flag = NO;
    _dataArray = [[NSMutableArray alloc] init];
    _lodingView = [[LoadingView alloc] init];
    self.richTextView = [[TQRichTextView alloc] init];
    _lodingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    _pageCount = 1;
    _uidArray = [[NSMutableArray alloc] init];
    _allArray = [[NSMutableArray alloc] init];
    _app = [UIApplication sharedApplication].delegate;
    // _app.isFirst_nei = 0;        zhaoheng
    _dm = [DownLoadManager shareDownLoadManager];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:[AppUtil dataPath]];
    if(user.userCommunity_Id > 0)
    {
        _dm.communityId = [user.userCommunity_Id intValue];
        [self downLoadDataWithCid:_dm.communityId andPage:1];
    }
    if(user.userCommunity_Id <= 0)
    {
        CommunityViewController *community = [[CommunityViewController alloc] init];
        [self.navigationController pushViewController:community animated:NO];
    }
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];

    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"邻居圈" andLeftButtonImage:@"发布邻居说.png" andRightButtonImage:@"ios呼叫icon.png" andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
    [mnb bringSubviewToFront:_scrollView];
    
    // 创建滚动动画
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, 320, 120)];
    _scrollView.contentSize = CGSizeMake(320*4, 120);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.tag = 202;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    // 创建TableView
    [self createTableView];
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *key =[NSString stringWithFormat:@"is_first"];
    NSString *value = [settings objectForKey:key];
    if(!value)
    {
        _count = 0;
        _app.mtb.alpha = 0.0f;
        [self createGuidePage];
        
        NSUserDefaults *settings1 = [NSUserDefaults standardUserDefaults];
        NSString *key1 = [NSString stringWithFormat:@"is_first"];
        [settings1 setObject:[NSString stringWithFormat:@"false"] forKey:key1];
        [settings1 synchronize];
    }
    else
    {
        [self.view addSubview:_lodingView];
        [_lodingView createLoadingView:YES andAlpha:1.0];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(__block int i = 0; i < 3; i ++)
        {
            sleep(3);
            if(_isOpen)
            {
                if(i == 2)
                {
                    i = -1;
                    _scrollView.contentOffset = CGPointMake(0, 0);
                }
                

                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.5 animations:^{
                        _scrollView.contentOffset = CGPointMake(320*(i+1), 0);
                        _pageControl.currentPage = i;
                    }];
                });
            }
            else
            {
               i--;
            }
        }
       
    });
}

// 创建引导页
- (void)createGuidePage
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, isRetina.size.height>0?568:480)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.tag = 101;
    scrollView.pagingEnabled = YES;
    if(isRetina.size.height > 480)
    {
        scrollView.contentSize = CGSizeMake(320*5,568);
    }
    else
    {
        scrollView.contentSize = CGSizeMake(320*5, 480);
    }
    NSArray *array = [NSArray arrayWithObjects:@"1_01",@"1_02",@"1_03",@"1_04", nil];
    for(NSInteger i = 0; i < array.count; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, isRetina.size.height>480?568:480)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[array objectAtIndex:i]]];
        [scrollView addSubview:imageView];
    }
    
    [self.view addSubview:scrollView];
}

// 得到总数据
- (void)getAllArray
{
    [_uidArray removeAllObjects];
    for(int i = 0; i < _dataArray.count; i ++)
    {
        Neighbor *nei = [_dataArray objectAtIndex:i];
        [_allArray addObject:nei];
        
    }
    for(int i = 0 ; i < _allArray.count; i ++)
    {
        Neighbor *neis = [_allArray objectAtIndex:i];
        for(int j = 0; j < neis.neiUserArray.count; j ++)
        {
            User *user = [neis.neiUserArray objectAtIndex:j];
            [_uidArray addObject:user.userId];
        }
    }

}
// 下载数据
- (void)downLoadDataWithCid:(int)cid andPage:(int)page
{
    __block NeighborViewController *blockSelf = self;
    [_dm getNeighborList:cid andPage:page];
    [_dm setNeighborListBlock:^(NSArray *array) {
        if(blockSelf -> _dm.neiFlag)
        {
            [blockSelf -> _dataArray removeAllObjects];
            [blockSelf -> _allArray removeAllObjects];
        }
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf getAllArray];
        [blockSelf -> _tableView reloadData];
        blockSelf -> _lodingView.alpha  = 0;
    }];
    // 保证不是最后一页
    if(_dataArray.count >= 10)
    {
        [_lodingView createLoadingView:YES andAlpha:1.0];
    }
}

// 引导页
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.tag == 101)
    {
        NSLog(@"sdfs");
        NSInteger index = scrollView.contentOffset.x/320;
        if(index == 3)
        {
            _count = 1;
            [_lodingView createLoadingView:YES andAlpha:1.0];
            [UIView animateWithDuration:2.0 animations:^{
                scrollView.alpha = 0.0;
                _app.mtb.alpha = 1.0f;
            }];
        }
    }
    else if(scrollView.tag == 202)
    {
        NSInteger index = scrollView.contentOffset.x/320;
        _pageControl.currentPage = index;
        NSLog(@"index : %d",index);
        if(index == 0)
        {
            scrollView.contentOffset = CGPointMake(3*320, 0);
        }
        else if(index == 4)
        {
            scrollView.contentOffset = CGPointMake(320, 0);
        }
    }
}

// 创建TableView
- (void)createTableView
{
    _egoRefresh = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -_tableView.frame.size.height, 320, _tableView.frame.size.height)];
    _egoRefresh.delegate = self;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44:64, 320, isRetina.size.height>480?548-49-44:480-49-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView addSubview:_egoRefresh];
    [self.view addSubview:_tableView];

    
    // 点击加载更多
    UIView *loadView = [[UIView alloc] init];
    loadView.frame = CGRectMake(0, 0, 320, 30);
    loadView.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((loadView.frame.size.width-94)/2, 5, 94, 20);
    [button setTitle:@"点击加载更多" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(addMoreClick) forControlEvents:UIControlEventTouchUpInside];
    [loadView addSubview:button];
    _tableView.tableFooterView = loadView;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        if(_allArray.count > 0)
        {
            return _allArray.count;
        }
        else
        {
            return 0;
        }
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

    if(indexPath.section == 0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(_dm.advers.count > 0)
        {
            for(NSInteger i = 0; i < _dm.advers.count; i++ )
            {
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.frame = CGRectMake(320*(i+1), 0, 320, 120);
                [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,[_dm.advers objectAtIndex:i]]]];
                [_scrollView addSubview:imageView];
            }
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(0, 0, 320, 120);
            [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,[_dm.advers objectAtIndex:2]]]];
            [_scrollView addSubview:imageView];
            
            UIImageView *imageView2 = [[UIImageView alloc] init];
            imageView2.frame = CGRectMake(320*4, 0, 320, 120);
            [imageView2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,[_dm.advers objectAtIndex:0]]]];
            [_scrollView addSubview:imageView2];
        }
        
        [cell.contentView addSubview:_scrollView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 20)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.7f;
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(220, 0, 100, 20)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = _dm.advers.count;
        [view addSubview:_pageControl];
        [cell.contentView addSubview:view];
        return cell;
        //使用NSTimer实现定时触发滚动控件滚动的动作。
    }
    if(indexPath.section == 1)
    {
        NeighborCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NeighborCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 绑定数据
        if(_allArray.count > 0)
        {
            Neighbor *nei = [_allArray objectAtIndex:indexPath.row];
            NSArray *neiPicture = nei.neiPictureArray;
            NSArray * neiUserArray = nei.neiUserArray;
            User *user;
            for(NSInteger i = 0; i < neiUserArray.count; i ++)
            {
                user = [neiUserArray objectAtIndex:i];
            }
            if(neiPicture.count <= 0)
            {
                cell.neiPictureLabel.hidden = YES;
            }
            cell.neiTimeLabel.text = nei.neiSend_Time;
            
            // 用户名
            UIButton *userNameButton = [[UIButton alloc] init];
            userNameButton.frame = CGRectMake(60, 15, 130, 21);
            [userNameButton setTitle:user.userName  forState:UIControlStateNormal];
            userNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            userNameButton.titleLabel.font = [UIFont systemFontOfSize:17];
            [userNameButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [userNameButton addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
            userNameButton.tag = 600+indexPath.row;
            [cell.contentView addSubview:userNameButton];
            
            // 内容
            UILabel *contentLabel = [[UILabel alloc] init];
            contentLabel.frame = CGRectMake(52, 35, 200, 20);
            contentLabel.numberOfLines = 0;
            NSString *contents = nei.neiContent;
            UIFont *font = [UIFont systemFontOfSize:15];
            contentLabel.font = font;
            contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            contentLabel.textColor = [UIColor lightGrayColor];
            //contentLabel.text = contents;
            CGSize size;
            if([nei.neiType isEqualToString:@"0"])
            {
               size = CGSizeMake(200, 80);
            }
            else
            {
                size = CGSizeMake(200, 80);
            }
            NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
            CGSize labelSize;
            if(is_IPHONE_6)
            {
                labelSize = [contents sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            }
            else
            {
                labelSize = [contents boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
            }
            if([nei.neiType isEqualToString:@"0"])
            {
                contentLabel.frame = CGRectMake(72, 50, labelSize.width, labelSize.height+10);
            }
            else
            {
                contentLabel.frame = CGRectMake(76+70, 60, 150, 30);
            }
            
            TQRichTextView *richTextView = [[TQRichTextView alloc] init];
            richTextView.backgroundColor = [UIColor clearColor];
            richTextView.textColor = [UIColor darkGrayColor];
            richTextView.frame = CGRectMake(0, 0, contentLabel.frame.size.width, contentLabel.frame.size.height+26);
            richTextView.text = contents;
            [contentLabel addSubview:richTextView];

            
            [cell.contentView addSubview:contentLabel];
            
            // 图片
            
            UIImageView *showImage = [[UIImageView alloc] init];
            if([nei.neiType isEqualToString:@"0"])
            {
                
                showImage.frame = CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y+contentLabel.frame.size.height, 130, 80);
            }
            else
            {
                showImage.frame = CGRectMake(76, 60, 60, 60);
            }
            [showImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,nei.neiTitlePic]]];

            [cell.contentView addSubview:showImage];
            
            _autoHeight = userNameButton.frame.size.height+contentLabel.frame.size.height+showImage.frame.size.height;
            _autoHeight = userNameButton.frame.size.height + contentLabel.frame.size.height;
            
            // 头像
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,user.userFace]]];
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButton.frame = CGRectMake(15, 12, 60, 60);
            [imageButton addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
            imageButton.tag = 300+indexPath.row;
            [imageButton addSubview:imageView];
            [cell.contentView addSubview:imageButton];
            
            // 屏蔽
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"屏蔽.png"] forState:UIControlStateNormal];
            button.frame = CGRectMake(280, 15, 20, 20);
            button.tag = 11000+indexPath.row;
            [cell.contentView addSubview:button];
            
            UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(button.frame.origin.x-10, button.frame.origin.y-10, button.frame.size.width+20, button.frame.size.height+20)];
            control.tag = 11000+indexPath.row;
            [control addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:control];

            
            
            
            // 赞，评论，转发
            for(NSInteger i = 0; i < 3;i ++)
            {
                UILabel *label = [[UILabel alloc] init];
                if(i == 0)
                {
                    label.text = nei.neiZanNum;
                }
                else if(i == 1)label.text = nei.neiShareNum;
                else label.text = nei.neiForwardNum;
                label.textColor = [UIColor lightGrayColor];
                label.font = [UIFont systemFontOfSize:12];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                
                if(i == 0)
                {
                    if([nei.neiZan isEqualToString:@"0"])
                    {
                        [button setBackgroundImage:[UIImage imageNamed:@"赞.png"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [button setBackgroundImage:[UIImage imageNamed:@"赞过.png"] forState:UIControlStateNormal];
                    }
                }
                else if(i == 1)
                {
                    [button setBackgroundImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
                }
                else
                {
                    [button setBackgroundImage:[UIImage imageNamed:@"转发.png"] forState:UIControlStateNormal];
                }

                if(nei.neiTitlePic.length > 0)
                {
                    if([nei.neiType isEqualToString:@"0"])
                    {
                        label.frame =CGRectMake(100+80*i, contentLabel.frame.origin.y+contentLabel.frame.size.height+showImage.frame.size.height+10, 80, 20);
                        button.frame = CGRectMake(76+80*i, contentLabel.frame.origin.y+contentLabel.frame.size.height+showImage.frame.size.height+10, 20, 20);
                    }
                    else
                    {
                        label.frame = CGRectMake(100+80*i, showImage.frame.size.height+showImage.frame.origin.y+10, 80, 20);
                        button.frame = CGRectMake(76+80*i, showImage.frame.size.height+showImage.frame.origin.y+10, 20, 20);
                    }
                }
                else
                {
                    label.frame = CGRectMake(100+80*i, contentLabel.frame.origin.y+contentLabel.frame.size.height, 80, 20);
                    button.frame = CGRectMake(76+80*i, contentLabel.frame.origin.y+contentLabel.frame.size.height, 20, 20);
                }
                [cell.contentView addSubview:label];
                [cell.contentView addSubview:button];
            }
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 120.0f;
    }
    else
    {
        Neighbor *nei = [_allArray objectAtIndex:indexPath.row];
        NSString *contents = nei.neiContent;
        CGSize size = CGSizeMake(300-82, 80);
        UIFont *font = [UIFont systemFontOfSize:14];
        NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        CGSize labelSize;
        if(is_IPHONE_6)
        {
            labelSize = [contents sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        }
        else
        {
            labelSize = [contents boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
        }
        if(nei.neiTitlePic.length > 0)
        {
            if([nei.neiType isEqualToString:@"0"])
            {
                return labelSize.height+90.0f+90;
            }
            else
            {
                return 160;
            }
        }
        else
        {
            return labelSize.height + 85;
        }
        return labelSize.height+190.0f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        NSLog(@"asdfsd");
    }
    else if (indexPath.section == 1)
    {
        Neighbor *nei = [_allArray objectAtIndex:indexPath.row];
        if([nei.neiType isEqualToString:@"0"])
            {
            NeighborInfoViewController *neiInfo = [[NeighborInfoViewController alloc] init];
            neiInfo.sid = nei.neiId;
            User *user = [nei.neiUserArray objectAtIndex:0];
            neiInfo.userFace = user.userFace;
            neiInfo.userName = user.userName;
            neiInfo.sendTime = nei.neiSend_Time;
            [self.navigationController pushViewController:neiInfo animated:YES];
        }
        else if([nei.neiType isEqualToString:@"1"])
        {
            ActivityInfoViewController *acti = [[ActivityInfoViewController alloc] init];
            acti.aid = nei.neiShare_Id;
            [self.navigationController pushViewController:acti animated:YES];
        }
    }
}

// 屏蔽邻居说
- (void)btnClick:(UIControl *)button
{
    _dm.neiFlag = YES;
    if(_dm.myUserId != nil)
    {
        NSLog(@"%d",button.tag);
        Neighbor *nei = [_allArray objectAtIndex:button.tag-11000];
        User *user = [nei.neiUserArray objectAtIndex:0];
        if(![user.userId isEqualToString:_dm.myUserId])
        {
            __block NeighborViewController *blockSelf = self;
            [_dm shieldUserWithUid:[user.userId intValue] andType:0];
            [_dm setShieldUserSuccessBlock:^{
                [blockSelf downLoadDataWithCid:blockSelf -> _dm.communityId andPage:1];
                NSLog(@"屏蔽成功了");
            }];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能屏蔽自己" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else
    {
        if(isRetina.size.height > 480)
        {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        }
        else
        {
            Login_480_ViewController *login = [[Login_480_ViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        }
    }

}

// 点击事件
- (void)bbiItem:(UIButton *)button
{
    if(button.tag == 1)
    {
        if(_dm.myUserId != nil)
        {
            PublishViewController *publish = [[PublishViewController alloc] init];
            
            [self.navigationController pushViewController:publish animated:YES];
        }
        else
        {
            if(isRetina.size.height > 480)
            {
                LoginViewController *login = [[LoginViewController alloc] init];
                login.loginPageType = 1;
                [self.navigationController pushViewController:login animated:YES];
            }
            else
            {
                Login_480_ViewController *login = [[Login_480_ViewController alloc] init];
                login.loginPageType = 1;
                [self.navigationController pushViewController:login animated:YES];
            }

        }
        
    }
    else if(button.tag == 2)
    {
        SendMessageViewController *send = [[SendMessageViewController alloc] init];
        send.userId = @"5";
        send.userFace = @"default_man_face.png";
        send.name = @"物业";
        [self.navigationController pushViewController:send animated:YES];
    }
    else if(button.tag >= 600 && button.tag <= 5000)
    {
        MySpeakViewController *mySpeak = [[MySpeakViewController alloc] init];
        NSLog(@"%d",[[_uidArray objectAtIndex:button.tag-600] intValue]);
        mySpeak.uid = [[_uidArray objectAtIndex:button.tag - 600] intValue];
        [self.navigationController pushViewController:mySpeak animated:YES];
    }
    else if(button.tag >= 300 && button.tag < 400)
    {
        NeighborPageViewController *page = [[NeighborPageViewController alloc] init];
        Neighbor *nei = [_allArray objectAtIndex:button.tag-300];
        NSArray *neiArray = nei.neiUserArray;
        User *user = [neiArray objectAtIndex:0];
        page.neighobrId = user.userId;
        [self.navigationController pushViewController:page animated:YES];
    }
}



//---------------------------------下拉刷新START-----------------------------------
// 触发刷新事件
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    if(!_reloading)
    {
        // 做刷新工作  必须是异步线程
        [_dataArray removeAllObjects];
        [_allArray removeAllObjects];
        _pageCount = 1;
        [self performSelectorInBackground:@selector(download) withObject:nil];
        [self downLoadDataWithCid:_dm.communityId andPage:1];
    }
}
- (void)download
{
    [NSThread sleepForTimeInterval:2];
    [self reloadTableViewDataSoure];
    if(_reloading)
    {
        [self doneLoadingTableViewData];
    }
    else
    {
        NSLog(@"NO");
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}
// 得到刷新日期
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}
// 判断拖拉是否触发事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == _tableView)
    {
        [_egoRefresh egoRefreshScrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_egoRefresh egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)reloadTableViewDataSoure
{
    _reloading = YES;
}
- (void)doneLoadingTableViewData
{
    NSLog(@"Finish");
    _reloading = NO;
    [self performSelectorOnMainThread:@selector(finish) withObject:nil waitUntilDone:NO];
}
- (void)finish
{
    [_tableView reloadData];
    // 刷新完成收起控件
    [_egoRefresh egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}
//----------------------------------下拉刷新END------------------------
//----------------------------------点击加载更多
- (void)addMoreClick
{
    self.flag = NO;
    [_dataArray removeAllObjects];
    _pageCount ++;
    [self downLoadDataWithCid:_dm.communityId andPage:_pageCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
