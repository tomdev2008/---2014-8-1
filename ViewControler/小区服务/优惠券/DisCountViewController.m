//
//  DisCountViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-30.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "DisCountViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "ActivityInfoViewController.h"
#import "ZL_CONST.h"
#import "DownLoadManager.h"
#import "DisCountCell.h"
#import "ZL_INTERFACE.h"
#import "DisCountOrderViewController.h"
#import "DisCountInfoViewController.h"
#import "SortView.h"

@interface DisCountViewController ()

@end

@implementation DisCountViewController
{
    AppDelegate *_app;
    UIView *_backView;
    UITextField *_searchText;
    DownLoadManager *_dm;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    LoadingView *_loadingView;
    SortView *sortView;
    SortView *select_sortView;
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

- (void)viewWillDisappear:(BOOL)animated
{
    _app.mtb.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"-------%@-----%@",_dm.status,@"没有数据");
    if([_dm.status isEqualToString:@"400"])
    {
        [_loadingView loadingViewDispear:0.0];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    _dm = [DownLoadManager shareDownLoadManager];
    _dataArray = [[NSMutableArray alloc] init];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"优惠券" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem:) andClass:self];
    [self.view addSubview:mnb];
    [_dm getDiscountListWithCid:_dm.communityId andPage:1];
    __block DisCountViewController *blockSelf = self;
    [_dm setDiscountBlock:^(NSArray *array) {
        [blockSelf->_dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
        [blockSelf -> _loadingView loadingViewDispear:0];
    }];

    // 创建动画
    [self createAnimation];
    
    // 创建TabelView
    [self createTableView];
    [self createLoadView];
    [self createSort];
    [self createSelect];
}

// 创建排序
- (void)createSort
{
    sortView = [[SortView alloc] initWithFrame:CGRectMake(0, _backView.frame.origin.y+40, 320, 91)];
    sortView.tag = 0;
    sortView.hidden = YES;
    [self.view addSubview:sortView];
    
    //
    [sortView createSortCouponWithObject:self andSEL:@selector(sortClick:)];
}
// 筛选
- (void)createSelect
{
    select_sortView = [[SortView alloc] initWithFrame:CGRectMake(0,_backView.frame.origin.y+40,320,181)];
    select_sortView.tag = 1;
    select_sortView.hidden = YES;
    [self.view addSubview:select_sortView];
    
    //
    [select_sortView createSelectCouponWithObject:self andSEL:@selector(sortClick:)];
}

// 排序按钮
- (void)sortClick:(UIButton *)button
{
    [self createLoadView];
    __block DisCountViewController *blockSelf = self;
    sortView.hidden = YES;
    select_sortView.hidden = YES;
    if(button.tag == 0)
    {
        return;
    }
    if(button.superview.superview.tag == 0)
    {
        [_dm couponSortWithOrder:[NSString stringWithFormat:@"%d",button.tag+2] andType:0 andCid:_dm.communityId];
    }
    else if(button.superview.superview.tag == 1)
    {
        [_dm couponSortWithOrder:[NSString stringWithFormat:@"%d",button.tag] andType:1 andCid:_dm.communityId];
    }
    [_dm setDiscountBlock:^(NSArray *array) {
        [blockSelf -> _dataArray removeAllObjects];
        [blockSelf->_dataArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
        [blockSelf -> _loadingView loadingViewDispear:0];
    }];
}


- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
}

// 创建排序 筛选 搜索
- (void)createAnimation
{
    NSArray *array = [NSArray arrayWithObjects:@"  排序     |",@"  筛选     |",@"  搜索 ", nil];
    _backView = [[UIView alloc] init];
    _backView.frame = CGRectMake(0, is_IPHONE_6?44:64, 640, 40);
    _backView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    [self.view addSubview:_backView];
    
    for(NSInteger i = 0; i < array.count; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(30+100*i, 0, 80, 40);
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        button.selected = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:button];
    }
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(330, 0, 50, 40);
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    backBtn.tag = 3;
    [backBtn addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:backBtn];
    
    _searchText = [[UITextField alloc] init];
    _searchText.frame = CGRectMake(380, 5, 200, 30);
    _searchText.borderStyle = UITextFieldViewModeAlways;
    _searchText.borderStyle = UITextBorderStyleNone;
    _searchText.placeholder = @"请输入您要查找的优惠券";
    _searchText.font = [UIFont systemFontOfSize:13];
    _searchText.delegate =self;
    _searchText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_backView addSubview:_searchText];
    [_searchText setBackground:[UIImage imageNamed:@"输入框.png"]];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(590, 7, 25, 25);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"搜索.png"] forState:UIControlStateNormal];
    searchBtn.tag = 4;
    [searchBtn addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:searchBtn];
}

// 创建TableView
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?84:104, 320, isRetina.size.height >480?568-64-44:480-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_dataArray.count > 0)
    {
        return [_dataArray count];
    }
    else
    {
        return 4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    DisCountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DisCount" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(320-95, 35, 70, 25);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"点击领取" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setBackgroundImage:[UIImage imageNamed:@"立即参加.png"] forState:UIControlStateNormal];
    // 这里加了200.
    button.tag = indexPath.row + 200;
    [button addTarget:self action:@selector(bbiItem:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    
    if(_dataArray.count > 0)
    {
        Discount *discount = [_dataArray objectAtIndex:indexPath.row];
        [cell.titlePic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,discount.disTitlePic]]];
        cell.nameLabel.text = discount.disName;
        cell.priceLabel.text = discount.disPrice;
        cell.dateTimeLabel.text = [NSString stringWithFormat:@"%@-%@",discount.disStart,discount.disEnd];
        if(discount.disGot == 0)
        {
            [button setTitle:@"已领取" forState:UIControlStateNormal];
            button.enabled = NO;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DisCountInfoViewController *disCount = [[DisCountInfoViewController alloc] init];
    Discount *discount = [_dataArray objectAtIndex:indexPath.row];
    disCount.did = discount.disId;
    [self.navigationController pushViewController:disCount animated:YES];
}

- (void)bbiItem:(UIButton *)button
{
    if(button.tag < 200 && button.tag >= 100)
    {
        NSArray *array = button.superview.subviews;
        NSInteger count = 0;
        for(UIButton *btn in array)
        {
            if(count == 3 || count == 4 || count == 5)
            {
                continue;
            }
            btn.selected = YES;
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            count ++;
        }
        button.selected = NO;
        [button setTitleColor:[UIColor colorWithRed:0.74f green:0.48f blue:0.25f alpha:1.00f] forState:UIControlStateNormal];
        if(button.tag == 100)
        {
            sortView.hidden = NO;
            select_sortView.hidden = YES;
        }
        else if(button.tag == 101)
        {
            select_sortView.hidden = NO;
            sortView.hidden = YES;
        }
        if(button.tag == 102)
        {
            sortView.hidden = YES;
            select_sortView.hidden = YES;
            [UIView animateWithDuration:0.5 animations:^{
                _backView.frame = CGRectMake(-320, is_IPHONE_6?44:64, 640, 40);
            }];
        }
    }
    if(button.tag < 100)
    {
        switch(button.tag)
        {
            case 1:
                [self.navigationController popViewControllerAnimated:YES];
                break;
            case 3:
            {
                [UIView animateWithDuration:0.5 animations:^{
                    _backView.frame = CGRectMake(0, is_IPHONE_6?44:64, 640, 40);
                }];
                break;
            }
            case 4:
            {
                __block DisCountViewController *blockSelf=  self;
                [_dm couponSortWithOrder:_searchText.text andType:2 andCid:_dm.communityId];
                [_dm setDiscountBlock:^(NSArray *array) {
                    [blockSelf -> _dataArray removeAllObjects];
                    [blockSelf->_dataArray addObjectsFromArray:array];
                    [blockSelf -> _tableView reloadData];
                    [blockSelf -> _loadingView loadingViewDispear:0];
                }];
                  break;
            }
              
        }
    }
    if(button.tag >= 200)
    {
        DisCountOrderViewController *disCountOrder = [[DisCountOrderViewController alloc] init];
        disCountOrder.discountOrderArray = [[NSMutableArray alloc] init];
        [disCountOrder.discountOrderArray addObject:[_dataArray objectAtIndex:button.tag - 200]];

        [self.navigationController pushViewController:disCountOrder animated:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_searchText resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [_searchText resignFirstResponder];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
