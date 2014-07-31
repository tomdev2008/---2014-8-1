//
//  PaySelectViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-30.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "PaySelectViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"

#import "AlixPayResult.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "AlixLibService.h"
#import "PartnerConfig.h"
#import "ZL_CONST.h"

@class Product;

@interface PaySelectViewController ()

@end

@implementation PaySelectViewController
{
    AppDelegate *_app;
    int paySelectCount;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"支付方式选择" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
    
    
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(40, 175, 30,200);
    [self.view addSubview:view];
    
    for(NSInteger i = 0; i < 3; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"radio_no.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"radio_yes.png"] forState:UIControlStateSelected];
        button.tag = 130 + i;
        button.frame = CGRectMake(0, 35+35*i, 20, 20);
        [button addTarget:self action:@selector(bbi_isSelect:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    ((UIButton *)[view.subviews objectAtIndex:0]).selected = YES;
    [((UIButton *)[view.subviews objectAtIndex:0]) setBackgroundImage:[UIImage imageNamed:@"radio_yes.png"] forState:UIControlStateNormal];
    
    _orderCodeLable.text = self.code;
    _priceLable.text = self.price;
}

- (void)bbi_isSelect:(UIButton *)button
{
    NSArray *arrays = [button.superview subviews];
    NSLog(@"%@",arrays);
    for(UIButton *btn in arrays)
    {
        btn.selected = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"radio_no.png"] forState:UIControlStateNormal];
    }
    button.selected = NO;
    [button setBackgroundImage:[UIImage imageNamed:@"radio_yes.png"] forState:UIControlStateNormal];
    paySelectCount = button.tag;
    NSLog(@"%d",paySelectCount);
    
}

- (void)bbiItem:(UIButton *)button
{
    if(button.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(button.tag == 101)
    {
        NSLog(@"支付");
        
    }
}

//支付宝支付方法
- (void)pay
{
    NSString *appScheme = @"DBLAlipaySdkDemo";
    NSString* orderInfo = _sign;
    NSString* signedStr = [self doRsa:orderInfo];
    
    //    NSLog(@"orderInfo: %@", orderInfo);
    //    NSLog(@"signedStr: %@",signedStr);
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfo, signedStr, @"RSA"];
	
    //NSLog(@"orderString: %@", orderString);
    NSLog(@"%@",orderInfo);
    
    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
}

//支付宝wap回调函数，不用
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];

	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
			}
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"result: %@",result);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)payClick:(id)sender
{
    if(paySelectCount == 130)
    {
        [self pay];
    }
    else if(paySelectCount == 131)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"银联支付暂不可使用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
@end
