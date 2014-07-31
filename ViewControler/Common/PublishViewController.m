//
//  PublishViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-29.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "PublishViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "ZL_CONST.h"
#import "ZL_INTERFACE.h"
#import "DownLoadManager.h"
#import "PhotosPicker.h"
#define BOOKMARK_WORD_LIMIT 140

@interface PublishViewController ()
{
    BOOL flag;
}

@end

@implementation PublishViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
    UITextView *_textView;
    UIImagePickerController *_imagePc;
    NSMutableArray *_imageArray;
    LoadingView *_loadingView;
    NSMutableString *_mstr;
    NSString *pic_string;   //
    UIImage *photoImage;
    
    UIButton *clickBtn; // 点击收起键盘
}
@synthesize faceView;

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
- (void)viewDidAppear:(BOOL)animated
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 5, 70, 70);
    imageView.image = photoImage;
    _scrollView.frame = CGRectMake(10, 280, 320, 80);
    _scrollView.contentSize = CGSizeMake(80, 70);
    [_scrollView addSubview:imageView];
    if(photoImage != nil)
    {
        [_imageArray addObject:photoImage];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    _app.mtb.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 初始化相册数组
    _imageArray = [[NSMutableArray alloc] init];
    
    _mstr = [[NSMutableString alloc] init]; // 照片名
    pic_string = [[NSString alloc] init];
    _dm = [DownLoadManager shareDownLoadManager];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"发布邻居说" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem) andClass:self];
    [self.view addSubview:mnb];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 80, 300, 150)];
    _textView.delegate = self;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
    imgView.image = [UIImage imageNamed:@"发布邻居说背景.png"];
    [_textView addSubview: imgView];
    _textView.font = [UIFont systemFontOfSize:15];
    [_textView sendSubviewToBack: imgView];
    [self.view addSubview:_textView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 280, 0, 0)];
    _scrollView.contentSize = CGSizeMake(50, 50);
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.bounces = YES;
    _scrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_scrollView];
    
    clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = CGRectMake(320-10-46, 170, 46, 46);
    clickBtn.tag = 220;
    clickBtn.alpha = 0.5;
    clickBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [clickBtn setBackgroundImage:[UIImage imageNamed:@"loadingbg.png"] forState:UIControlStateNormal];
    [clickBtn setTitle:@"隐藏" forState:UIControlStateNormal];
    clickBtn.hidden = YES;
    [clickBtn addTarget:self action:@selector(hideClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickBtn];
    
    flag = YES;
}

- (void)hideClick
{
    [_textView resignFirstResponder];
    clickBtn.hidden = YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    clickBtn.hidden = NO;
}

- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
}

// 判断是照相还是打开相册
- (void)createViewPhotoOrCarmea
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择要上传图片的方式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相机",@"相册", nil];
    alert.tag = 1;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
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
            __block PublishViewController *blockSelf = self;
            [PhotosPicker showPhotosPickerUsingCompeletionBlock:^(NSArray *selectedPhotos) {
                [blockSelf -> _imageArray addObjectsFromArray:selectedPhotos];
                for (UIImageView *item in _scrollView.subviews)
                {
                    [item removeFromSuperview];
                }
                if (selectedPhotos.count > 0)
                {
                    _scrollView.frame = CGRectMake(10, 280, 320, 80);
                    _scrollView.contentSize = CGSizeMake(80*selectedPhotos.count, 70);
                    for(int i = 0; i < selectedPhotos.count; i ++)
                    {
                        UIImageView *imageView = [[UIImageView alloc] init];
                        imageView.frame = CGRectMake(i * (5 + 70), 5, 70, 70);
                        imageView.image = [selectedPhotos objectAtIndex:i];
                        [_scrollView addSubview:imageView];
                    }
                }
                
            } withRootViewController:self];
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//解决图片旋转问题
- (UIImage *)fixOrientation:(UIImage *)image {
    
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// 上传照片

// 拍摄完毕之后调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 得到图片
    photoImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    photoImage = [self fixOrientation:photoImage];
//    NSLog(@"------------>方向：%d", photoImage.imageOrientation);
//    UIImage *image = [UIImage imageWithCGImage:photoImage.CGImage scale:1.0 orientation:UIImageOrientationRight];
//    photoImage = image;
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

// 点击取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)textViewDidChange:(UITextView *)textView
{
    // 用于判断联想输入
    if(_textView.text.length > BOOKMARK_WORD_LIMIT)
    {
        _textView.text = [textView.text substringToIndex:BOOKMARK_WORD_LIMIT];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.27 animations:^{
        faceView.frame = CGRectMake(0, 568, 320, 120);
    }];
    [_textView resignFirstResponder];
}


- (void)bbiItem
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)photoClick:(id)sender
{
    [self createViewPhotoOrCarmea];
}

// 点击表情
- (IBAction)faceClick:(id)sender
{
    if(faceView == nil)
    {
        faceView = [[FaceView alloc] initWithFrame:CGRectMake(0, 568, 320, 120)];
        [self.view addSubview:faceView];
        faceView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];


    }
    [faceView showFaceViewWithShow:NO andClassObject:self andSEL:@selector(faceClicks:)];
    [UIView animateWithDuration:0.25 animations:^{
        faceView.frame = CGRectMake(0,isRetina.size.height>480?is_IPHONE_6?568-150:568-130:is_IPHONE_6?480-150:480-130,320,150);
    }];

}

// 发表
- (IBAction)submitClick:(id)sender
{
    [self createLoadView];
    _faBtn.enabled = NO;
    for(int i = 0; i < _imageArray.count; i ++)
    {
        __block NSString *str = [[NSString alloc] init];
        __block PublishViewController *blockSelf = self;
        [_dm uploadImage:[_imageArray objectAtIndex:i] andType:2];
        [_dm setUploadImageSuccess:^(NSString *name) {
            NSLog(@"上传图片%@成功",name);
            [blockSelf -> _mstr appendString:[NSString stringWithFormat:@"%@,",name]];
            str =  [blockSelf -> _mstr substringToIndex:blockSelf -> _mstr.length-1];
            blockSelf -> pic_string = str;
            NSLog(@"%@",str);
            if ([str componentsSeparatedByString:@","].count == _imageArray.count-1 || _imageArray.count == 1)
            {
                [ _dm sendNeighbor:_textView.text andPic:pic_string andCid:_dm.communityId];
                [_dm setSendMessageSuccess:^{
                    [_loadingView loadingViewDispear:0];
                    UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"发表邻居说成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag = 2;
                    _dm.neiFlag = YES;
                    _faBtn.enabled = YES;
                    [alert show];
                }];
            }
        }];
    }
    if(_imageArray.count <= 0)
    {
        [ _dm sendNeighbor:_textView.text andPic:pic_string andCid:_dm.communityId];
        [_dm setSendMessageSuccess:^{
            [_loadingView loadingViewDispear:0];
            UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"发表邻居说成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 2;
            _dm.neiFlag = YES;
            _faBtn.enabled = YES;
            [alert show];
        }];

    }
    
}


// 点击表情
- (void)faceClicks:(UIButton *)button
{
    faceView.faceName = [[[faceView dataArray] objectAtIndex:button.tag-10] substringFromIndex:[[faceView.dataArray objectAtIndex:button.tag-10] length]-8];
    _textView.text =[NSString stringWithFormat:@"%@%@",_textView.text,[faceView getFaceName]];
    [_textView resignFirstResponder];
}

@end
