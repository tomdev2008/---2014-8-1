//
//  PersonInfoViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "UpdatePersonInfoViewController.h"
#import "DownLoadManager.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "PhotosPicker.h"

@interface PersonInfoViewController ()

@end

@implementation PersonInfoViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
    NSMutableArray *_dataArray;
    User *_user;
    LoadingView *_loadingView;
    UIImagePickerController *_imagePc;
    NSMutableArray *_imageArray;
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

- (void)viewDidAppear:(BOOL)animated
{
    __block PersonInfoViewController *blockSelf=  self;
    _dm = [DownLoadManager shareDownLoadManager];
    [_dm getMyUserInfo];
    [_dm setGetMyUserInfoBlock:^(User *user) {
        blockSelf -> _user = user;
        [blockSelf reloadData];
        [blockSelf -> _loadingView loadingViewDispear:0];
    }];
    
    NSLog(@"-------%@-----%@",_dm.status,@"没有数据");
    if([_dm.status isEqualToString:@"400"])
    {
        [_loadingView loadingViewDispear:0.0];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.tabBarController.tabBar.hidden = YES;
    // 初始化
    _imageArray = [[NSMutableArray alloc] init];

    _dataArray = [[NSMutableArray alloc] init];
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top.png" andTitleViewImage:nil andtTitleLabel:@"个人资料" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(btnClick) andClass:self];
    [self.view addSubview:mnb];
    [self createLoadView];
    
}
- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
}


- (void)reloadData
{
    [_headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,_dm.myUserFace]]];
    [_nickNameLabel setTitle:_user.userNickName forState:UIControlStateNormal];
    if([_user.userSex isEqualToString:@"0"])
    {
        [_sexLabel setTitle:@"男" forState:UIControlStateNormal];
    }
    else
    {
        [_sexLabel setTitle:@"女" forState:UIControlStateNormal];
    }
    [_professionLabel setTitle:_user.userProfession  forState:UIControlStateNormal];
    [_trueNameLabel setTitle:_user.userName forState:UIControlStateNormal];
    [_phoneLabel setTitle:_user.userPhone forState:UIControlStateNormal];
}

- (void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender
{
    UIButton *button = sender;
    UpdatePersonInfoViewController *update = [[UpdatePersonInfoViewController alloc] init];
    update.tagNumber = button.tag - 101;
    NSLog(@"%d",button.tag - 101);
    [self.navigationController pushViewController:update animated:NO];
}

// 判断是照相还是打开相册
- (void)createViewPhotoOrCarmea
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择要上传图片的方式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相机",@"相册", nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }
    else if(buttonIndex == 2)
    {
        // 调用系统相册
        [_imageArray removeAllObjects];
        __block PersonInfoViewController *blockSelf = self;
        [PhotosPicker showPhotosPickerUsingCompeletionBlock:^(NSArray *selectedPhotos) {
            [blockSelf -> _imageArray addObjectsFromArray:selectedPhotos];
            if (selectedPhotos.count > 0)
            {
                [_dm uploadImage:[selectedPhotos objectAtIndex:0] andType:2];
                [self createLoadView];

                    [_dm setUploadImageSuccess:^(NSString *name) {
                        [blockSelf -> _dm updatePersonInfoWithfield:@"face" andValue:name];
                        [blockSelf -> _dm setUpdatePersonInfoSuccessBlock:^{
                            [_headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,name]]];
                            [_loadingView loadingViewDispear:0];
                             _dm.myUserFace = name;
                        }];
                }];
            }
            
        } withRootViewController:self];
    }
}

// 上传照片

// 拍摄完毕之后调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(picker != _imagePc)
    {
        // 得到图片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // 图片存入相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
    else
    {
        [NSThread sleepForTimeInterval:2.0];
        //[MHImagePickerMutilSelector showInViewController:self];
    }
}

// 点击取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (IBAction)changeImage:(id)sender
{
    [self createViewPhotoOrCarmea];
}
@end
