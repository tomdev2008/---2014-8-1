//
//  AddressBookViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-30.
//  Copyright (c) 2014年 赵恒. All rights reserved.

//  通讯录

#import "AddressBookViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "DownLoadManager.h"
#import "AddressBookCell.h"
#import "SendMessageViewController.h"
#import "MessageViewController.h"

@interface AddressBookViewController ()

@end

@implementation AddressBookViewController
{
    AppDelegate *_app;
    UITableView *_tableView;
    DownLoadManager *_dm;
    NSMutableArray *_dataArray;
    NSMutableArray *_selectArray;
    NSMutableArray *_selectArray_User;
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

- (void)createNavigation
{
    // 初始化 下载数组
    _dm = [DownLoadManager shareDownLoadManager];
    _dm.isFirst = 1;

    // 选中的数组
    _selectArray = [[NSMutableArray alloc] init];
    // 选中的User
    _selectArray_User = [[NSMutableArray alloc] init];
    __block AddressBookViewController *blockSelf = self;
    _dataArray = [[NSMutableArray alloc] init];
    
    if(self.comeType == 0 || self.comeType == 2)
    {
        [_dm getAddressBookWithCid:[NSString stringWithFormat:@"%d",_dm.communityId] andGid:@""];
        [_dm setAddressBookBlock:^(NSArray *array) {
            [blockSelf -> _dataArray addObjectsFromArray:array];
            [blockSelf -> _tableView reloadData];
            [blockSelf -> _loadingView loadingViewDispear:0];
        }];
    }
    else if(self.comeType == 1)
    {
        [_dm getAddressBookWithCid:[NSString stringWithFormat:@"%d",_dm.communityId] andGid:self.groupId];
        [_dm setAddressBookBlock:^(NSArray *array) {
            [blockSelf -> _dataArray addObjectsFromArray:array];
            [blockSelf -> _tableView reloadData];
        }];
    }

    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"通讯录" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick:) andClass:self];
    [self.view addSubview:mnb];
    
}

- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self createSearchAndOkView];
    [self createTableView];
    [self createLoadView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_dataArray.count > 0)
    {
        return _dataArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [[AddressBookCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    if(_dataArray.count > 0)
    {
        User *user = [_dataArray objectAtIndex:indexPath.row];
        [cell.headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,user.userFace]]];
        cell.nameLable.text = user.userName;
        [cell setChecked:user.isChecked];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = [_dataArray objectAtIndex:indexPath.row];
    AddressBookCell *cell = (AddressBookCell *)[tableView cellForRowAtIndexPath:indexPath];
    user.isChecked = !user.isChecked;
    [cell setChecked:user.isChecked];
    if(user.isChecked)
    {
        [_selectArray addObject: user.userId];
        [_selectArray_User addObject:user];
    }
    else
    {
        [_selectArray removeObject:user.userId];
        [_selectArray_User removeObject:user];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?114-20:114, 320, isRetina.size.height>480?568-114-40:480-114-40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}


- (void)createSearchAndOkView
{
    UIView *searchView = [[UIView alloc] init];
    searchView.frame = CGRectMake(0, is_IPHONE_6?44:64, 320, 50);
    searchView.backgroundColor = [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.00f];
    [self.view addSubview:searchView];
    
    UITextField *searchText = [[UITextField alloc] init];
    searchText.frame = CGRectMake(30, 10, 260, 30);
    searchText.borderStyle = UITextBorderStyleRoundedRect;
    searchText.placeholder = @"输入关键字";
    searchText.font = [UIFont boldSystemFontOfSize:13];
    searchText.delegate = self;
    [searchView addSubview:searchText];
    
    UIView *okView = [[UIView alloc] init];
    okView.frame = CGRectMake(0, isRetina.size.height>480?568-40:480-40, 320, 40);
    [self.view addSubview:okView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(320-90, is_IPHONE_6?-10:5, 80, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"门栋号选择_07.png"] forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.tag = 100;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [okView addSubview:button];
}

- (void)btnClick:(UIButton *)button
{
    if(button.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if(_selectArray_User.count == 0)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择至少一个用户" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        MessageViewController *message = [[MessageViewController alloc] init];
        if(self.comeType == 0)
        {
            // 创建群组
            NSLog(@"%@",_selectArray);
            __block AddressBookViewController *blockSelf = self;
            //zNSLog(@"")
            [_dm createGroupMessage:_selectArray];
            [_dm setGroupMessageSuccess:^{
                // 创建群组成功
                [blockSelf.navigationController pushViewController:message animated:YES];
            }];
        }
        else if(self.comeType == 1)
        {
            NSLog(@"%@",_selectArray);
            // 添加人数
            NSMutableString *MID = [[NSMutableString alloc] init];
            for(int i = 0; i < _selectArray.count; i ++)
            {
                NSString *midstr = [NSString stringWithFormat:@"%@,",[_selectArray objectAtIndex:i]];
                [MID appendString:midstr];
            }
            NSRange range = NSMakeRange(0, MID.length-1);
            NSString *mids = [[NSString stringWithString:MID] substringWithRange:range];
            __block AddressBookViewController *blockSelf = self;
            [_dm addUserWithGid:self.groupId andUids:mids];
            [_dm setSendMessageSuccess:^{
                [blockSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
        else if(self.comeType == 2) // 转发邻居说
        {
            NSMutableString *MID = [[NSMutableString alloc] init];
            for(int i = 0; i < _selectArray.count; i ++)
            {
                NSString *midstr = [NSString stringWithFormat:@"%@,",[_selectArray objectAtIndex:i]];
                [MID appendString:midstr];
            }
            NSRange range = NSMakeRange(0, MID.length-1);
            NSString *mids = [[NSString stringWithString:MID] substringWithRange:range];
            __block AddressBookViewController *blockSelf = self;
            [_dm forwardNeighborToMessage:@"1" andPid:self.groupId andTo_Id:mids];
            [_dm setSendMessageSuccess:^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"转发邻居说成功" delegate:blockSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }];
        }
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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


@end
