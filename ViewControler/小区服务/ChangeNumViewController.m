//
//  ChangeNumViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-14.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "ChangeNumViewController.h"
#import "DownLoadManager.h"
#import "AppDelegate.h"
#import "MyNavigationBar.h"
#import "ZL_INTERFACE.h"
#import "ChangeNumCell.h"

@interface ChangeNumViewController ()

@end

@implementation ChangeNumViewController
{
    DownLoadManager *_dm;
    AppDelegate *_app;
    UITableView *_tableView;
    int count;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)createNavigation
{
    _dm = [DownLoadManager shareDownLoadManager];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"填写订单" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick:) andClass:self];
    [self.view addSubview:mnb];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self createTableView];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, is_IPHONE_6?44:64, 320, isRetina.size.height>480?568-64:480-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    ChangeNumCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChangeNumCell" owner:self options:nil] lastObject];
    }
    
    [cell.serTitlePic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,self.server.serTitlePic]]];
    cell.serName.text = self.server.serName;
    cell.serPrice.text = self.server.serPrice;
    NSArray *array = [NSArray arrayWithObjects:@"creduce.png",@"cplus.png", nil];
    for(int i = 0 ; i < 2; i ++)
    {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(150+80*i, 64, 25, 25);
        [button setBackgroundImage:[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(bbiClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
    }
    
    return cell;
}
- (void)bbiClick:(UIButton *)button
{
    UILabel *indexLable = (UILabel *)[button.superview viewWithTag:99];
    NSRange range = NSRangeFromString(indexLable.text);
    ChangeNumCell *cell = (ChangeNumCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:range.length inSection:range.location]];
    count = [cell.serCount.text intValue];
    if(button.tag == 101)
    {
        count ++;
        
    }
    else
    {
        if(count <= 0)
        {
            return;
        }
        else
            count -- ;
        
    }
    cell.serCount.text = [NSString stringWithFormat:@"%d",count];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)btnClick:(UIButton *)button
{
    if(button.tag == 1)
    {
        if([self.delegate respondsToSelector:@selector(changePrice:)])
        {
            [self.delegate changePrice:[NSString stringWithFormat:@"%d",count * [self.server.serPrice intValue]]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        
        
    }
}

@end
