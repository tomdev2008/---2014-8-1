//
//  ActivityInfoViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-5.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "ActivityInfoViewController.h"
#import "DownLoadManager.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "ApplyViewController.h"
#import "LoginViewController.h"
#import "Login_480_ViewController.h"
#import "CommentViewController.h"
#import "TQRichTextView.h"

@interface ActivityInfoViewController ()

@end

@implementation ActivityInfoViewController
{
    UITableView *_tableView;
    DownLoadManager *_dm;
    UIView *_backView;
    AppDelegate *_app;
    LoadingView *_loadingView;
    ActivityInfo *_actiInfo;
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
    _dm = [DownLoadManager shareDownLoadManager];
    if(_dm.myUserId != nil)
    {
        __block ActivityInfoViewController *blockSelf = self;
        [_dm getActivityDetailWithAid:_aid];
        [_dm setActivityDetailBlock:^(ActivityInfo *acti) {
            blockSelf -> _actiInfo = acti;
            [blockSelf -> _tableView reloadData];
        }];
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
    NSLog(@"-------%@-----%@",_dm.status,@"没有数据");
    if([_dm.status isEqualToString:@"400"])
    {
        [_loadingView loadingViewDispear:0.0];
    }
}

- (void)createNavigation
{
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"活动详情" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self createTableView];
}

- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
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
        return _actiInfo.actiInfoComments.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        NSString *content = [_actiInfo actiInfoContent];
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
        if(_actiInfo.actiInfoAddtions.count == 0)
        {
            return aulcalSize.height+350;
        }
        else
        {
            return aulcalSize.height+350+_actiInfo.actiInfoAddtions.count*50;
        }
    }
    else
    {
        NSString *content = [[[_actiInfo actiInfoComments] objectAtIndex:indexPath.row] commContent];
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

        return aulcalSize.height + 50;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = @"cell";
    if(indexPath.section == 0)
    {
        cellName = @"Header";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        if(indexPath.section == 0)
        {
            [self createSection_zero:cell];
        }
        else
        {
            [self createCommentCell:cell andIndexPath:indexPath];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(_actiInfo != nil)
    {
        if(indexPath.section == 0)
        {
            [self getValueData_Zero:indexPath];
        }
        else
        {
            [self createValue:cell andIndexPath:indexPath];
        }
    }
    
    return cell;
}

#pragma mark - 创建详情
- (void)createSection_zero:(UITableViewCell *)cell
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
    nameLable.frame = CGRectMake(60, 20, 100, 20);
    nameLable.tag = 91;
    nameLable.textColor = [UIColor darkGrayColor];
    [_backView addSubview:nameLable];
    
    // 评论  分享   转发
    for(int i = 0; i < 3; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(150+i*60, 20, 20, 20);
        [button addTarget:self action:@selector(zanClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 110+i;
        [_backView addSubview:button];
        
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(button.frame.origin.x-10, button.frame.origin.y-10, button.frame.size.width+20, button.frame.size.height+20)];
        control.tag = 110+i;
        [control addTarget:self action:@selector(zanClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:control];
        
        
        UILabel *lable = [[UILabel alloc] init];
        lable.frame = CGRectMake(172+i*60, 20, 20, 20);
        lable.tag = 120+i;
        lable.textColor = [UIColor darkGrayColor];
        lable.font = [UIFont systemFontOfSize:14];
        //lable.backgroundColor = [UIColor darkGrayColor];
        [_backView addSubview:lable];
        
        if(i == 0)[button setBackgroundImage:[UIImage imageNamed:@"评论.png"] forState:UIControlStateNormal];
        else if(i == 1)[button setBackgroundImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
        else[button setBackgroundImage:[UIImage imageNamed:@"人数.png"] forState:UIControlStateNormal];
    }
    
    UIImageView *xuImage = [[UIImageView alloc] init];
    xuImage.frame = CGRectMake(0, 50, 320, 1);
    xuImage.image = [UIImage imageNamed:@"虚线.png"];
    
    // 活动主题
    UILabel *themeLable = [[UILabel alloc] init];
    themeLable.frame = CGRectMake(20, xuImage.frame.origin.y+10, 150, 20);
    themeLable.tag = 92;
    [_backView addSubview:themeLable];
    
    // 时间
    UILabel *timeLable = [[UILabel alloc] init];
    timeLable.tag = 93;
    timeLable.frame = CGRectMake(200, xuImage.frame.origin.y+10, 100, 20);
    timeLable.font = [UIFont systemFontOfSize:13];
    timeLable.textColor = [UIColor darkGrayColor];
    [_backView addSubview:timeLable];

    //图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(20, nameLable.frame.origin.y+nameLable.frame.size.height+20, 280, 150);
    //scrollView.contentSize = CGSizeMake(280*_actiInfo.neiInfoPictures.count, 150);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = YES;
    scrollView.tag = 94;
    scrollView.pagingEnabled = YES;
    [_backView addSubview:scrollView];
    // 内容
    // 内容
    UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 20)];
    NSString *content = @"死快点交罚款了手机打开了房间数量的房价开始说了的开发技术可浪费"; //_actiInfo.neiInfoContent;
    contentLable.numberOfLines = 0;
    UIFont *font = [UIFont systemFontOfSize:15];
    contentLable.font = font;
    contentLable.tag = 95;
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

    contentLable.frame = CGRectMake(20, scrollView.frame.origin.y+scrollView.frame.size.height+10, 280, actualsize.height+50);
    
    UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    joinBtn.frame = CGRectMake(220, contentLable.frame.origin.y+contentLable.frame.size.height+10, 80, 25);
    [joinBtn setBackgroundImage:[UIImage imageNamed:@"立即参加.png"] forState:UIControlStateNormal];
    [joinBtn setTitle:@"立即参加" forState:UIControlStateNormal];
    [joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    joinBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    joinBtn.tag = 400;
    [joinBtn addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:joinBtn];
    
    UIImageView *lineImageContentNext = [[UIImageView alloc] init];
    lineImageContentNext.frame = CGRectMake(10, joinBtn.frame.origin.y+joinBtn.frame.size.height+10, 300, 1);
    lineImageContentNext.alpha = 0.4;
    lineImageContentNext.image = [UIImage imageNamed:@"line.png"];
    [_backView addSubview:lineImageContentNext];
    
    // 活动地点
    UILabel *addressLable = [[UILabel alloc] init];
    addressLable.frame = CGRectMake(20, lineImageContentNext.frame.origin.y+10, 280, 20);
    addressLable.font = [UIFont systemFontOfSize:16];
    addressLable.textColor = [UIColor darkGrayColor];
    addressLable.tag = 96;
    [_backView addSubview:addressLable];
    
    
    UIImageView *longImage = [[UIImageView alloc] init];
    if(_actiInfo.actiInfoAddtions.count <= 0)
    {
        longImage.frame = CGRectMake(0, addressLable.frame.origin.y+10, 320, 1);
    }
    else
    {
        longImage.frame = CGRectMake(0, addressLable.frame.origin.y+10+_actiInfo.actiInfoAddtions.count*40, 320, 1);
    }
    longImage.alpha = 0.4;
    longImage.image = [UIImage imageNamed:@"line.png"];
    _backView.frame = CGRectMake(0, 0, 320, longImage.frame.origin.y + 50);
    
   
    
}
- (void)getValueData_Zero:(NSIndexPath *)indexPath
{
    UIImageView *headImage = (UIImageView *)[_backView viewWithTag:90];
    [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,_actiInfo.actiInfoUserFace]]];
    UILabel *nameLable = (UILabel *)[_backView viewWithTag:91];
    nameLable.text = _actiInfo.actiInfoUserName;
    for(int i = 0; i < 3; i ++)
    {
        UILabel *lable = (UILabel *)[_backView viewWithTag:120+i];
        if(i == 0)lable.text = [NSString stringWithFormat:@"%d",_actiInfo.actiInfoComments.count];
        else if(i == 1)lable.text = _actiInfo.actiInfoShareNum;
        else lable.text = _actiInfo.actiInfoJoinNum;
    }
    UILabel *themeLable = (UILabel *)[_backView viewWithTag:92];
    themeLable.text = _actiInfo.actiInfoTheMe;
    UILabel *timeLable = (UILabel *)[_backView viewWithTag:93];
    timeLable.text = [NSString stringWithFormat:@"%@-%@",_actiInfo.actiInfoStart,_actiInfo.actiInfoEnd];
    UIScrollView *scrollView = (UIScrollView *)[_backView viewWithTag:94];
    NSLog(@"%@",scrollView.subviews);
    for(int i = 0; i < _actiInfo.actiInfoPictures.count; i ++)
    {
        UIImageView *picture = [[UIImageView alloc] init];
        picture.frame = CGRectMake(i*280, 0, 280, 150);
        [picture setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,[_actiInfo.actiInfoPictures objectAtIndex:i]]]];
        [scrollView addSubview:picture];
    }
    UILabel *contentLable = (UILabel *)[_backView viewWithTag:95];
    contentLable.text = _actiInfo.actiInfoContent;
    UILabel *addressLable = (UILabel *)[_backView viewWithTag:96];
    addressLable.text = [NSString stringWithFormat:@"活动地点:%@",@"不知道"];
    //NSLog(@"%@",[[_actiInfo.actiInfoAddtions objectAtIndex:i] commContent]);
    
    // 活动说明  是否有活动说明
    if(_actiInfo.actiInfoAddtions.count > 0)
    {
        for(int i = 0 ; i < _actiInfo.actiInfoAddtions.count; i ++)
        {
            UIImageView *lineImage = [[UIImageView alloc] init];
            lineImage.image = [UIImage imageNamed:@"line.png"];
            lineImage.frame = CGRectMake(10, addressLable.frame.origin.y+30+40*i, 300, 1);
            lineImage.alpha = 0.4;
            [_backView addSubview:lineImage];
            
            UILabel *addtionLable = [[UILabel alloc] init];
            addtionLable.frame = CGRectMake(20, addressLable.frame.origin.y+40+40*i, 280, 20);
            addtionLable.font = [UIFont systemFontOfSize:15];
            addtionLable.textColor = [UIColor darkGrayColor];
            addtionLable.tag = 300+i;
            [_backView addSubview:addtionLable];
        }
    }
    
    for(int i = 0; i < _actiInfo.actiInfoAddtions.count; i ++)
    {
        UILabel *addtionLable = (UILabel *)[_backView viewWithTag:300+i];
        addtionLable.text = [NSString stringWithFormat:@"%@:%@",[[_actiInfo.actiInfoAddtions objectAtIndex:i] commContent],[[_actiInfo.actiInfoAddtions objectAtIndex:i] commSendTime]];    // 附加说明A:说明........
    }
    
    // 评论条
    UIImageView *headImage2 = [[UIImageView alloc] init];
    headImage2.tag = 97;
    if(_actiInfo.actiInfoAddtions.count > 0)
    {
        headImage2.frame = CGRectMake(10,addressLable.frame.origin.y+addressLable.frame.size.height+15+_actiInfo.actiInfoAddtions.count*40, 40, 40);
    }
    else
    {
        headImage2.frame = CGRectMake(10,addressLable.frame.origin.y+addressLable.frame.size.height+20, 40, 40);
    }
    [headImage2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,_actiInfo.actiInfoUserFace]]];
    // 必须登录，没有登录就显示默
    [_backView addSubview:headImage2];
    
    UIButton *textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if(_actiInfo.actiInfoAddtions.count > 0)
    {
        textBtn.frame = CGRectMake(55,addressLable.frame.origin.y+addressLable.frame.size.height+20+_actiInfo.actiInfoAddtions.count*40, 300-55, 30);
    }
    else
    {
        textBtn.frame = CGRectMake(55,addressLable.frame.origin.y+addressLable.frame.size.height+30, 300-55, 30);
    }
    [textBtn setBackgroundImage:[UIImage imageNamed:@"输入框.png"] forState:UIControlStateNormal];
    [textBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    textBtn.tag = 20;
    [_backView addSubview:textBtn];
    _backView.frame = CGRectMake(0, 0, 320, textBtn.frame.origin.y+40);

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
    timeLable.text  =[[_actiInfo.actiInfoComments objectAtIndex:indexPath.row] commSendTime];
    timeLable.font = [UIFont systemFontOfSize:12];
    nameLable.textColor = [UIColor colorWithRed:0.68f green:0.69f blue:0.72f alpha:1.00f];
    timeLable.tag = 103;
    [cell.contentView addSubview:timeLable];
    
    // 评论内容
    UILabel *contentLable = [[UILabel alloc] init];
    contentLable.frame = CGRectMake(60, 35, 320-70, 20);
    NSString *content =nil;
    if(_actiInfo.actiInfoComments.count > 0)
    {
        content = [[_actiInfo.actiInfoComments objectAtIndex:indexPath.row] commContent];
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
    [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,[[_actiInfo.actiInfoUsers objectAtIndex:indexPath.row] userFace]]]];
    UILabel *nameLable = (UILabel *)[cell.contentView viewWithTag:102];
    nameLable.text = [[_actiInfo.actiInfoUsers objectAtIndex:indexPath.row] userName];
    UILabel *timeLable = (UILabel *)[cell.contentView viewWithTag:103];
    timeLable.text  =[[_actiInfo.actiInfoComments objectAtIndex:indexPath.row] commSendTime];
    UILabel *contentLable = (UILabel *)[cell.contentView viewWithTag:104];
    TQRichTextView *tqTextView = (UIView *)[contentLable viewWithTag:105];
    tqTextView.text = [[_actiInfo.actiInfoComments objectAtIndex:indexPath.row] commContent];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)bbiItem:(UIButton *)bbi
{
    if(bbi.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(bbi.tag == 400)
    {
        if(_dm.myUserId != nil)
        {
            ApplyViewController *apply = [[ApplyViewController alloc] init];
            apply.aid = _aid;
            [self.navigationController pushViewController:apply animated:YES];
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

// 点击输入评论
- (void)btnClick
{
    
    if(_dm.myUserId != nil)
    {
        CommentViewController *comment = [[CommentViewController alloc] init];
        comment.pid = self.aid;
        comment.mid = @"2";
        [self.navigationController pushViewController:comment animated:YES];
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

- (void)zanClick:(UIButton *)button
{
    if(button.tag == 111)
    {
        [self structShareContent];
    }
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

- (void)viewWillAppear:(BOOL)animated
{
    _app = [UIApplication sharedApplication].delegate;
    _app.mtb.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    _app.mtb.hidden = NO;
}

@end
