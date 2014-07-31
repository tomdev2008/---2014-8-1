//
//  MessageViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-28.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "MessageViewController.h"
#import "MyNavigationBar.h"
#import "SendMessageViewController.h"
#import "DownLoadManager.h"
#import "ZL_INTERFACE.h"
#import "ZL_CONST.h"
#import "MessageCell.h"
#import "LoginViewController.h"
#import "Login_480_ViewController.h"
#import "NeighborViewController.h"
#import "AddressBookViewController.h"
#import "AppDelegate.h"
#import "Login_480_ViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController
{
    DownLoadManager *_dm;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    LoadingView *_loadingView;
    AppDelegate *_app;
    NSIndexPath *_indexPath;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.hidesBottomBarWhenPushed = YES;  // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    _dm = [DownLoadManager shareDownLoadManager];
    _app = [UIApplication sharedApplication].delegate;
    if(_dm.myUserId == nil)
    {
        if(isRetina.size.height > 480)
        {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:NO];
        }
        else
        {
            Login_480_ViewController *login = [[Login_480_ViewController alloc] init];
            [self.navigationController pushViewController:login animated:NO];
        }
    }
    else if(_dm.myUserId != nil)
    {
        _dataArray = [[NSMutableArray alloc] init];
        [self getTalkList];
    }
    if([_dm.status isEqualToString:@"400"])
    {
        [_loadingView loadingViewDispear:0.0];
    }
}

//
- (void)getTalkList
{
    [self createLoadView];
    __block MessageViewController *blockSelf = self;
    [_dm getTalkList];
    [_dm setTalkListBlock:^(NSArray *array) {
        [blockSelf -> _dataArray removeAllObjects];
        [blockSelf-> _dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
        [blockSelf -> _loadingView loadingViewDispear:0];
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"消息" andLeftButtonImage:@"发布邻居说.png" andRightButtonImage:nil andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
    [self createTabelView];
}

- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake(0,is_IPHONE_6?44:64,320,isRetina.size.height>480?568:480);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingBackView:YES andAlpha:1.0];
}

- (void)createTabelView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44:64, 320, isRetina.size.height>480?568-64-49:480-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 1.0;
    [_tableView addGestureRecognizer:longPress];
    
    [self.view addSubview:_tableView];
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
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(_dataArray.count > 0)
    {
        Message *message = [_dataArray objectAtIndex:indexPath.row];
        [cell.headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,message.userFace]]];
        cell.nameLable.text = message.userName;
        cell.timeLable.text = message.msgSend_Time;
        //cell.contentLable.text = message.msgContent;
        TQRichTextView *richTextView = [[TQRichTextView alloc] init];
        richTextView.backgroundColor = [UIColor clearColor];
        richTextView.textColor = [UIColor darkGrayColor];
        richTextView.frame = CGRectMake(0, 0, cell.contentLable.frame.size.width+10, cell.contentLable.frame.size.height+26);
        if(message.msgContent.length == 16)
        {
            message.msgContent = [message.msgContent substringToIndex:12];
        }
        NSLog(@"%d",message.msgContent.length);
        richTextView.text = message.msgContent;
        
        [cell.contentLable addSubview:richTextView];
    }
    else
    {
        cell.contentLable.text = @"没有可读消息";
        [_tableView reloadData];
    }
    
    
    return cell;
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [longPress locationInView:_tableView];
        _indexPath = [_tableView indexPathForRowAtPoint:point];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"置顶",@"删除",@"屏蔽", nil];
        alertView.tag = 1000;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1000)
    {
        Message *message = [_dataArray objectAtIndex:_indexPath.row];
        __block MessageViewController *blockSelf = self;
        if(buttonIndex == 1 || buttonIndex == 2)
        {
            [_dm toTopMessageWithLid:message.msgId andType:buttonIndex-1];
            [_dm setSendMessageSuccess:^{
                NSLog(@"点击了置顶");
                [blockSelf getTalkList];
            }];
        }
        else if(buttonIndex == 3)   // 屏蔽
        {
            [_dm shieldUserWithUid:[[message msgId] intValue] andType:1 andStyle:[message.msgType intValue]];
            [_dm setSendMessageSuccess:^{
                NSLog(@"点击了屏蔽");
                [blockSelf getTalkList];
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SendMessageViewController *send = [[SendMessageViewController alloc] init];
    Message *message = [_dataArray objectAtIndex:indexPath.row];
    send.name = message.userName;
    send.userId = message.userId;
    send.userFace = message.userFace;
    if([message.msgStyle isEqualToString:@"0"])
    {
        send.speakType = 0; // 单聊
    }
    else
    {
        send.speakType = 1; // 多人聊
        _dm.groupId = message.userId;
    }
    [self.navigationController pushViewController:send animated:YES];
}

- (void)bbiItem:(UIBarButtonItem *)bbi
{
    if(bbi.tag == 1)
    {
        AddressBookViewController *addressBook = [[AddressBookViewController alloc] init];
        addressBook.comeType = 0;   
        [self.navigationController pushViewController:addressBook animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
