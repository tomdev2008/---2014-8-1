//
//  MySpeakViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-29.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "MySpeakViewController.h"
#import "MyNavigationBar.h"
#import "ZL_CONST.h"
#import "NeighborCell.h"
#import "AppDelegate.h"
#import "DownLoadManager.h"
#import "ZL_INTERFACE.h"
#import "MMLocationManager.h"
#import "DownLoadManager.h"

@interface MySpeakViewController ()

@end

@implementation MySpeakViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
    UILabel *_addressLabel;
    int _pageNo;
    float _autoHeight;
    UIButton *_imageButton;
    NSMutableArray *_dataArray;
    NSMutableArray *_allArray;
    UITableView *_tableView;
    LoadingView *_loadingView;

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
    
    // 初始化
    _dataArray = [[NSMutableArray alloc] init];
    _allArray = [[NSMutableArray alloc] init];
    __block MySpeakViewController *blockSelf = self;
    _dm = [DownLoadManager shareDownLoadManager];
    [_dm getMySayList:[NSString stringWithFormat:@"%d",_dm.communityId] andUid:[NSString stringWithFormat:@"%d",self.uid] andPage:1];
    [_dm setNeighborListBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf getData];
        [blockSelf -> _tableView reloadData];
        [blockSelf -> _loadingView loadingViewDispear:0.0];
    }];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"我的说说" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
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
- (void)getData
{
    for(int i = 0; i < _dataArray.count; i ++)
    {
        Neighbor *nei = [_dataArray objectAtIndex:i];
        [_allArray addObject:nei];
    }
}

// 创建TableView
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44:64, 320, isRetina.size.height>480?548-44:480-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_allArray.count > 0)
    {
        return [_allArray count];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NeighborCell" owner:self options:nil] lastObject];
    }
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
        // 用户名
        UIButton *userNameButton = [[UIButton alloc] init];
        userNameButton.frame = CGRectMake(82, 15, 73, 21);
        [userNameButton setTitle:user.userName  forState:UIControlStateNormal];
        userNameButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [userNameButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [userNameButton addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
        userNameButton.tag = 107;
        [cell.contentView addSubview:userNameButton];
        
        // 内容
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 35, 300-100, 20)];
        contentLabel.numberOfLines = 0;
        NSString *contents = nei.neiContent;
        UIFont *font = [UIFont systemFontOfSize:14];
        contentLabel.font = font;
        contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        contentLabel.textColor = [UIColor lightGrayColor];
        contentLabel.text = contents;
        CGSize size = CGSizeMake(300-100, 80);
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
        contentLabel.frame = CGRectMake(100, 35, labelSize.width, labelSize.height+10);
        [cell.contentView addSubview:contentLabel];
        
        // 图片
        if(neiPicture.count > 0)
        {
            UIImageView *showImage = [[UIImageView alloc] init];
            showImage.frame = CGRectMake(0, 0, 130, 80);
            [showImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,[neiPicture objectAtIndex:0]]]];
            _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _imageButton.frame = CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y+contentLabel.frame.size.height, 130, 80);
            _imageButton.tag = 400+indexPath.row;
            [_imageButton addTarget:self action:@selector(bbiClick:) forControlEvents:UIControlEventTouchUpInside];
            [_imageButton addSubview:showImage];
            [cell.contentView addSubview:_imageButton];
//            // 共几张
//            UILabel *label = [[UILabel alloc] init];
//            label.frame= CGRectMake(_imageButton.frame.origin.x+_imageButton.frame.size.width+10, (_imageButton.frame.origin.y+_imageButton.frame.size.height)/2+20, 100, 20);
//            label.text = [NSString stringWithFormat:@"共 %ld 张",(unsigned long)neiPicture.count];
//            label.textColor = [UIColor darkGrayColor];
//            label.font = [UIFont systemFontOfSize:14];
//            [cell.contentView addSubview:label];
            _autoHeight = userNameButton.frame.size.height+contentLabel.frame.size.height+_imageButton.frame.size.height;
        }
        _autoHeight = userNameButton.frame.size.height + contentLabel.frame.size.height;
        
        // 头像
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,user.userFace]]];
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.frame = CGRectMake(15, 12, 65, 65);
        [imageButton addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
        imageButton.tag = 300+indexPath.row;
        [imageButton addSubview:imageView];
        [cell.contentView addSubview:imageButton];
        
        // 赞，评论，转发
        for(NSInteger i = 0; i < 3;i ++)
        {
            UILabel *label = [[UILabel alloc] init];
            if(i == 0)label.text = nei.neiCommentNum;
            else if(i == 1)label.text = nei.neiShareNum;
            else label.text = nei.neiForwardNum;
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:12];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if(i == 0)[button setBackgroundImage:[UIImage imageNamed:@"赞.png"] forState:UIControlStateNormal];
            else if(i == 1)[button setBackgroundImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
            else[button setBackgroundImage:[UIImage imageNamed:@"转发.png"] forState:UIControlStateNormal];
            if(neiPicture.count <= 0)
            {
                
                label.frame =CGRectMake(contentLabel.frame.origin.x+25+80*i, contentLabel.frame.origin.y+contentLabel.frame.size.height+20, 20, 20);
                button.frame = CGRectMake(contentLabel.frame.origin.x+80*i, contentLabel.frame.origin.y+contentLabel.frame.size.height+20, 20, 20);
            }
            else
            {
                label.frame = CGRectMake(contentLabel.frame.origin.x+25+80*i, _imageButton.frame.origin.y+_imageButton.frame.size.height+10, 20, 20);
                button.frame = CGRectMake(contentLabel.frame.origin.x+80*i, _imageButton.frame.origin.y+_imageButton.frame.size.height+10, 20, 20);
            }
            button.tag = 200+i;
            [button addTarget:self action:@selector(bbiClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:button];
        }

    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Neighbor *nei = [_allArray objectAtIndex:indexPath.row];
    NSArray *array  = nei.neiPictureArray;
    
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

    
    if(array.count <= 0)
    {
        return labelSize.height+90.0f;
    }
    return labelSize.height+170.0f;
}
- (void)bbiClick:(UIButton *)button
{
    NSLog(@"赞，评论，转发");
}

- (void)bbiItem:(UIButton *)button
{
    if(button.tag == 1)
    {
        // 控制邻居圈刷新界面
       // _app.isFirst_nei = 1;     //zhaoheng
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
