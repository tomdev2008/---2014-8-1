//
//  NeighborInfoViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "NeighborInfoViewController.h"
#import "AppDelegate.h"
#import "MyNavigationBar.h"
#import "DownLoadManager.h"
#import "CommentViewController.h"
#import "ZL_CONST.h"
#import "LoadingView.h"
#import "ZL_INTERFACE.h"
#import "LoginViewController.h"
#import "Login_480_ViewController.h"
#import "AddressBookViewController.h"
#import "TQRichTextView.h"

@interface NeighborInfoViewController ()

@end

@implementation NeighborInfoViewController
{
    UITableView *_tableView;
    AppDelegate *_app;
    DownLoadManager *_dm;
    NeighobrInfo *_neiInfo;
    UIView *_backView;  // 内容+赞，评论，分享的View
    LoadingView *_loadingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initializatiom
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    _dm = [DownLoadManager shareDownLoadManager];
    [self getDataWithSid:self.sid];
    NSLog(@"-------%@-----%@",_dm.status,@"没有数据");
    if([_dm.status isEqualToString:@"400"])
    {
        [_loadingView loadingViewDispear:0.0];
    }
}

- (void)createNavitation
{
    // 获取数据
//    _dm = [DownLoadManager shareDownLoadManager];
//    [self getDataWithSid:_sid];
    self.tabBarController.tabBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"邻居圈详情" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
}

- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    
    [_loadingView createLoadingView:YES andAlpha:1.0];
}

// 获取数据
- (void)getDataWithSid:(NSString *)sid
{
    __block NeighborInfoViewController *blockSelf = self;
    [_dm getNeighborInfo:sid];
    [_dm setNeighborInfoBlock:^(NeighobrInfo *info) {
        blockSelf -> _neiInfo = info;
        [blockSelf -> _tableView reloadData];
        [blockSelf -> _loadingView loadingViewDispear:0.0];
    }];
}
// 点击了赞之后
- (void)clickZanWithSid:(NSString *)sid
{
    [_dm clickZanWithSid:[sid intValue]];
    UILabel *lable = (UILabel *)[_backView viewWithTag:30];
    [_dm setClickZanSuccessBlock:^(int zanNum) {
        lable.text = [NSString stringWithFormat:@"%d",zanNum];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavitation];
    [self createTableView];
    [self createLoadView];

}

#pragma mark - UITableView
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44:64, 320, isRetina.size.height>480?568-64:480-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
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
    else
    {
        return _neiInfo.neiInfoComments.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section == 0)
    {
        //NSLog(@"%f",((UIButton *)[[(UIView *)[cell.contentView.subviews objectAtIndex:0] subviews] lastObject]).frame.origin.y+40);
        //return ((UIButton *)[[(UIView *)[cell.contentView.subviews objectAtIndex:0] subviews] lastObject]).frame.origin.y+40;
        NSString *content = [_neiInfo neiInfoContent];
        UIFont *font = [UIFont systemFontOfSize:15];
        CGSize size = CGSizeMake(300, 1000);
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        CGSize aulcalSize;
        if(is_IPHONE_6)
        {
            aulcalSize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        }
        else
        {
            aulcalSize = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        }

        if(_neiInfo.neiInfoPictures.count > 0)
        {
            return aulcalSize.height+150+150;
        }
        else
        {
            return aulcalSize.height+150;
        }
        
    }
    else
    {
        return ((UILabel *)[cell.contentView viewWithTag:104]).frame.size.height+45;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = @"cell";
    if (indexPath.section == 0 && indexPath.row == 0) {
        cellName = @"header";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        if(indexPath.section == 0)
        {
            [self createInfoAndCommentAndFileText:cell];
        }
        else if(indexPath.section == 1)
        {
            [self createCommentCell:cell andIndexPath:indexPath];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(_neiInfo != nil)
    {
        if(indexPath.section == 0)
        {
            [self createValueSection0:cell andIndexPath:indexPath];
        }
        else if(indexPath.section == 1)
        {
            [self createValue:cell andIndexPath:indexPath];
        }
    }
    return cell;
}

#pragma mark - 详情 赞评论分享 评论条
- (void)createInfoAndCommentAndFileText:(UITableViewCell *)cell
{
    _backView = [[UIView alloc] init];
    //backView.backgroundColor = [UIColor redColor];
    _backView.frame = CGRectMake(0, 0, 320, 100);
    //backView.backgroundColor = [UIColor yellowColor];
    [cell.contentView addSubview:_backView];
    
    // 头像
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    headImage.tag = 90;
    [_backView addSubview:headImage];
    
    // 名字
    UILabel *nameLable = [[UILabel alloc] init];
    nameLable.frame = CGRectMake(60, 15, 200, 20);
    nameLable.tag = 91;
    nameLable.textColor = [UIColor darkGrayColor];
    [_backView addSubview:nameLable];
    
    // 时间
    UILabel *timeLable = [[UILabel alloc] init];
    timeLable.frame = CGRectMake(320-70, 15, 90, 20);
    timeLable.tag = 92;
    timeLable.font = [UIFont systemFontOfSize:12];
    nameLable.textColor = [UIColor colorWithRed:0.68f green:0.69f blue:0.72f alpha:1.00f];
    [_backView addSubview:timeLable];
    if(_neiInfo.neiInfoPictures.count > 0)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = CGRectMake(20, nameLable.frame.origin.y+nameLable.frame.size.height+20, 280, 150);
        scrollView.contentSize = CGSizeMake(280*_neiInfo.neiInfoPictures.count, 150);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = YES;
        scrollView.tag = 93;
        scrollView.pagingEnabled = YES;
        [_backView addSubview:scrollView];
        for(int i = 0; i < _neiInfo.neiInfoPictures.count; i ++)
        {
            UIImageView *picture = [[UIImageView alloc] init];
            picture.frame = CGRectMake(i*280, 0, 280, 150);
            picture.tag = 200+i;
            [scrollView addSubview:picture];
        }
    }
    
    // 内容
    UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 20)];
    NSString *content = _neiInfo.neiInfoContent;
    contentLable.numberOfLines = 0;
    UIFont *font = [UIFont systemFontOfSize:15];
    contentLable.font = font;
    contentLable.tag = 94;
    contentLable.textColor = [UIColor darkGrayColor];
    contentLable.lineBreakMode = NSLineBreakByTruncatingTail;
    //contentLable.backgroundColor = [UIColor lightGrayColor];
    [_backView addSubview:contentLable];
    CGSize size = CGSizeMake(300, 1000);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize actualsize;
    if(is_IPHONE_6)
    {
        actualsize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    }
    else
    {
        actualsize = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    }

    if(_neiInfo.neiInfoPictures.count > 0)
    {
        contentLable.frame = CGRectMake(20, 10+40+10+150, 280, actualsize.height+20);
    }
    else
    {
        contentLable.frame = CGRectMake(20, 10+40+10, 280, actualsize.height+20);
    }
    TQRichTextView *richTextView = [[TQRichTextView alloc] init];
    richTextView.backgroundColor = [UIColor clearColor];
    richTextView.textColor = [UIColor darkGrayColor];
    richTextView.tag = 105;
    richTextView.text = content;
    richTextView.frame = CGRectMake(0, 0, contentLable.frame.size.width, contentLable.frame.size.height+30);
    [contentLable addSubview:richTextView];
    
    
    // 赞评论转发
    
    for(int i = 0; i < 3; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(100+i*70, contentLable.frame.origin.y+contentLable.frame.size.height, 20, 20);
        button.tag = 10+i;
        [_backView addSubview:button];
        
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(button.frame.origin.x-10, button.frame.origin.y-10, button.frame.size.width+20, button.frame.size.height+20)];
        control.tag = 10+i;
        [control addTarget:self action:@selector(zanClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:control];

        UILabel *lable = [[UILabel alloc] init];
        lable.frame = CGRectMake(122+i*70, contentLable.frame.origin.y+contentLable.frame.size.height, 80, 20);
        lable.tag = 30+i;
        lable.textColor = [UIColor darkGrayColor];
        lable.font = [UIFont systemFontOfSize:14];
        //lable.backgroundColor = [UIColor darkGrayColor];
        [_backView addSubview:lable];

    }
    
    // 评论条
    UIImageView *headImage2 = [[UIImageView alloc] init];
    headImage2.tag = 95;
    headImage2.frame = CGRectMake(10, contentLable.frame.origin.y+contentLable.frame.size.height+30, 40, 40);
    // 必须登录，没有登录就显示默认
    
    [_backView addSubview:headImage2];
    
    UIButton *textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    textBtn.frame = CGRectMake(55,contentLable.frame.origin.y+contentLable.frame.size.height+35, 300-55, 30);
    [textBtn addTarget:self action:@selector(zanClick:) forControlEvents:UIControlEventTouchUpInside];
    textBtn.tag = 20;
    [_backView addSubview:textBtn];
    _backView.frame = CGRectMake(0, 0, 320, textBtn.frame.origin.y+40);
}
- (void)createValueSection0:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *headImage = (UIImageView *)[_backView viewWithTag:90];
    [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,self.userFace]]];
    UILabel *nameLable = (UILabel *)[_backView viewWithTag:91];
    nameLable.text = self.userName;
    UILabel *timeLable = (UILabel *)[_backView viewWithTag:92];
    timeLable.text  = self.sendTime;
//    UILabel *contentLable = (UILabel *)[_backView viewWithTag:94];
//    contentLable.text = _neiInfo.neiInfoContent;
    UIImageView *headImage2 = (UIImageView *)[_backView viewWithTag:95];
    if(_dm.myUserId != nil)
        [headImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,_dm.myUserFace]]];
    else
        headImage2.image = [UIImage imageNamed:@"头像-男.png"];
    
    
    UIButton *textBtn = (UIButton *)[_backView viewWithTag:20];
    [textBtn setBackgroundImage:[UIImage imageNamed:@"输入框.png"] forState:UIControlStateNormal];
    
    NSArray *array = [NSArray arrayWithObjects:@"赞.png",@"分享.png",@"转发.png", nil];
    NSArray *_garray = [NSArray arrayWithObjects:@"赞过.png",@"分享.png",@"转发.png", nil];
    NSArray *lables = [NSArray arrayWithObjects:_neiInfo.neiInfoZanNum,_neiInfo.neiInfoShareNum,_neiInfo.neiInfoForwardNum, nil];
    UIScrollView *scrollView = (UIScrollView *)[_backView viewWithTag:93];
    for(int i = 0; i < _neiInfo.neiInfoPictures.count; i ++)
    {
        UIImageView *pictureImage = (UIImageView *)[scrollView viewWithTag:200+i];
        [pictureImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,[_neiInfo.neiInfoPictures objectAtIndex:i]]]];
    }
    for(int i = 0; i < array.count; i ++)
    {
        UIButton *button =(UIButton *)[_backView viewWithTag:10+i];
        [button setBackgroundImage:[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];

        UILabel *lable = (UILabel *)[_backView viewWithTag:30+i];
        lable.text = [lables objectAtIndex:i];
    }
}
#pragma mark - 评论
- (void)createCommentCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *lineImage = [[UIImageView alloc] init];
    lineImage.frame = CGRectMake(20, 5, 280, 1);
    lineImage.image = [UIImage imageNamed:@"line.png"];
    lineImage.alpha = 0.4;
    [cell.contentView addSubview:lineImage];
    
    // 头像
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    

    headImage.tag = 101;
    [cell.contentView addSubview:headImage];
    
    // 名字
    UILabel *nameLable = [[UILabel alloc] init];
    nameLable.frame = CGRectMake(60, 10, 100, 20);
    nameLable.font = [UIFont systemFontOfSize:15];
    nameLable.textColor = [UIColor darkGrayColor];
    nameLable.tag = 102;
    [cell.contentView addSubview:nameLable];
    
    // 时间
    UILabel *timeLable = [[UILabel alloc] init];
    timeLable.frame = CGRectMake(320-70, 10, 90, 20);
    timeLable.text  =[[_neiInfo.neiInfoComments objectAtIndex:indexPath.row] neiInfoSend_Time];
    timeLable.font = [UIFont systemFontOfSize:12];
    nameLable.textColor = [UIColor colorWithRed:0.68f green:0.69f blue:0.72f alpha:1.00f];
    timeLable.tag = 103;
    [cell.contentView addSubview:timeLable];
    
    // 评论内容
    UILabel *contentLable = [[UILabel alloc] init];
    contentLable.frame = CGRectMake(60, 35, 320-70, 20);
    NSString *content =nil;
    if(_neiInfo.neiInfoComments.count > 0)
    {
        content = [[_neiInfo.neiInfoComments objectAtIndex:indexPath.row] neiInfoContent];
    }
    else
    {
        content = @"暂无评论";
    }
    contentLable.numberOfLines = 0;
    contentLable.tag = 104;
    UIFont *font = [UIFont systemFontOfSize:13];
    contentLable.font = font;
    contentLable.textColor = [UIColor darkGrayColor];
    contentLable.lineBreakMode = NSLineBreakByTruncatingTail;
    //contentLable.backgroundColor = [UIColor lightGrayColor];
    CGSize size = CGSizeMake(300, 1000);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize actualsize;
    if(is_IPHONE_6)
    {
        actualsize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    }
    else
    {
        actualsize = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    }
    contentLable.frame = CGRectMake(60, 35, 250, actualsize.height);
    TQRichTextView *richTextView = [[TQRichTextView alloc] init];
    richTextView.backgroundColor = [UIColor clearColor];
    richTextView.textColor = [UIColor darkGrayColor];
    richTextView.tag = 105;
    richTextView.frame = CGRectMake(0, 0, contentLable.frame.size.width, contentLable.frame.size.height+30);
    [contentLable addSubview:richTextView];
    [cell.contentView addSubview:contentLable];
}

- (void)createValue:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *headImage = (UIImageView *)[cell.contentView viewWithTag:101];
    [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,[[_neiInfo.neiInfoUsers objectAtIndex:indexPath.row] userFace]]]];
    UILabel *nameLable = (UILabel *)[cell.contentView viewWithTag:102];
    nameLable.text = [[_neiInfo.neiInfoUsers objectAtIndex:indexPath.row] userName];
    UILabel *timeLable = (UILabel *)[cell.contentView viewWithTag:103];
    timeLable.text  =[[_neiInfo.neiInfoComments objectAtIndex:indexPath.row] neiInfoSend_Time];
    UILabel *contentLable = (UILabel *)[cell.contentView viewWithTag:104];
    TQRichTextView *tqTextView = (UIView *)[contentLable viewWithTag:105];
    tqTextView.text = [[_neiInfo.neiInfoComments objectAtIndex:indexPath.row] neiInfoContent];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)zanClick:(UIButton *)button
{
    if(button.tag == 20)
    {
        CommentViewController *comm = [[CommentViewController alloc] init];
        comm.mid = @"1";
        comm.pid = self.sid;
        [self.navigationController pushViewController:comm animated:YES];
    }
    else if(button.tag == 10)   // 点击了赞
    {
        if(_dm.myUserId != nil)
        {
            [self clickZanWithSid:self.sid];
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
    else if(button.tag == 11)   // 点击了分享
    {
        if(_dm.myUserId != nil)
        {
            [self structShareContent];
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
    else        // 点击了转发
    {
        if(_dm.myUserId != nil)
        {
            AddressBookViewController *address = [[AddressBookViewController alloc] init];
            address.comeType = 2;   // 邻居说转发
            address.groupId = self.sid;
            [self.navigationController pushViewController:address animated:YES];
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
}
- (void)bbiItem:(UIButton *)bbi
{
    if(bbi.tag == 1)
    {
           //  _app.isFirst_nei = 1;    zhaoheng
        [self.navigationController popViewControllerAnimated:YES];
    }
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

- (void)structShareContent
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.sharesdk.cn"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

@end
