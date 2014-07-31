//
//  PictureViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-12.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "PictureViewController.h"
#import "AppDelegate.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "UIImageView+WebCache.h"

@interface PictureViewController ()

@end

@implementation PictureViewController
{
    AppDelegate *_app;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    Neighbor *nei = [_dataArray objectAtIndex:_row];
    NSArray *array = nei.neiPictureArray;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (isRetina.size.height-200)/2, 320, 200)];
    scrollView.contentSize = CGSizeMake(320*array.count, 130);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    for(int i = 0; i < array.count; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 200)];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,[array objectAtIndex:i]]]];
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview:imageView];
    }
    
    
    UIImageView *sView = [[UIImageView alloc] init];
    sView.frame = CGRectMake(0, 20, 320, 40);
    sView.userInteractionEnabled = YES;
    sView.image = [UIImage imageNamed:@"back_bg.png"];
    [self.view addSubview:sView];
    
    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sButton.frame = CGRectMake(10, 6, 50, 25);
    sButton.tag = 501;
    [sButton setBackgroundImage:[UIImage imageNamed:@"返回1.png"] forState:UIControlStateNormal];
    [sButton addTarget:self action:@selector(bbiClick:) forControlEvents:UIControlEventTouchUpInside];
    [sView addSubview:sButton];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    }
- (void)bbiClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
