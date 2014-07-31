//
//  CommentsViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-4.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "CommentsViewController.h"
#import "AppDelegate.h"
#import "MyNavigationBar.h"
#import "ZL_CONST.h"

@interface CommentsViewController ()

@end

@implementation CommentsViewController
{
    AppDelegate *_app;
    UITableView *_tableView;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"评论列表" andLeftButtonImage:@"back.png" andRightButtonImage:@"发布邻居说.png" andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    
    [self createTabelView];
}
- (void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTabelView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44:64, 320, isRetina.size.height>480?548-44:480-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        //cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.text = @"暂无评价";
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
