//
//  InvoiceViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-8.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "InvoiceViewController.h"
#import "DownLoadManager.h"
#import "AppDelegate.h"
#import "MyNavigationBar.h"

@interface InvoiceViewController ()

@end

@implementation InvoiceViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     self.hidesBottomBarWhenPushed = YES;   // Custom initialization
    }
    return self;
}

- (void)createNavigation
{
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"填写订单" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigation];
    [self createPersonAndBussnise];
}

- (void)createPersonAndBussnise
{
    for(int i = 0; i < 2; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(120+80*i, 80, 20, 20);
        [button setBackgroundImage:[UIImage imageNamed:@"radio_no.png"] forState:UIControlStateNormal];
        button.tag = 10+i;
        [button addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        UILabel *lable = [[UILabel alloc] init];
        lable.frame = CGRectMake(145+80*i, 80, 50, 20);
        lable.font = [UIFont systemFontOfSize:15];
        lable.textColor = [UIColor darkGrayColor];
        if(i == 0)lable.text = @"个人";
        else lable.text = @"单位";
        [self.view addSubview:lable];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bbiItem:(UIButton *)button
{
    if(!button.selected)
    {
        for(UIButton *btn in button.superview.subviews)
        {
            if([btn isKindOfClass:[UIButton class]])
            {
                btn.selected = NO;
            }
            else
            {
                continue;
            }
        }
        button.selected = YES;
        [button setTitleColor:[UIColor colorWithRed:0.05f green:0.64f blue:0.49f alpha:1.00f] forState: UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"radio_yes.png"] forState:UIControlStateSelected];
    }
    else
    {
        button.selected = NO;
    }
}

- (void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    _app = [UIApplication sharedApplication].delegate;
    _app.mtb.hidden  =YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    _app.mtb.hidden = NO;
}


- (IBAction)yesClick:(id)sender
{
    NSLog(@"%@",_nameText.text);
    if([self.delegate respondsToSelector:@selector(changeAddressAndInvoiceInfoWithName:)])
    {
        [self.delegate changeAddressAndInvoiceInfoWithName:_nameText.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
