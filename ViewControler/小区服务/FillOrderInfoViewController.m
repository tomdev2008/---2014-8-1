//
//  FillOrderInfoViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-8.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "FillOrderInfoViewController.h"
#import "Canver.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "DownLoadManager.h"
#import "InvoiceViewController.h"
#import "AddressInfoViewController.h"
#import "InvoiceViewController.h"
#import "PaySelectViewController.h"
#import "ChangeOrderViewController.h"
#import "ZL_CONST.h"

@interface FillOrderInfoViewController ()

@end

@implementation FillOrderInfoViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
    AddressInfoViewController *_address;
    InvoiceViewController *_invoice;
    UIView *_backView;
    OrderInfo *_orderInfo;
    NSMutableArray *_dataArray;
    User *_user;
    float _totalPrice; // 总价
    float _couPrice;
    float _pointPrice;
    Order *_order;
    LoadingView *_loadingView;
    
    UITextField *textField ;
    UIControl *_control;
    UIButton *clickAdd;
    
    NSString *littleNum;    // 如果是百分数。
    
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.hidesBottomBarWhenPushed = YES; // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"-------%@-----%@",_dm.status,@"没有数据");
    if([_dm.status isEqualToString:@"400"])
    {
        [_loadingView loadingViewDispear:0.0];
    }
}


- (void)createNavigation
{
    _address = [[AddressInfoViewController alloc] init];
    _invoice = [[InvoiceViewController alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    _dm = [DownLoadManager shareDownLoadManager];
        // 获得我的优惠券
    
    [self getMyCouponList];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"填写订单" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
    
   
}
- (void)controlClick
{
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:2001];
    UILabel *pointLabel = (UILabel *)[scrollView viewWithTag:112];
    UITextField *text = (UITextField *)[scrollView viewWithTag:106];
    pointLabel.text = [NSString stringWithFormat:@"￥：%.0f",[text.text floatValue]];
    _pointPrice = [text.text floatValue];
    [self getTotal];
    UILabel *totalLabel = (UILabel *)[scrollView viewWithTag:201];
    totalLabel.text = [NSString stringWithFormat:@"应付金额:%.2f",_totalPrice];
    _control.hidden = YES;
    [textField resignFirstResponder];
}

// 计算总价
- (void)getTotal
{
    if([_orderInfo.oinfoTotal floatValue] -  [textField.text floatValue]-_couPrice >= 0)
    {
        _totalPrice = [_orderInfo.oinfoTotal floatValue] -  [textField.text floatValue]-_couPrice;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"价格低于0元" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:2001];
        UIButton *button = (UIButton *)[scrollView viewWithTag:10];
        button.enabled = NO;
        return;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self createScrollView];
    _control = [[UIControl alloc] init];
    _control.frame = CGRectMake(0, 64, 320, 300);
    _control.hidden = YES;
    [_control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_control];
    [self createLoadView];
}
- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
}

- (void)getMyCouponList
{
    __block FillOrderInfoViewController *blockSelf = self;
    [_dm getMyCouponList];
    [_dm setMyCouponList:^(NSArray *array) {
        [blockSelf -> _dataArray addObjectsFromArray:array];
        [blockSelf createDiscouView];
        UIScrollView *scrollView = (UIScrollView *)[blockSelf.view viewWithTag:2001];
        UILabel *couponLabel = (UILabel *)[scrollView viewWithTag:103];
        couponLabel.text = [NSString stringWithFormat:@"您有 %d 张优惠券",[blockSelf -> _dataArray count]];
    }];
    
    [_dm getMyPointInfo];
    [_dm setMyPointINfoBlock:^(User *user) {
        blockSelf -> _user = user;
        UIScrollView *scrollView = (UIScrollView *)[blockSelf.view viewWithTag:2001];
        UILabel *pointLabel = (UILabel *)[scrollView viewWithTag:104];
        pointLabel.text = [NSString stringWithFormat:@"你有%@积分,一百积分抵扣1元 你要抵扣",user.userTotal];
        [blockSelf -> _loadingView loadingViewDispear:0];
    }];
}

- (void)createContentWithScrollView:(UIScrollView *)scrollView
{
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.frame = CGRectMake(20, 20, 300, 20);
    addressBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [addressBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [addressBtn setTitle:@"收货地址" forState:UIControlStateNormal];
    addressBtn.tag = 99;
    addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [addressBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:addressBtn];
    if(self.comeId == 2)
    {
        addressBtn.enabled = YES;
    }
    
    
    if(_orderInfo.addAddress != nil)
    {
        NSString *realName = [NSString stringWithFormat:@"联系人:%@",_orderInfo.addName];
        NSString *phoneNu = [NSString stringWithFormat:@"电话:%@",_orderInfo.addContact];
        NSString *addressInfo = [NSString stringWithFormat:@"地址:%@",_orderInfo.addAddress];
        NSArray *addresss =[NSArray arrayWithObjects:realName,phoneNu,addressInfo, nil];
        for(int i = 0; i < 3; i ++)
        {
            UILabel *lable = [[UILabel alloc] init];
            lable.frame = CGRectMake(20, addressBtn.frame.origin.y+28*i+35, 280, 15);
            lable.font = [UIFont systemFontOfSize:13];
            lable.numberOfLines = 0;
            lable.textColor = [UIColor lightGrayColor];
            lable.text = [addresss objectAtIndex:i];
            [scrollView addSubview:lable];
        }
    }
    else
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        clickAdd = button;
        clickAdd.tag = 99;
        [clickAdd setTitle:@"点击选择地址" forState:UIControlStateNormal];
        [clickAdd setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        clickAdd.frame = CGRectMake(10, 40, 300, 100);
        [clickAdd addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:clickAdd];
        if(self.comeId == 2)
        {
            button.enabled = YES;
        }
    }
    
    __block NSString *realName = nil;
    __block NSString *phoneNum = nil;
    __block NSString *addressInfo = nil;
    [_address setAddressBlock:^(NSString *name, NSString *phone, NSString *address) {
        [clickAdd setTitle:@"" forState:UIControlStateNormal];
        realName = [NSString stringWithFormat:@"联系人:%@",name];
        phoneNum = [NSString stringWithFormat:@"电话:%@",address];
        addressInfo = [NSString stringWithFormat:@"地址:%@",phone];
        NSArray *array = [NSArray arrayWithObjects:realName,phoneNum,addressInfo, nil];
        for(int i = 0; i < array.count; i ++)
        {
            UILabel *lable = (UILabel *)[clickAdd viewWithTag:300+i];
            if(lable == nil)
            {
                lable = [[UILabel alloc] init];
                lable.frame = CGRectMake(10, 28*i+15, 280, 15);
                lable.font = [UIFont systemFontOfSize:13];
                lable.numberOfLines = 0;
                
                lable.tag = 300+i;
                lable.textColor = [UIColor lightGrayColor];
                [clickAdd addSubview:lable];;
            }
            lable.text = [array objectAtIndex:i];
        }
    }];
    
    
    // 发票信息
    UIButton *pageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pageBtn.frame = CGRectMake(20, 35*4+20, 200, 15);
    pageBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    pageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [pageBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [pageBtn setTitle:@"发票信息" forState:UIControlStateNormal];
    pageBtn.tag = 101;
    [pageBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:pageBtn];
    
    // 发票抬头
    UILabel *labelHeader = [[UILabel alloc] init];
    labelHeader.frame = CGRectMake(20, 35*5+20, 280, 15);
    labelHeader.font = [UIFont systemFontOfSize:15];
    labelHeader.textColor = [UIColor lightGrayColor];
    labelHeader.text = [NSString stringWithFormat:@"发票抬头:无"];
    labelHeader.tag = 1001;
    [scrollView addSubview:labelHeader];
    
    // 优惠券抵扣
    UIButton *couponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    couponBtn.frame = CGRectMake(20, 35*7-5,200, 15);
    couponBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [couponBtn setTitle:@"优惠券抵扣" forState:UIControlStateNormal];
    [couponBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    couponBtn.tag = 102;
    couponBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [couponBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:couponBtn];
    
    // 您有几张优惠券
    UILabel *couponLable = [[UILabel alloc] init];
    couponLable.frame = CGRectMake(20, 35*8-5, 200, 15);
    couponLable.font = [UIFont systemFontOfSize:15];
    couponLable.textColor = [UIColor lightGrayColor];
    couponLable.tag = 103;
    couponLable.text = [NSString stringWithFormat:@"您有 %d 张优惠券",[_dataArray count]];
    [scrollView addSubview:couponLable];
    
    // 积分抵扣支付
    UILabel *labelPoint = [[UILabel alloc] init];
    labelPoint.frame = CGRectMake(20, 35*9+20, 200, 15);
    labelPoint.font = [UIFont systemFontOfSize:15];
    labelPoint.textColor = [UIColor darkGrayColor];
    labelPoint.text = @"积分抵扣支付";
    [scrollView addSubview:labelPoint];

    // 多少积分
    UILabel *myPoint = [[UILabel alloc] init];
    myPoint.frame = CGRectMake(20, labelPoint.frame.origin.y+25, 280, 40);
    myPoint.numberOfLines = 0;
    myPoint.tag = 104;
    myPoint.font = [UIFont systemFontOfSize:13];
    myPoint.backgroundColor = [UIColor clearColor];
    myPoint.textColor = [UIColor lightGrayColor];
    myPoint.text = @"你有0积分,一百积分抵扣1元 你要抵扣";
    [scrollView addSubview:myPoint];
    
    // 积分输入
    textField = [[UITextField alloc] init];
    textField.placeholder = @"请输入积分";
    textField.frame = CGRectMake(320-55, myPoint.frame.origin.y+8, 40, 20);
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.delegate = self;
    textField.tag = 106;
    [textField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    textField.font = [UIFont systemFontOfSize:10];
    [scrollView addSubview:textField];

    UIButton *serverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    serverBtn.frame = CGRectMake(20, myPoint.frame.origin.y+myPoint.frame.size.height+15, 200, 15);
    serverBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [serverBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [serverBtn setTitle:@"查看服务清单" forState:UIControlStateNormal];
    serverBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    serverBtn.tag = 105;
    [serverBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:serverBtn];
    
    // 结算信息
    UILabel *settleLabel = [[UILabel alloc] init];
    settleLabel.frame = CGRectMake(20, serverBtn.frame.origin.y+serverBtn.frame.size.height+30, 100, 15);
    settleLabel.font = [UIFont systemFontOfSize:15];
    settleLabel.textColor = [UIColor darkGrayColor];
    settleLabel.text = @"结算信息";
    [scrollView addSubview:settleLabel];
    
    NSArray *array = [NSArray arrayWithObjects:@"商品总额:",@"优惠券",@"积分", nil];
    for(int i = 0; i < 3; i ++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(20, settleLabel.frame.origin.y+settleLabel.frame.size.height+20+25*i, 100, 15);
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor darkGrayColor];
        label.text = [array objectAtIndex:i];
        [scrollView addSubview:label];
        
        UILabel *priceLable = [[UILabel alloc] init];
        priceLable.frame = CGRectMake(200, settleLabel.frame.origin.y+settleLabel.frame.size.height+20+25*i, 100, 15);
        priceLable.font = [UIFont systemFontOfSize:15];
        priceLable.textColor = [UIColor darkGrayColor];
        priceLable.tag = 110+i;
        if(i == 0) priceLable.text = [NSString stringWithFormat:@"￥：%@",_orderInfo.oinfoTotal];
        else if(i == 1) priceLable.text = [NSString stringWithFormat:@"￥：0"];
        else priceLable.text = [NSString stringWithFormat:@"￥：0"];
        [scrollView addSubview:priceLable];
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textField resignFirstResponder];
}


// 开始编辑的时候
- (void)textChange
{
    if([textField.text intValue] > [[_user userTotal] intValue])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你输入的积分大于您拥有的积分" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:2001];
        UIButton *button = (UIButton *)[scrollView viewWithTag:10];
        button.enabled = NO;
        return;
    }
    _control.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)createScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?44:64, 320, 600)];
    scrollView.contentSize = CGSizeMake(320, isRetina.size.height>480?800:900);
    scrollView.tag = 2001;
    scrollView.bounces = YES;
    [self.view addSubview:scrollView];
    
    Canver *canver = [[Canver alloc] init];
    canver.backgroundColor = [UIColor clearColor];
    canver.frame = scrollView.bounds;
    [scrollView addSubview:canver];
    
    UILabel *totalLable = [[UILabel alloc] init];
    totalLable.frame = CGRectMake(180, 600, 140, 20);
    
    totalLable.tag = 201;
    totalLable.textColor = [UIColor colorWithRed:0.71f green:0.41f blue:0.00f alpha:1.00f];
    [scrollView addSubview:totalLable];
    
    if(self.comeId != 2)
    {
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.frame = CGRectMake(20, totalLable.frame.origin.y+40, 280, 30);
        [sendBtn setBackgroundImage:[UIImage imageNamed:@"手机注册_03.png"] forState:UIControlStateNormal];
        [sendBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
        sendBtn.tag = 10;
        [scrollView addSubview:sendBtn];
    }
    __block FillOrderInfoViewController *blockSelf = self;
    if(self.comeId == 0 || self.comeId == 2)
    {
        [_dm getServerBookWithSid:[self.serId intValue]];
        [_dm setServerBookBlock:^(OrderInfo *orderInfo) {
            blockSelf -> _orderInfo = orderInfo;
            blockSelf -> _totalPrice = [orderInfo.oinfoTotal floatValue];
            [blockSelf createContentWithScrollView:scrollView];
        }];
    }
    else
    {
        [_dm getOrderServerInfoWithOsid:[self.oid intValue]];
        [_dm setOrderServerInfoBlock:^(NSArray *array) {
            blockSelf -> _orderInfo = [array objectAtIndex:0];
            [blockSelf createContentWithScrollView:scrollView];
        }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 实现协议中得方法    发票信息
- (void)changeAddressAndInvoiceInfoWithName:(NSString *)name
{
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:2001];
    UILabel *nameLabel = (UILabel *)[scrollView viewWithTag:1001];
    nameLabel.text = [NSString stringWithFormat:@"发票抬头:%@",name];

}

- (void)btnClick:(UIButton *)button
{
    if(button.tag == 99)
    {
        [self.navigationController pushViewController:_address animated:YES];
    }
    else if(button.tag == 101)  // 发票信息
    {
        InvoiceViewController *invoice = [[InvoiceViewController alloc] init];
        invoice.delegate = self;
        [self.navigationController pushViewController:invoice animated:YES];
    }
    else if(button.tag == 102)
    {
        _backView.hidden = NO;
    }
    else if(button.tag == 105)
    {
        if([_orderInfo.sePrice_Type isEqualToString:@"1"])
        {
            ChangeOrderViewController *changeOrder = [[ChangeOrderViewController alloc] init];
            [self.navigationController pushViewController:changeOrder animated:YES];
        }
        else if([_orderInfo.sePrice_Type isEqualToString:@"0"])
        {
            ChangeNumViewController *changeNumber = [[ChangeNumViewController alloc] init];
            changeNumber.delegate = self;
            changeNumber.server = [[Server alloc] init];
            changeNumber.server.serId = _orderInfo.oinfoId;
            changeNumber.serId = _orderInfo.seId;
            changeNumber.server.serName = _orderInfo.seName;
            changeNumber.server.serTitlePic = _orderInfo.seTitlePic;
            changeNumber.server.serPrice = _orderInfo.oinfoTotal;
            [self.navigationController pushViewController:changeNumber animated:YES];
        }
    }
}

- (void)createDiscouView
{
    _backView = [[UIView alloc] init];
    _backView.hidden = YES;
    _backView.backgroundColor = [UIColor clearColor];
    _backView.frame = self.view.bounds;
    [self.view addSubview:_backView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(30, 160, 260, 200);
    imageView.image = [UIImage imageNamed:@"select_bg"];
    imageView.userInteractionEnabled = YES;
    [_backView addSubview:imageView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 50, 260, 200);
    scrollView.contentSize = CGSizeMake(260, 30*_dataArray.count);
    [imageView addSubview:scrollView];
    
    for(int i = 0; i < _dataArray.count; i ++)
    {
        Coupon *cou = [_dataArray objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 30*i, 20, 20);
        [button setBackgroundImage:[UIImage imageNamed:@"radio_no"] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(35, 30*i, 200, 20);
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor darkGrayColor];
        label.text = cou.couName;
        [scrollView addSubview:label];
        
    }
}

// 判断是否为数字
- (BOOL)isPureNumandCharacters:(NSString *)str
{
    for(int i = 0 ; i < str.length; i ++)
    {
        char a = [str characterAtIndex:i];
        for(int i = 0; i < 9; i ++)
        {
            if(a == i)
            {
                return YES;
            }
            else
            {
                str = [NSString stringWithFormat:@"0.%@",[str substringToIndex:str.length-1]];
                littleNum = str;
                break;
            }
        }
        if(littleNum != nil)
        {
            break;
        }
    }
    return NO;
}

- (void)selectClick:(UIButton *)button
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
        Coupon *cou = [_dataArray objectAtIndex:button.tag-100];
        if([self isPureNumandCharacters:cou.couValue])
        {
            _couPrice = [cou.couValue floatValue];
        }
        else
        {
            _couPrice = [littleNum floatValue];
        }
        if(cou.couValue )
        [button setTitleColor:[UIColor colorWithRed:0.05f green:0.64f blue:0.49f alpha:1.00f] forState: UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"radio_yes"] forState:UIControlStateSelected];
        _backView.hidden = YES;;
        
        
        UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:2001];
        UILabel *couponLabel = (UILabel *)[scrollView viewWithTag:111];
        
        UILabel *disCountLabel = (UILabel *)[scrollView viewWithTag:103];
        disCountLabel.text = [[_dataArray objectAtIndex:button.tag - 100] couName];
        
        couponLabel.text = [NSString stringWithFormat:@"￥：%@",cou.couValue];
        [self getTotal];
        UILabel *totalLabel = (UILabel *)[scrollView viewWithTag:201];
        totalLabel.text = [NSString stringWithFormat:@"应付金额:%.2f",_totalPrice];
        
    }
    else
    {
        button.selected = NO;
    }
}



- (void)bbiItem:(UIButton *)button
{
    if(button.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"提交订单");
        __block FillOrderInfoViewController *blockSelf = self;
        [_dm submitOrderWithOid:self.oid andType:@"1"];

        [_dm submitOrderWithOid:self.serId andType:@"1"];

        [_dm setRealPaySubmitBlock:^(Order *order) {
          blockSelf -> _order = order;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否前往支付" delegate:blockSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.tag = 1;
            [alertView show];
        }];
    }
}

// 实现协议中的方法
- (void)changePrice:(NSString *)price
{
    if(![price isEqualToString:@"0"])
    {
        _orderInfo.oinfoTotal = price;
        UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:2001];
        [self getTotal];
        UILabel *totalLabel = (UILabel *)[scrollView viewWithTag:201];
        totalLabel.text = [NSString stringWithFormat:@"应付金额:%.2f",_totalPrice];
        
        UILabel *sLabel = (UILabel *)[scrollView viewWithTag:110];
        sLabel.text = [NSString stringWithFormat:@"商品总额:%@",_orderInfo.oinfoTotal];
    }
}

- (void)submitOrderWithOrder:(Order *)order
{
    PaySelectViewController *paySelect = [[PaySelectViewController alloc] init];
    paySelect.code = order.orderCode;
    NSString *price  =[order.orderMoney substringFromIndex:1];
    price = [price substringToIndex:price.length - 1];
    NSLog(@"price:%@",price);
    paySelect.price = price;
    paySelect.sign = order.sign;
    [self.navigationController pushViewController:paySelect animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 0)
        {
            [self submitOrderWithOrder:_order];
        }
        else
        {
            return;
        }
    }
    else
    {
        return;
    }
}

@end
