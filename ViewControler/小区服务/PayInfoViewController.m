//
//  PayInfoViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-30.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "PayInfoViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "PaySelectViewController.h"
#import "DownLoadManager.h"

@interface PayInfoViewController ()

@end

@implementation PayInfoViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
    NSMutableArray *_dataArray;
    int _btnTag;
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
- (void)getData
{
    _dataArray = [[NSMutableArray alloc] init];
    _dm = [DownLoadManager shareDownLoadManager];
    __block PayInfoViewController *blockSelf = self;
    [_dm getRealPayWith:self.rid];
    [_dm setRealPayBlock:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf createContentWithArry:blockSelf -> _dataArray];
    }];
    
}

- (void)createContentWithArry:(NSArray *)array
{
    UIScrollView *backScrollView = [[UIScrollView alloc] init];
    backScrollView.frame = CGRectMake(0, 220, 320, 80);
    backScrollView.contentSize = CGSizeMake(320, array.count*20);
    backScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:backScrollView];
    NSInteger count = 0;
    for(NSInteger i = 0; i < array.count/2+array.count%2; i ++)
    {
        for(NSInteger j = 0; j < 2; j ++)
        {
            if(count < array.count)
            {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(30+150*i, 10+50*j, 20, 20);
                [button setBackgroundImage:[UIImage imageNamed:@"radio_no.png"] forState:UIControlStateNormal];
                button.tag = 400+count;
                [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [backScrollView addSubview:button];
                
                UILabel *label = [[UILabel alloc] init];
                label.frame = CGRectMake(60+150*i, 10+50*j, 100, 20);
                label.text = [[array objectAtIndex:count] proName];
                label.textColor = [UIColor darkGrayColor];
                label.font = [UIFont systemFontOfSize:14];
                [backScrollView addSubview:label];
            }
            else
            {
                continue;
            }
            count ++;
        }
    }
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(320-120, 320, 80, 30);
    [submitButton setTitle:@"立即支付" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"立即参加.png"] forState:UIControlStateNormal];
    submitButton.tag = 101;
    [submitButton addTarget:self action:@selector(zhifuClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getData];
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"自助缴费" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
    
    [_unitRoomBtn setTitle:_unitRommStr forState:UIControlStateNormal];
}


// 注册完成动画
- (void)finishRegiest
{
    // 遮罩层
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320,568-64)];
    backView.backgroundColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:0.70f];
    [self.view addSubview:backView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"注册成功_03.png"]];
    imageView.frame = CGRectMake(backView.frame.size.width/2, 80, 0, 0);
    imageView.userInteractionEnabled = YES;
    
    UIButton *buttonOK = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonOK.frame = CGRectMake(0, 0, 0, 0);
    [buttonOK setTitle:@"确 定" forState:UIControlStateNormal];
    [buttonOK setTitleColor:[UIColor colorWithRed:0.32f green:0.73f blue:0.62f alpha:1.00f] forState:UIControlStateNormal];
    buttonOK.tag = 103;
    [buttonOK addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:buttonOK];
    
    UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCancel.frame = CGRectMake(0, 0, 0, 0);
    [buttonCancel setTitle:@"取 消" forState:UIControlStateNormal];
    [buttonCancel setTitleColor:[UIColor colorWithRed:0.32f green:0.73f blue:0.62f alpha:1.00f] forState:UIControlStateNormal];
    buttonCancel.tag = 104;
    [buttonCancel addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:buttonCancel];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 0, 0);
    label.text = [NSString stringWithFormat:@"您所缴纳的物业费是 %@。",[_timeLabel text]];
    [label setNumberOfLines:2];
    label.textColor = [UIColor colorWithRed:0.73f green:0.45f blue:0.17f alpha:1.00f];
    [imageView addSubview:label];
    
    
    // 弹出
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame = CGRectMake((backView.frame.size.width-250)/2, 80, 250, 106);
        [backView addSubview:imageView];
        buttonOK.frame = CGRectMake(40, 70, 53, 30);
        buttonCancel.frame = CGRectMake(160,70, 53, 30);
        label.frame = CGRectMake(10, 5, 230, 70);
    }];
}

- (void)btnClick:(UIButton *)button
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
    _btnTag = button.tag-400;
}

- (void)bbiItem:(UIButton *)button
{
    
    switch(button.tag)
    {
        case 1: // 跳转
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 103:   //  点击确定
        {
            PaySelectViewController *paySelect = [[PaySelectViewController alloc] init];
            [self.navigationController pushViewController:paySelect animated:YES];
            // 隐藏弹出来的提示框.
            ((UIView *)[self.view.subviews lastObject]).hidden = YES;
            break;
        }
        case 104:   //  点击取消
            break;
    }
}

- (void)zhifuClick:(UIButton *)button
{
    Property *pro = [_dataArray objectAtIndex:_btnTag];
    NSString *str = [NSString stringWithFormat:@"您所缴的物业费的时间是:%@到%@",pro.proStart,pro.proEnd];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    
    __block PayInfoViewController *blockSelf = self;
    [_dm getRealPaySubmitWithRid:[NSString stringWithFormat:@"%d",self.rid] andPrice:pro.proPrice andStart:pro.proStart andEnd:pro.proEnd];
    [_dm setRealPaySubmitBlock:^(Order *order) {
        [alertView show];
        blockSelf.code = order.orderCode;
        blockSelf.money = order.orderMoney;
        blockSelf.sign = order.sign;
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        PaySelectViewController *paySelect = [[PaySelectViewController alloc] init];
        paySelect.code = self.code;
        paySelect.price = self.money;
        paySelect.sign = self.sign;
        [self.navigationController pushViewController:paySelect animated:YES];
    }
    else
    {
        NSLog(@"点击了取消");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
