//
//  ApplyViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-7.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "ApplyViewController.h"
#import "AppDelegate.h"
#import "DownLoadManager.h"
#import "MyNavigationBar.h"

@interface ApplyViewController ()

@end

@implementation ApplyViewController
{
    DownLoadManager *_dm;
    AppDelegate *_app;
    LoadingView *_loadingView;
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

- (void)createNavigation
{
    _dm = [DownLoadManager shareDownLoadManager];
    
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"报名" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
    
    if(is_IPHONE_6)
    {
        _backView.frame = CGRectMake(10, 70, 300, 200);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigation];
    [self setDelegateWithText];
    
    UIControl *control = [[UIControl alloc] initWithFrame:self.hideView.bounds];
    [control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    [self.hideView addSubview:control];
    
}

- (void)controlClick
{
    [_nameText resignFirstResponder];
    [_phoneText resignFirstResponder];
    [_addressText resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_nameText resignFirstResponder];
    [_phoneText resignFirstResponder];
    [_addressText resignFirstResponder];

}

- (void)setDelegateWithText
{
    _nameText.delegate = self;
    _phoneText.delegate = self;
    _addressText.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)bbiItem:(UIButton *)bbi
{
    if(bbi.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)isTextNull
{
    if([_nameText.text isEqualToString:@""] || [_phoneText.text isEqualToString:@""] || [_addressText.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请把信息填写完整" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    else
    {
        [_dm joinActivityWithAid:self.aid andName:_nameText.text andPhone:_phoneText.text andRid:_addressText.text];
        [_dm setJoinSuccessBlock:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"参加成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}

// 点击确定
- (IBAction)joinClick:(id)sender
{
    [self isTextNull];
}
@end
