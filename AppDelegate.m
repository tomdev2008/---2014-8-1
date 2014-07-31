//
//  AppDelegate.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-28.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "AppDelegate.h"
#import "NeighborViewController.h"
#import "PersonServerViewController.h"
#import "MessageViewController.h"
#import "ActivityViewController.h"
#import "MineViewController.h"
#import "ZL_CONST.h"
#import "DownLoadManager.h"
#import "OrderManagerViewController.h"

#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "DownLoadClass/PartnerConfig.h"
#import <AudioToolbox/AudioToolbox.h>
#import <ShareSDK/ShareSDK.h>


@implementation AppDelegate
{
    OrderManagerViewController *order;
    PersonServerViewController *person;
    DownLoadManager *dm;
}

- (void)createMyTableBar:(NSArray *)array
{
    _mtb = [[MyTabBar alloc] init];
    _tbc = [[UITabBarController alloc] init];
    _tbc.viewControllers = array;
    self.window.rootViewController = _tbc;
    
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePersonOrManager:) name:@"orderPerson" object:nil];
    
    // 1.找到当前工程目录
    NSString *path = [NSString stringWithFormat:@"%@/",[[NSBundle mainBundle] resourcePath]];
    NSString *dataPath = [path stringByAppendingString:@"Data.plist"];
    // 2.从plist文件中读取数据
    NSDictionary *plistDict = [[NSDictionary alloc] initWithContentsOfFile:dataPath];
    NSArray *itemsArray = [plistDict objectForKey:@"items"];
    
    NSMutableArray *itemImagesName = [[NSMutableArray alloc] init];
    NSMutableArray *itemSelectImageName = [[NSMutableArray alloc] init];
    NSMutableArray *itemsTitle = [[NSMutableArray alloc] init];
    
    for(NSDictionary *itemDict in itemsArray)
    {
        [itemsTitle addObject:[itemDict objectForKey:@"itemtitle"]];
        [itemImagesName addObject:[itemDict objectForKey:@"itemimagename"]];
        [itemSelectImageName addObject:[itemDict objectForKey:@"itemselectimagename"]];
        
    }
    if(isRetina.size.height > 480)
    {
        _mtb.frame = CGRectMake(0, 568-49, 320, 49);
    }
    else
    {
        _mtb.frame = CGRectMake(0, 480-49, 320, 49);
    }
    [_mtb createMyTabBarWithBackgroundImageName:nil andItemTitles:itemsTitle andItemImagesName:itemImagesName andItemSelectImagesName:itemSelectImageName andClass:self andSEL:@selector(btnClick:)];
    [_tbc.view addSubview:_mtb];
    NSLog(@"tbc.view ::-----%@",_tbc.view);
    
    // 设置默认初始选中item图片
    ((UIButton *)[((UIView *)[_mtb.subviews objectAtIndex:1]).subviews objectAtIndex:0]).selected = YES;
    ((UILabel *)[((UIView *)[_mtb.subviews objectAtIndex:1]).subviews objectAtIndex:1]).textColor = [UIColor colorWithRed:0.32f green:0.73f blue:0.62f alpha:1.00f];
}

// 是否是商户
- (void)changePersonOrManager:(NSNotification *)noti
{
    
    NSMutableArray *marray = [NSMutableArray arrayWithArray:_tbc.viewControllers];
    if([noti.object boolValue])
    {
        [marray replaceObjectAtIndex:1 withObject:[[UINavigationController alloc] initWithRootViewController:person]];
    }
    else
    {
        [marray replaceObjectAtIndex:1 withObject:[[UINavigationController alloc] initWithRootViewController:order]];
    }
    _tbc.viewControllers = marray;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    dm = [DownLoadManager shareDownLoadManager];
   
    NeighborViewController *neighbor = [[NeighborViewController alloc] init];
    UINavigationController *navNeighbor = [[UINavigationController alloc] initWithRootViewController:neighbor];
    
    person = [[PersonServerViewController alloc] init];
    UINavigationController *navPerson = [[UINavigationController alloc] initWithRootViewController:person];
    order = [[OrderManagerViewController alloc] init];
    
    MessageViewController *message = [[MessageViewController alloc] init];
    UINavigationController *navMessage = [[UINavigationController alloc] initWithRootViewController:message];
    ActivityViewController *activity = [[ActivityViewController alloc] init];
    UINavigationController *navActivity  = [[UINavigationController alloc] initWithRootViewController:activity];
    MineViewController *mine = [[MineViewController alloc] init];
    UINavigationController *navMine = [[UINavigationController alloc] initWithRootViewController:mine];
    
    NSArray *controllers = [NSArray arrayWithObjects:navNeighbor,navPerson,navMessage,navActivity,navMine, nil];
    
    [self createMyTableBar:controllers];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // shareSDK
    [ShareSDK registerApp:@"2483eb78b0e0"];
    [self regiestSinaAndQQ];
    
    //百度推送
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeNewsstandContentAvailability];
    
    
    return YES;
}


-(void)onMethod:(NSString *)method response:(NSDictionary *)data
{
    NSLog(@"method: %@", method);
    NSDictionary *res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
        //NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        //NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        //NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        self.LoaginDeviceId = userid;
        NSLog(@"userId: %@", userid);
        
        NSLog(@"response: %@", res);
        if (returnCode == 0) {
            NSLog(@"success");
        }else{
            NSLog(@"error: %@", [res valueForKey:BPushRequestErrorMsgKey]);
        }
    }else if ([BPushRequestMethod_ListTag isEqualToString:method]){
        NSLog(@"response: %@", res);
    }else if ([BPushRequestMethod_SetTag isEqualToString:method]){
        NSLog(@"response: %@", res);
    }else if ([BPushRequestMethod_DelTag isEqualToString:method]){
        NSLog(@"response: %@", res);
    }else if ([BPushRequestMethod_Unbind isEqualToString:method]){
        NSLog(@"response: %@", res);
    }
    
    
}

// 推送
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //处理收到的push消息
    NSLog(@"app received userInfo: %@", userInfo);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",userInfo] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    [application setApplicationIconBadgeNumber:0];
    [BPush handleNotification:userInfo];  //可选
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"app deviceToken: %@", deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannel];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}



- (void)btnClick:(UIButton *)btn
{
    NSLog(@"btn.tag = %d",btn.tag);
    // 1.将所有的变为黑色
    NSArray *subViews = btn.superview.superview.subviews;
    for(UIView *view in subViews)
    {
        if(![view isKindOfClass:[UIImageView class]])
        {
            ((UIButton *)[view.subviews objectAtIndex:0]).selected = NO;
            ((UILabel *)[view.subviews objectAtIndex:1]).textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
        }
    }
    // 2.将选中的变蓝色
    btn.selected = YES;
    ((UILabel *)[btn.superview.subviews objectAtIndex:1]).textColor = [UIColor colorWithRed:0.07f green:0.64f blue:0.49f alpha:1.00f];;
    // 3.设置tab跳转界面
    _tbc.selectedIndex = btn.tag;

}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//支付宝独立客户端回调函数
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	
	[self parse:url application:application];
	return YES;
}

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    NSLog(@"application");
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    NSLog(@"result: %@", result);
	if (result)
    {
		/*
         错误码
         9000   订单支付成功
         8000   正在处理中
         4000   订单支付失败
         6001   用户中途取消
         6002   网路连接失败
         */
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            //            NSString* key = @"签约帐户后获取到的支付宝公钥";
            //			id<DataVerifier> verifier;
            //            verifier = CreateRSADataVerifier(key);
            
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(AlipayPubKey);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                NSLog(@"验证签名成功");
			}else{
                NSLog(@"交易失败2");
            }
            
        }
        else if (result.statusCode == 8000)
        {
            //交易失败
            NSLog(@"交易失败8000");
        }
        else if (result.statusCode == 6000)
        {
            //交易失败
            NSLog(@"交易失败6000");
        }
        else if (result.statusCode == 6002)
        {
            //交易失败
            NSLog(@"交易失败6002");
        }
        else if (result.statusCode == 6001)
        {
            //交易失败
            NSLog(@"交易失败6001");
        }
    }
    else
    {
        //失败
        NSLog(@"交易失败0");
    }
    
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}

// 新浪微博  QQ空间
- (void)regiestSinaAndQQ
{
    // 新浪微博
    [ShareSDK connectSinaWeiboWithAppKey:@"3201194191"
                               appSecret:@"0334252914651e8f76bad63337b3b78f"
                             redirectUri:@"http://appgo.cn"];
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"];
}

@end
