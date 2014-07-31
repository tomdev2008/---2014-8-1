//
//  ServerOrdersViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-4.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "ServerOrdersViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "ServerOrderViewController.h"
#import "MoreServerViewController.h"
#import "DownLoadManager.h"
#import "MyServerViewController.h"
#import "RegiestViewController.h"

@interface ServerOrdersViewController ()

@end

@implementation ServerOrdersViewController
{
    AppDelegate *_app;
    UIView *_OkView;
    UITextView *_textView;
    DownLoadManager *_dm;
    int _RECODE;
    RegiestViewController *_regiest;
    UIControl *_control;
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
    _OkView.hidden = YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    _scrollView.frame = CGRectMake(0, 44, 320, 480);
    _scrollView.contentSize = CGSizeMake(320, 600);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dm = [DownLoadManager shareDownLoadManager];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"服务订单" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    
    [self.view addSubview:mnb];
    
    _control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    _control.hidden = YES;
    _control.tag = 220;
    [_control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_control];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(_btnDate.frame.origin.x,_messageContent.frame.origin.y+_messageContent.frame.size.height+15 ,_btnDate.frame.size.width, 80)];
    _textView.delegate = self;
    [_textView sendSubviewToBack:_datePickeer];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _btnDate.frame.size.width, 80)];
    imgView.image = [UIImage imageNamed:@"发布邻居说背景.png"];
    [_textView addSubview: imgView];
    [_textView sendSubviewToBack: imgView];
    [_backView addSubview:_textView];
    
    [_dm getCommuityServerTimeWithCid:_dm.communityId];
    __block ServerOrdersViewController *blockSelf = self;
    [_dm setCommuityServerTimeBlock:^{
      blockSelf -> _serverTimer.text = [NSString stringWithFormat:@"预约时间：%@",blockSelf -> _dm.serverTime];
    }];
    
    _datePickerView.hidden = YES;
    
    _regiest = [[RegiestViewController alloc] init];
    [_regiest setAddressBlock:^(NSString *address, NSString *date, NSString *time, NSString *commId) {
        [blockSelf -> _btnAddress setTitle:address forState:UIControlStateNormal];
        [blockSelf -> _btnDate setTitle:date forState:UIControlStateNormal];
        [blockSelf -> _btnTime setTitle:time forState:UIControlStateNormal];
        blockSelf -> _rid = commId;
    }];
    
    [self createMessage];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(320-60, 5, 60, 30);
    button.tag = 101;   //
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
    [self.datePickerView addSubview:button];
    
}

// 点击确定
- (void)okClick
{
    NSLog(@"okc");
    NSDate *select  = [_datePickeer date];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(self.datePickeer.tag == 1)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [_btnDate setTitle:[dateFormatter stringFromDate:select] forState:UIControlStateNormal];
        _regiest.date = [dateFormatter stringFromDate:select];
        
    }
    else
    {
        [dateFormatter setDateFormat:@"HH:mm"];
        [_btnTime setTitle:[dateFormatter stringFromDate:select] forState:UIControlStateNormal];
        _regiest.time = [dateFormatter stringFromDate:select];
    }

    self.datePickerView.hidden = YES;

}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _control.hidden = NO;
    [UIView animateWithDuration:0.27 animations:^{
        _scrollView.frame = CGRectMake(0, -140, 320, 480);
    }];
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"1123123123");
}
- (void)controlClick
{
    NSLog(@"123");
    _control.hidden = YES;
    _control.frame = CGRectMake(0, 0, 320, 300);
    self.datePickerView.hidden = YES;
    [UIView animateWithDuration:0.27 animations:^{
        _scrollView.frame = CGRectMake(0, 44, 320, 480);
    }];
    [_textView resignFirstResponder];
}

- (void)createMessage
{
    
    _OkView = [[UIView alloc] init];
    _OkView.hidden = YES;
    _OkView.frame = CGRectMake(0, 64, 320, 548);
    _OkView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:0.70f];
    [self.view addSubview:_OkView];
    
    UIImageView *backView = [[UIImageView alloc] init];
    backView.frame = CGRectMake(50, 150, 220, 110);
    backView.userInteractionEnabled = YES;
    backView.image = [UIImage imageNamed:@"注册成功_03.png"];
    backView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [_OkView addSubview:backView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 5, 200, 70);
    label.numberOfLines = 0;
    NSString *serverOrder_code = _dm.serverOrder_Code;
    label.text =[NSString stringWithFormat:@"恭喜你，已经预约成功。预约订单号为  %@  。请在我的-我的服务页面查询订单状态",serverOrder_code];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label];
    
    
    NSArray *array = [NSArray arrayWithObjects:@"查看订单",@"继续逛逛", nil];
    
    for(NSInteger i = 0; i < 2; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10+115*i, 80, 90, 20);
        button.tag = 130+i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
    }
}


- (void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bbiItem:(UIButton *)button
{
    if(button.tag == 130)
    {
        MyServerViewController *serverOrder = [[MyServerViewController alloc] init];
        [self.navigationController pushViewController:serverOrder animated:YES];
    }
    else if(button.tag == 131)
    {
        MoreServerViewController *moreServer = [[MoreServerViewController alloc] init];
        [self.navigationController pushViewController:moreServer animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 日期选择
- (IBAction)dateClick:(id)sender
{
    _datePickerView.hidden = NO;
    _datePickeer.tag = 1;
    _RECODE = 0;
    _hideBtn.hidden = NO;
    _control.hidden = NO;
    _control.frame = CGRectMake(0, 220, 320, 200);
    _datePickeer.datePickerMode = UIDatePickerModeDate;
}

// 时间选择
- (IBAction)timeClick:(id)sender
{
    _datePickerView.hidden = NO;
    _datePickeer.tag = 2;
    _RECODE = 1;
    _hideBtn.hidden = NO;
    _control.hidden = NO;
    _control.frame = CGRectMake(0, 220, 320, 200);
    _datePickeer.datePickerMode = UIDatePickerModeTime;

}

// 选择地址
- (IBAction)addressClick:(id)sender
{
    _regiest.count = 0; // 地址
    [self.navigationController pushViewController:_regiest animated:YES];
}


- (IBAction)datePickerClick:(id)sender
{
//    UIDatePicker *datePicker = sender;
//    NSDate *select  = [datePicker date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    if(_RECODE == 1)
//    {
//        [dateFormatter setDateFormat:@"HH:mm"];
//        [_btnTime setTitle:[dateFormatter stringFromDate:select] forState:UIControlStateNormal];
//        _regiest.time = [dateFormatter stringFromDate:select];
//    }
//    else
//    {
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        [_btnDate setTitle:[dateFormatter stringFromDate:select] forState:UIControlStateNormal];
//        _regiest.date = [dateFormatter stringFromDate:select];
//    }
}

// 点击呼叫服务
- (IBAction)serverOrderClick:(id)sender
{
    if([_btnDate.titleLabel.text isEqualToString:@""] || [_btnTime.titleLabel.text isEqualToString:@""] || [_btnAddress.titleLabel.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请把信息填写完整" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSString *date = [NSString stringWithFormat:@"%@ %@",_btnDate.titleLabel.text,_btnTime.titleLabel.text];
        [_dm sendServerWithSid:_sid andDtime:date andContent:_textView.text andRid:[_rid intValue]];
        __block ServerOrdersViewController *blockSelf = self;
        [_dm setSendServerSuccessBlock:^{
            [blockSelf createMessage];
            blockSelf -> _OkView.hidden = NO;
        }];
    }
}
@end
