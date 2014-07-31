//
//  CommentViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-5-29.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "CommentViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "DownLoadManager.h"
#define BOOKMARK_WORD_LIMIT 140

@interface CommentViewController ()

@end

@implementation CommentViewController
{
    AppDelegate *_app;
    UITextView *_textView;
    DownLoadManager *_dm;
    NSMutableArray *_dataArray;
    LoadingView *_loadingView;
    
    NSMutableString *mstr;
}
@synthesize faceView;

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
- (void)viewWillAppear:(BOOL)animated
{
    _app = [UIApplication sharedApplication].delegate;
    _app.mtb.hidden =YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    _app.mtb.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dm = [DownLoadManager shareDownLoadManager];
    _dataArray = [[NSMutableArray alloc] init];
    mstr = [[NSMutableString alloc] init];
    
    self.navigationController.navigationBar.hidden = YES;
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:@"评论" andLeftButtonImage:@"back.png" andRightButtonImage:nil andSEL:@selector(bbiItem) andClass:self];
    [self.view addSubview:mnb];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 80, 300, 100)];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    imgView.image = [UIImage imageNamed:@"发布邻居说背景.png"];
    _textView.font = [UIFont systemFontOfSize:15];
    [_textView addSubview: imgView];
    [_textView sendSubviewToBack: imgView];
    [self.view addSubview:_textView];
}
- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   [_textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // 判断加上的字符是否超越界限
    NSString *str = [NSString stringWithFormat:@"%@%@",_textView.text,text];
    if(str.length > BOOKMARK_WORD_LIMIT)
    {
        _textView.text = [_textView.text substringToIndex:BOOKMARK_WORD_LIMIT];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    // 用于判断联想输入
    if(_textView.text.length > BOOKMARK_WORD_LIMIT)
    {
        _textView.text = [textView.text substringToIndex:BOOKMARK_WORD_LIMIT];
    }
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

// 发布评论
- (IBAction)forwordClick:(id)sender
{
    [self createLoadView];
    __block CommentViewController *blockSelf = self;
    [_dm sendCommentWithMid:self.mid andPid:_pid andContent:_textView.text];
    [_dm setSendMessageSuccess:^{
        [blockSelf.navigationController popViewControllerAnimated:YES];
        [blockSelf -> _loadingView loadingViewDispear:0];
    }];
}

- (void)faceClicks:(UIButton *)button
{
    faceView.faceName = [[[faceView dataArray] objectAtIndex:button.tag-10] substringFromIndex:[[faceView.dataArray objectAtIndex:button.tag-10] length]-8];
    [mstr appendString:[faceView getFaceName]];
    NSLog(@"%@",mstr);
    _textView.text = mstr;
}

- (IBAction)faceClick:(id)sender
{
    
    faceView = [[FaceView alloc] initWithFrame:CGRectMake(0,isRetina.size.height>480?is_IPHONE_6?568-150:568-130:is_IPHONE_6?480-150:480-130,320,150)];
    [faceView showFaceViewWithShow:NO andClassObject:self andSEL:@selector(faceClicks:)];
    faceView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    _textView.text =[NSString stringWithFormat:@"%@%@",_textView.text,[faceView getFaceName]];
    [self.view addSubview:faceView];
    [_textView resignFirstResponder];

}
@end
