//
//  BlackListViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-10.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "BlackListViewController.h"
#import "DownLoadManager.h"
#import "AppDelegate.h"
#import "MyNavigationBar.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"

@interface BlackListViewController ()

@end

@implementation BlackListViewController
{
    DownLoadManager *_dm;
    AppDelegate *_app;
    NSMutableArray *_dataArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)createNavigation
{
    [self createData];
    
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"邻居说黑名单" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
}

- (void)createData
{
    _dm = [DownLoadManager shareDownLoadManager];
    _dataArray = [[NSMutableArray alloc] init];
    __block BlackListViewController *blockSelf = self;
    if(self.type == 0)
        [_dm getShieldListWithType:0];  // 获取邻居说
    else
        [_dm getShieldListWithType:1];
    [_dm setShieldListBlock:^(NSArray *array) {
            [blockSelf -> _dataArray addObjectsFromArray:array];
            [blockSelf createContentWithArray:array];
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
}


- (void)createContentWithArray:(NSArray *)array
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.00f];
    backView.frame = CGRectMake(10, is_IPHONE_6?54:74, 300, 130);
    [self.view addSubview:backView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, 300, 90)];
    scrollView.contentSize = CGSizeMake(array.count+2*75, 90);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = YES;
    [backView addSubview:scrollView];
    
    for (int i = 0; i < array.count; i ++)
    {
        User *user = [array objectAtIndex:i];
        UIImageView *headImage = [[UIImageView alloc] init];
        headImage.frame = CGRectMake(10+75*i, 0, 70, 70);
        [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,user.userFace]]];
        [scrollView addSubview:headImage];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(10+75*i, 73, 70, 15);
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.text = user.userName;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:nameLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(50+75*i, 0, 30, 30);
        [button setBackgroundImage:[UIImage imageNamed:@"解除"] forState:UIControlStateNormal];
        button.tag = 20+i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 150, 200, 20);
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor darkGrayColor];
    label.text = @"不看他的邻居说";
    [backView addSubview:label];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)btnClick:(UIButton *)button
{
    
        
    User *user = [_dataArray objectAtIndex:button.tag-20];
    __block BlackListViewController *blockSelf = self;
    [_dm delShieldWithUid:user.userId];
    [_dm setSendMessageSuccess:^{
        // 解除邻居说屏蔽成功
        if(blockSelf -> _dataArray.count == 1)
        {
            [blockSelf.navigationController popViewControllerAnimated:YES];
        }
        [blockSelf createData];
        
        NSLog(@"解除成功");
    }];
    
}
- (void)btnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
