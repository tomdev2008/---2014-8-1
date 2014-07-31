//
//  DisCountOrderViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-19.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "DisCountOrderViewController.h"
#import "AppDelegate.h"
#import "MyNavigationBar.h"
#import "Discount.h"
#import "DownLoadManager.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"

#import "AlixPayResult.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "AlixLibService.h"
#import "PartnerConfig.h"
#import "PaySelectViewController.h"

@interface DisCountOrderViewController ()

@end

@implementation DisCountOrderViewController
{
    AppDelegate *_app;
    int _num;
    float _price;
    DownLoadManager *_dm;
    Order *_order;
    float totalPrice;
    
    // 积分
    float yingPrice;
    int point;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.hidesBottomBarWhenPushed = YES;  // Custom initialization
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

- (void)getTotalPrice
{
    yingPrice = totalPrice - point;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"提交订单" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    
    self.backView.layer.borderColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f].CGColor;
    self.backView.layer.borderWidth = 1;
    self.backView.frame = CGRectMake(0, is_IPHONE_6?44:64, 320, 331);
    [_dm getMyPointInfo];
    [_dm setMyPointINfoBlock:^(User *user) {
        _pointLable.text = [NSString stringWithFormat:@"你有%@积分，每分抵扣1元，本次使用",user.userTotal];
    }];
    _textJifen.delegate = self;
    _textJifen.keyboardType = UIKeyboardTypeNumberPad;
    //_textJifen.keyboardType = UIReturnKeyDone;
    Discount *cou = [self.discountOrderArray objectAtIndex:0];
    _titleLabel.text = cou.disName;
    self.did = cou.disId;
    _priceLabel.text = [NSString stringWithFormat:@"￥：%@",cou.disPrice];
    _price = [cou.disPrice floatValue];
    _numLabel.text = @"1";
    _num = [_numLabel.text intValue];
    _totalPriceLabel.text = [NSString stringWithFormat:@"￥：%d",[cou.disPrice intValue] * [_numLabel.text intValue]];
    NSLog(@"%d",[_numLabel.text intValue]*[cou.disPrice intValue]);
    totalPrice = [_numLabel.text intValue]*[cou.disPrice intValue];
    [self getTotalPrice];
    _yingLabel.text = [NSString stringWithFormat:@"￥：%.2f",yingPrice];

}

- (void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    point = [textField.text intValue];
    _diLabel.text = [NSString stringWithFormat:@"￥：%@",[_textJifen text]];
    [self getTotalPrice];
    _yingLabel.text = [NSString stringWithFormat:@"%.2f",yingPrice];
    return  [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if([_textJifen.text intValue] > yingPrice )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的积分大于所购买的价格" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if([_yingLabel.text intValue] < 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"总价小于0" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    else
    {
        point = [_textJifen.text intValue];
        [self getTotalPrice];
        _yingLabel.text = [NSString stringWithFormat:@"￥：%.2f",yingPrice];
    }
    [_textJifen resignFirstResponder];
}

- (IBAction)plusClick:(id)sender
{
    _num ++;
    _numLabel.text = [NSString stringWithFormat:@"%d",_num];
    _totalPriceLabel.text = [NSString stringWithFormat:@"￥：%.2f",_num * _price];
    totalPrice = _num * _price;
    [self getTotalPrice];
    _yingLabel.text = [NSString stringWithFormat:@"￥：%.2f",yingPrice];
}

- (IBAction)reduceClick:(id)sender
{
    if(_num <= 1)
    {
        return;
    }
    else
    {
        _num --;
        _numLabel.text = [NSString stringWithFormat:@"%d",_num];
        _totalPriceLabel.text = [NSString stringWithFormat:@"￥：%.2f",_num * _price];
        totalPrice = _num * _price;
        [self getTotalPrice];
        _yingLabel.text = [NSString stringWithFormat:@"￥：%.2f",yingPrice];
    }
}

- (IBAction)orderClic:(id)sender
{

    _dm = [DownLoadManager shareDownLoadManager];
    __block DisCountOrderViewController *blockSelf = self;
    [_dm getCouponWithCid:self.did andNum:_num andOff:[_textJifen.text intValue] andUid:_dm.myUserId];
    [_dm setGetCouponBlock:^(Order *order){
        PaySelectViewController *paySelect = [[PaySelectViewController alloc] init];
        paySelect.code = order.orderCode;
        NSString *price  =[order.orderMoney substringFromIndex:1];
        price = [price substringToIndex:price.length - 1];
        NSLog(@"price:%@",price);
        paySelect.price = price;
        paySelect.sign = order.sign;
        [blockSelf.navigationController pushViewController:paySelect animated:YES];
    }];
}

@end
