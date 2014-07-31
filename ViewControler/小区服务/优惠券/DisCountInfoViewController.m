//
//  DisCountInfoViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "DisCountInfoViewController.h"
#import "MyNavigationBar.h"
#import "DownLoadManager.h"
#import "AppDelegate.h"
#import "DisCountOrderViewController.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "CommentViewController.h"

@interface DisCountInfoViewController ()

@end

@implementation DisCountInfoViewController
{
    UITableView *_tableView;
    DownLoadManager *_dm;
    AppDelegate *_app;
    UIView *_backView;
    Coupon *_cou;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     self.hidesBottomBarWhenPushed = YES;   // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    _dm = [DownLoadManager shareDownLoadManager];
    [self getDataWithDid:self.did];
}

- (void)createNavitation
{
    // 获取数据
    //    _dm = [DownLoadManager shareDownLoadManager];
    //    [self getDataWithSid:_sid];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"优惠券详情" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavitation];
    [self createTableView];
}

- (void)getDataWithDid:(NSString *)did
{
    __block DisCountInfoViewController *blockSelf = self;
    [_dm getDiscountDetailWithCid:[did intValue]];
    [_dm setCouponDetailBlock:^(Coupon *cou) {
        blockSelf -> _cou = cou;
        [blockSelf -> _tableView reloadData];
    }];
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
    else if(section == 1)
    {
        return _cou.couComments.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section == 0)
    {
        NSString *content = _cou.couDiscription;
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

        if(_cou.couServices != nil)
        {
            return aulcalSize.height+200+280;
        }
        else
        {
            return aulcalSize.height+200+220;
        }
        
    }
    else if(indexPath.section == 1)
    {
        //NSLog(@"%f",((UILabel *)[cell.contentView.subviews lastObject]).frame.size.height+45);
        //NSLog(@"%@",[cell.contentView subviews]);
        return ((UILabel *)[cell.contentView.subviews lastObject]).frame.size.height+45;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = @"Cell";
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
        else if(indexPath.section == 1)
        {
            [self createSection_one:cell];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(_cou != nil)
    {
        if(indexPath.section == 0)
        {
            [self getValue_zero:indexPath];
        }
        else if(indexPath.section == 1)
        {
            [self getValue_one:indexPath andTabelViewCell:cell];
        }
    }
    return cell;
}
#pragma mark - 创建控件并赋值
- (void)createSection_zero:(UITableViewCell *)cell
{
    _backView = [[UIView alloc] init];
    //backView.backgroundColor = [UIColor redColor];
    _backView.frame = CGRectMake(0, 0, 320, 100);
    //backView.backgroundColor = [UIColor yellowColor];
    [cell.contentView addSubview:_backView];
    
    // 标题
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.tag = 101;
    titleLable.frame = CGRectMake(10, 10, 300, 20);
    [_backView addSubview:titleLable];
    
    // 有效期
    UILabel *timeLable = [[UILabel alloc] init];
    timeLable.tag = 102;
    timeLable.frame = CGRectMake(10, 40, 200, 20);
    timeLable.font = [UIFont systemFontOfSize:11];
    timeLable.textColor = [UIColor darkGrayColor];
    [_backView addSubview:timeLable];
    
    // 领取人数
    UILabel *personLable = [[UILabel alloc] init];
    personLable.tag = 103;
    personLable.frame = CGRectMake(230, 40, 100, 20);
    personLable.textColor = [UIColor colorWithRed:0.73f green:0.45f blue:0.17f alpha:1.00f];
    personLable.font = [UIFont systemFontOfSize:13];
    [_backView addSubview:personLable];
    
    // 图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(20, personLable.frame.origin.y+personLable.frame.size.height+10, 280, 150);
    scrollView.contentSize = CGSizeMake(300, 150);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = YES;
    scrollView.tag = 104;
    scrollView.pagingEnabled = YES;
    [_backView addSubview:scrollView];
    if(_cou.couPictures.count > 0)
    {
        for(int i = 0; i < _cou.couPictures.count; i ++)
        {
            UIImageView *picture = [[UIImageView alloc] init];
            picture.frame = CGRectMake(i*280, 0, 280, 150);
            picture.tag = 200+i;
            [scrollView addSubview:picture];
        }
    }
    else
    {
        UIImageView *picture = [[UIImageView alloc] init];
        picture.frame = CGRectMake(0, 60, 300, 150);
        [picture setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,_cou.couTitlePic]]];
        [scrollView addSubview:picture];
    }
    
    // 优惠券名字
    UILabel *nameLable = [[UILabel alloc] init];
    nameLable.tag = 105;
    nameLable.frame = CGRectMake(20, scrollView.frame.origin.y+scrollView.frame.size.height+10, 150, 20);
    [_backView addSubview:nameLable];
    
   // NSArray *array = [NSArray arrayWithObjects:@"评论.png","赞.png",@"转发.png", nil];
    
    // 评论  分享   转发
    for(int i = 0; i < 3; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(100+i*70, scrollView.frame.origin.y+scrollView.frame.size.height+10, 20, 20);
        button.tag = 110+i;
        [button addTarget:self action:@selector(zanClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:button];
        
        UILabel *lable = [[UILabel alloc] init];
        lable.frame = CGRectMake(122+i*70, scrollView.frame.origin.y+scrollView.frame.size.height+10, 20, 20);
        lable.tag = 120+i;
        lable.textColor = [UIColor darkGrayColor];
        lable.font = [UIFont systemFontOfSize:14];
        //lable.backgroundColor = [UIColor darkGrayColor];
        [_backView addSubview:lable];
        
        if(i == 0)[button setBackgroundImage:[UIImage imageNamed:@"评论.png"] forState:UIControlStateNormal];
        else if(i == 1)[button setBackgroundImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
        else[button setBackgroundImage:[UIImage imageNamed:@"转发.png"] forState:UIControlStateNormal];
    }
    
    UIImageView *lineImage = [[UIImageView alloc] init];
    lineImage.tag = 106;
    lineImage.image = [UIImage imageNamed:@"line.png"];
    lineImage.frame = CGRectMake(10, nameLable.frame.origin.y+nameLable.frame.size.height+10, 300, 1);
    lineImage.alpha = 0.4;
    [_backView addSubview:lineImage];
    
    // 优惠券介绍
    UILabel *contentLable = [[UILabel alloc] init];
    contentLable.tag = 107;
    contentLable.frame = CGRectMake(20, lineImage.frame.origin.y+11, 280, 20);
    NSString *content = _cou.couDiscription;
    contentLable.numberOfLines = 0;
    UIFont *font = [UIFont systemFontOfSize:15];
    contentLable.font = font;
    contentLable.tag = 108;
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

    contentLable.frame = CGRectMake(20, lineImage.frame.origin.y+11, 280, actualsize.height);
    [_backView addSubview:contentLable];
    
    UIImageView *lineImage2 = [[UIImageView alloc] init];
    lineImage2.image = [UIImage imageNamed:@"line.png"];
    lineImage2.frame = CGRectMake(10, contentLable.frame.origin.y+contentLable.frame.size.height+10, 300, 1);
    lineImage2.alpha = 0.4;
    [_backView addSubview:lineImage2];
    
    // 面值价格
    for (int i = 0; i < 2; i ++)
    {
        UILabel *lable = [[UILabel alloc] init];
        lable.frame = CGRectMake(20, lineImage2.frame.origin.y+30*i+5, 100, 20);
        lable.tag = 130+i;
        lable.font = [UIFont systemFontOfSize:15];
        lable.textColor = [UIColor colorWithRed:0.73f green:0.45f blue:0.17f alpha:1.00f];
        [_backView addSubview:lable];
    }
    
    // 点击领取
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = CGRectMake(220, lineImage2.frame.origin.y+20, 80, 25);
    clickBtn.tag = 107;
    [clickBtn setBackgroundImage:[UIImage imageNamed:@"立即参加.png"] forState:UIControlStateNormal];
    [clickBtn setTitle:@"点击领取" forState:UIControlStateNormal];
    clickBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [clickBtn addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:clickBtn];
    
    UIImageView *lineImage3 = [[UIImageView alloc] init];
    lineImage3.image = [UIImage imageNamed:@"line.png"];
    lineImage3.frame = CGRectMake(10, clickBtn.frame.origin.y + 40, 300, 1);
    lineImage3.alpha = 0.4;
    [_backView addSubview:lineImage3];
    
    // 优惠券说明
    
    UIButton *explainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    explainBtn.tag = 108;
    explainBtn.frame = CGRectMake(20, lineImage3.frame.origin.y+10, 260, 20);
    [explainBtn setTitle:@"优惠券说明" forState:UIControlStateNormal];
    [explainBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [explainBtn setTitleColor:[UIColor colorWithRed:0.73f green:0.45f blue:0.17f alpha:1.00f] forState:UIControlStateNormal];
    explainBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [explainBtn addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:explainBtn];
    
    UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(270, explainBtn.frame.origin.y, 20, 20)];
    rightImage.image = [UIImage imageNamed:@"右边.png"];
    [_backView addSubview:rightImage];
    
    if(_cou.couServices != nil)
    {
        UIImageView *lineImage6 = [[UIImageView alloc] init];
        lineImage6.frame = CGRectMake(10, explainBtn.frame.origin.y+explainBtn.frame.size.height+10, 300, 1);
        lineImage6.image = [UIImage imageNamed:@"line.png"];
        lineImage6.alpha = 0.4;
        [_backView addSubview:lineImage6];
        
        UILabel *serviceLable = [[UILabel alloc] initWithFrame:CGRectMake(20, lineImage6.frame.origin.y+10, 280, 20)];
        serviceLable.tag = 301;
        serviceLable.font = [UIFont systemFontOfSize:12];
        serviceLable.textColor = [UIColor colorWithRed:0.73f green:0.45f blue:0.17f alpha:1.00f];
        [_backView addSubview:serviceLable];
    }
    
    // 头像 评论条
    // 评论条
    UIImageView *headImage2 = [[UIImageView alloc] init];
    headImage2.tag = 95;
    // 必须登录，没有登录就显示默认
    
    UIButton *textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [textBtn addTarget:self action:@selector(zanClick:) forControlEvents:UIControlEventTouchUpInside];
    textBtn.tag = 96;
    [textBtn setBackgroundImage:[UIImage imageNamed:@"输入框.png"] forState:UIControlStateNormal];
    
    if(_cou.couServices != nil)
    {
        headImage2.frame = CGRectMake(10, rightImage.frame.origin.y+80, 40, 40);
        textBtn.frame = CGRectMake(55,rightImage.frame.origin.y+85, 300-55, 30);
    }
    else
    {
        headImage2.frame = CGRectMake(10, rightImage.frame.origin.y+20, 40, 40);
        textBtn.frame = CGRectMake(55,rightImage.frame.origin.y+25, 300-55, 30);
    }
    [_backView addSubview:textBtn];
    [_backView addSubview:headImage2];

    UIImageView *lineImage4 = [[UIImageView alloc] init];
    lineImage4.image = [UIImage imageNamed:@"line.png"];
    if(_cou.couServices != nil)
    {
        lineImage4.frame = CGRectMake(0, explainBtn.frame.origin.y + 70, 320, 1);
    }
    else
    {
        lineImage4.frame = CGRectMake(0, explainBtn.frame.origin.y + 30, 320, 1);
    }
    lineImage4.alpha = 0.4;
    [_backView addSubview:lineImage4];
     _backView.frame = CGRectMake(0, 0, 320, textBtn.frame.origin.y+40);

}
- (void)getValue_zero:(NSIndexPath *)indexPath
{
    
    UIImageView *headImage = (UIImageView *)[_backView viewWithTag:95];
    //
    headImage.image = [UIImage imageNamed:@"头像-男.png"];
    UIButton *textBtn = (UIButton *)[_backView viewWithTag:96];
    [textBtn setTitle:@"请输入评论。" forState:UIControlStateNormal];
    [textBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLable = (UILabel *)[_backView viewWithTag:101];
    titleLable.text = _cou.couName;
    UILabel *timeLable = (UILabel *)[_backView viewWithTag:102];
    timeLable.text = [NSString stringWithFormat:@"有效期:%@-%@",_cou.couStart,_cou.couEnd];
    UILabel *personLable = (UILabel *)[_backView viewWithTag:103];
    personLable.text = [NSString stringWithFormat:@"领取人数:%@",_cou.couGetNum];
    UIScrollView *scrollView = (UIScrollView *)[_backView viewWithTag:104];
    UILabel *serverLable = (UILabel *)[_backView viewWithTag:301];
    serverLable.text = [NSString stringWithFormat:@"使用范围:%@",_cou.couServices];
    for(int i = 0; i < _cou.couPictures.count; i ++)
    {
        UIImageView *pictureImage = (UIImageView *)[scrollView viewWithTag:200+i];
        [pictureImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,[_cou.couPictures objectAtIndex:i]]]];
    }
    
    UILabel *nameLable = (UILabel *)[_backView viewWithTag:105];
    nameLable.text = _cou.couMerchant;
    UILabel *contentLable = (UILabel *)[_backView viewWithTag:108];
    contentLable.text = _cou.couDiscription;
    for(int i = 0; i < 2; i ++)
    {
        UILabel *lable = (UILabel *)[_backView viewWithTag:130+i];
        if(i == 0)
            lable.text = [NSString stringWithFormat:@"面值:%@",_cou.couFace_Value];
        else
            lable.text = [NSString stringWithFormat:@"价格:%@",_cou.couPrice];
    }
    
    NSArray *lables = [NSArray arrayWithObjects:_cou.couCommentNum,_cou.couShareNum,_cou.couForwardNum, nil];
    for(int i = 0; i < lables.count; i ++)
    {
        UILabel *lable = (UILabel *)[_backView viewWithTag:120+i];
        lable.text = [lables objectAtIndex:i];
    }
}

#pragma mark - 创建评论
- (void)createSection_one:(UITableViewCell *)cell
{
    UIImageView *lineImage = [[UIImageView alloc] init];
    lineImage.frame = CGRectMake(20, 0, 280, 1);
    lineImage.image = [UIImage imageNamed:@"line.png"];
    lineImage.alpha = 0.4;
    [cell.contentView addSubview:lineImage];
    
    // 头像
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    headImage.tag = 151;
    [cell.contentView addSubview:headImage];
    
    // 名字
    UILabel *nameLable = [[UILabel alloc] init];
    nameLable.frame = CGRectMake(60, 10, 100, 20);
    nameLable.font = [UIFont systemFontOfSize:15];
    nameLable.textColor = [UIColor darkGrayColor];
    nameLable.tag = 152;
    [cell.contentView addSubview:nameLable];
    
    // 时间
    UILabel *timeLable = [[UILabel alloc] init];
    timeLable.frame = CGRectMake(320-70, 10, 90, 20);
    //timeLable.text  =[[_neiInfo.neiInfoComments objectAtIndex:indexPath.row] neiInfoSend_Time];
    timeLable.font = [UIFont systemFontOfSize:12];
    nameLable.textColor = [UIColor colorWithRed:0.68f green:0.69f blue:0.72f alpha:1.00f];
    timeLable.tag = 153;
    [cell.contentView addSubview:timeLable];
    
    // 评论内容
    UILabel *contentLable = [[UILabel alloc] init];
    contentLable.frame = CGRectMake(60, 35, 320-70, 20);
    NSString *content = nil;
    contentLable.numberOfLines = 0;
    contentLable.tag = 154;
    UIFont *font = [UIFont systemFontOfSize:13];
    contentLable.font = font;
    contentLable.textColor = [UIColor darkGrayColor];
    contentLable.lineBreakMode = NSLineBreakByTruncatingTail;
    [cell.contentView addSubview:contentLable];
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

    contentLable.frame = CGRectMake(60, 35, 250, actualsize.height+25);
}
- (void)getValue_one:(NSIndexPath *)indexPath andTabelViewCell:(UITableViewCell *)cell
{
    User *user = [_cou.couUsers objectAtIndex:indexPath.row];
    Comment *comm = [_cou.couComments objectAtIndex:indexPath.row];
    UIImageView *headImage = (UIImageView *)[cell.contentView viewWithTag:151];
    [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,user.userFace]]];
    
    UILabel *nameLable = (UILabel *)[cell.contentView viewWithTag:152];
    nameLable.text = user.userName;
    UILabel *timeLable = (UILabel *)[cell.contentView viewWithTag:153];
    timeLable.text = comm.commSendTime;
    UILabel *contentLable = (UILabel *)[cell.contentView viewWithTag:154];
    contentLable.text = comm.commContent;

    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClick
{
    // 点击评论
    CommentViewController *comment = [[CommentViewController alloc] init];
    comment.pid = self.did;
    comment.mid = @"3";
    [self.navigationController pushViewController:comment animated:YES];
}

- (void)bbiItem:(UIButton *)bbi
{
    if(bbi.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(bbi.tag == 107)
    {
        DisCountOrderViewController *dis = [[DisCountOrderViewController alloc] init];
        Discount *disCout = [[Discount alloc] init];
        disCout.disName = _cou.couName;
        disCout.disPrice = _cou.couPrice;
        disCout.disId = self.did;
        dis.discountOrderArray = [[NSMutableArray alloc] init];
        [dis.discountOrderArray addObject:disCout];
        [self.navigationController pushViewController:dis animated:YES];
    }
}
- (void)zanClick:(UIButton *)button
{
    if(button.tag == 111)
    {
        // 分享
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
