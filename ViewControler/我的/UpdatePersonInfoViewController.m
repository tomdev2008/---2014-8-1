//
//  UpdatePersonInfoViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-9.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "UpdatePersonInfoViewController.h"
#import "AppDelegate.h"
#import "MyNavigationBar.h"
#import "DownLoadManager.h"

@interface UpdatePersonInfoViewController ()

@end

@implementation UpdatePersonInfoViewController
{
    AppDelegate *_app;
    UISegmentedControl *_segmentedControl;
    UITextField *_text;
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
    // Do any additional setup after loading the view from its nib.
    self.tabBarController.tabBar.hidden = YES;
    // 初始化
    
    _dm = [DownLoadManager shareDownLoadManager];
    
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"个人资料" andLeftButtonImage:@"back.png" andRightButtonImage:@"提交.png" andSEL:@selector(btnClick:) andClass:self];
    [self.view addSubview:mnb];
    
    NSArray *arrays = [NSArray arrayWithObjects:@"男",@"女", nil];
    CGRect labelRect = CGRectMake(10, 64+20, 100, 20);
    
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    
    CGRect fillRect = CGRectMake(80, 64+15, 200, 30);
    _text = [[UITextField alloc] initWithFrame:fillRect];
    _text.clearButtonMode = UITextFieldViewModeAlways;
    [_text setBorderStyle:UITextBorderStyleRoundedRect];
    _text.delegate = self;
    [self.view addSubview:_text];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:arrays];
    _segmentedControl.frame = CGRectMake(80, 64+15, 200, 30);
    _segmentedControl.selectedSegmentIndex = 1;
    _segmentedControl.segmentedControlStyle =   UISegmentedControlStyleBar;
    _segmentedControl.hidden = YES;
    _segmentedControl.tintColor = [UIColor colorWithRed:0.12f green:0.63f blue:0.49f alpha:1.00f];
    [self.view addSubview:_segmentedControl];
    
    switch (_tagNumber)
    {
        case 0:
            label.text = @"昵称：";
            break;
        case 1:
            label.text = @"性别：";
            _text.hidden = YES;
            _segmentedControl.hidden = NO;
            break;
        case 2:
            label.text = @"职业：";
            break;
        case 3:
            label.text = @"小区：";
            break;
        case 4:
            label.text = @"收货地址：";
            break;
        case 5:
            label.text = @"真是姓名：";
            break;
        case 6:
            label.text = @"手机号码：";
            break;
        case 7:
            label.text = @"群名称";
        default:
            break;
    }
}
- (void)segClick:(UISegmentedControl *)seg
{
    
}
- (void)btnClick:(UIButton *)button
{
    if(button.tag == 1)
    {
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if(button.tag == 2)
    {
        if([_text.text isEqualToString:@""] && _tagNumber != 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            switch (_tagNumber)
            {
                case 0: // 昵称
                    [_dm updatePersonInfoWithfield:@"name" andValue:_text.text];
                    break;
                case 1: // 性别
                    [_dm updatePersonInfoWithfield:@"sex" andValue:[NSString stringWithFormat:@"%d",_segmentedControl.selectedSegmentIndex]];
                    break;
                case 2: // 职业
                    [_dm updatePersonInfoWithfield:@"profession" andValue:_text.text];
                    break;
                case 4: // 收货地址
                    [_dm updatePersonInfoWithfield:@"address" andValue:_text.text];
                    break;
                case 5: // 真实姓名
                    [_dm updatePersonInfoWithfield:@"realname" andValue:_text.text];
                    break;
                case 7: // 群名称
                    [_dm groupNameUpdate:self.gid andName:_text.text];
                    [_dm setSendMessageSuccess:^{
                        
                    }];
                    break;
            }
            if(_tagNumber != 7)
            {
                __block UpdatePersonInfoViewController *blockSelf = self;
                [_dm setUpdatePersonInfoSuccessBlock:^{
                    [blockSelf.navigationController popViewControllerAnimated:NO];
                }];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    }];
    return [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
