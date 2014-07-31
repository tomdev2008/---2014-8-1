//
//  SendMessageViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-26.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "SendMessageViewController.h"
#import "MyNavigationBar.h"
#import "AppDelegate.h"
#import "SendmessageCell.h"
#import "DownLoadManager.h"
#import "GroupSetViewController.h"
#import "PhotosPicker.h"
#import "ZL_INTERFACE.h"
#import "ZL_CONST.h"
#import "FaceView.h"
#import "LoadingView.h"
#import "lame.h"

@interface SendMessageViewController ()

@end

@implementation SendMessageViewController
{
    AppDelegate *_app;
    DownLoadManager *_dm;
    UITextField *_textField;
    UITableView *_tableView;
    UIView *_backView;
    UIView *_photoView;
    NSMutableArray *_messageArray;  //  消息数组
    int _userType;  // 用户类型
    BOOL _isHide;   // 点击隐藏下面的。
    NSString *speakStr; // 语音
    FaceView *faceView;
    LoadingView *_loadingView;
    NSMutableString *mstr;  // 追加字符串
    
    UIImage *selectImage;
}

@synthesize player;
@synthesize playButton;
@synthesize recordedFile;
@synthesize recorder;

- (void)viewWillAppear:(BOOL)animated
{
    _app = [UIApplication sharedApplication].delegate;
    _app.mtb.hidden = YES;
    
    _photoView.frame = CGRectMake(0, isRetina.size.height>480?568+120:480+120, 320,120);
    _backView.frame = CGRectMake(0, 64, 320, _backView.frame.size.height);
    faceView.frame = CGRectMake(0, 568, 320, 120);
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.hidesBottomBarWhenPushed = YES; // Custom initialization
    }
    return self;
}

- (void)createNavigation
{
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, isRetina.size.height>480?568-64:480-64)];
    [self.view addSubview:_backView];
    _messageArray = [[NSMutableArray alloc] init];
    _userType = 0;  // 初始化用户类型
    mstr = [[NSMutableString alloc] init];
    _isHide = NO;
    _dm = [DownLoadManager shareDownLoadManager];
    _dm.isFirst = 1;

    self.navigationController.navigationBar.hidden = YES;
    
    NSString *str = nil;
    if(self.speakType == 0)
    {
        str = nil;
    }
    else
    {
        str = @"设置.png";
    }
    
    MyNavigationBar *mnb = [[MyNavigationBar alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?0:20, 320, 44)];
    [mnb createMyNavigationBarWithBackGroundImage:@"top3.png" andTitleViewImage:nil andtTitleLabel:_name andLeftButtonImage:@"back.png" andRightButtonImage:str andSEL:@selector(backClick:) andClass:self];
    [self.view addSubview:mnb];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeKeyBoard:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
}
- (void)didChangeKeyBoard:(NSNotification *)noti
{
    CGRect kdyFrame = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _backView.frame = CGRectMake(0, kdyFrame.origin.y - _backView.frame.size.height, _backView.frame.size.width, _backView.frame.size.height);
}

- (void)createLoadView
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createLoadingView:YES andAlpha:1.0];
}

// 加载聊天信息
- (void)loadingMessage
{
    if(_speakType == 0) // 单聊
    {
        [self getMessageWithFrom_Id:_userId];
    }
    else    // 群聊
    {
        [self getMessageWithGroupId:_dm.groupId];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self loadingMessage];
    [self createTableView];
    [self createSpeakView];
    [self createPhotoAndSoundAndSmile];
    [self createLoadView];
}


#pragma mark - UITableView
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,is_IPHONE_6?-20:0, 320, isRetina.size.height>480?568-64-50:480-64-50) style:UITableViewStylePlain];
    //_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, 320,0)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_backView addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_messageArray.count > 0)
    {
        return _messageArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SendmessageCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.messageLable.frame.size.height+90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = [NSString stringWithFormat:@"Cell%d",indexPath.row];
    SendmessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[SendmessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;;
    if(_messageArray.count > 0)
    {
        Message *message = [_messageArray objectAtIndex:indexPath.row];
        if([message.msgType isEqualToString:@"0"])
        {
            
            cell.contentType = 0;   // 文字
            
            NSArray *array = [NSArray arrayWithObjects:
                              @"[f000]",@"[f001]",@"[f002]",@"[f003]",@"[f004]",@"[f005]",@"[f006]"
                              ,@"[f007]",@"[f008]",@"[f009]",@"[f010]",@"[f011]",@"[f012]",@"[f013]"
                              ,@"[f014]",@"[f015]",@"[f016]",@"[f017]",@"[f018]",@"[f019]",@"[f020]",@"[f021]"
                              ,@"[f022]",@"[f023]",@"[f024]",@"[f025]",@"[f026]",@"[f027]",nil];
            
            BOOL isFind = NO;
            for(int i = 0; i < 28; i ++)
            {
                NSString *str = [array objectAtIndex:i];
                if([message.msgContent rangeOfString:str].location != NSNotFound)
                {
                    isFind = YES;
                    break;
                }
            }
            if(isFind)
            {
                cell.richTextView.text = message.msgContent;
            }
            else
            {
                cell.messageLable.text = message.msgContent;
            }
            
            
        }
        else if([message.msgType isEqualToString:@"1"])
        {
            cell.contentType = 1;   // 图片
            if(message.msgContent == nil)
            {
                cell.photoImage.image = message.image;
            }
            else
            {
                [cell.photoImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,message.msgContent]] placeholderImage:[UIImage imageNamed:@"loading.gif"]];
            }
        }
        else if([message.msgType isEqualToString:@"2"])
        {
            cell.contentType = 2;   // 语音
        }
        else if([message.msgType isEqualToString:@"3"])
        {
            cell.contentType = 3;   // 转发
            cell.messageLable.text = message.msgContent;
            [cell.photoImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,message.userFace]]];
        }
        
        // 加载头像
        if([message.senderId isEqualToString:_dm.myUserId])
        {
            cell.UserType = 0;
            [cell.headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,_dm.myUserFace]]];
        }
        else
        {
            cell.UserType = 1;
            [cell.headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,_userFace]]];
        }
        if(message.msgSend_Time.length > 0)
        {
            cell.timeLable.text = message.msgSend_Time;
        }
        [cell setIntroductionText:message.msgContent];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:0.27 animations:^{
        faceView.frame = CGRectMake(0, 568, 320, 120);
    }];
    Message *message = [_messageArray objectAtIndex:indexPath.row];
    if([message.msgType isEqualToString:@"2"])
    {
        if([player isPlaying])
        {
            [player pause];
        }
        else
        {
            NSData *data;
            if(message.msgId != nil)
            {
                data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ZL_URLUpload,message.msgContent]]];
                
                //[data writeToFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/downloadFile.amr"] atomically:YES];
            }
            else
            {
                data = message.voiceData;
            }
            AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
            self.player = audioPlayer;
            self.player.volume = 1.0f;
            if(self.player == nil)
            {
                NSLog(@"player是 空");
            }
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
            player.delegate = self;
            [player play];
        }
    }
}

// 滚动到当前行
- (void)tableViewScrollCurrentIndexPath
{
    if(_messageArray.count > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_messageArray.count -1 inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark - 点击各种按钮、输入框
// 点击发送按钮   点击新增按钮
- (void)btnClick:(UIButton *)button
{
    if(button.tag == 20 && _speakType == 0)
    {
        [self sendMessageToUser:_userId andContent:_textField.text andType:0];
    }
    else if (button.tag == 20 && _speakType == 1)
    {
        [self sendMessageToGroup:_dm.groupId andContent:_textField.text];
    }
    else if(button.tag == 30)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if(button.tag == 40)
    {
        // 点击加号
        if(!_isHide)
        {
            [UIView animateWithDuration:0.25 animations:^{
                _photoView.frame = CGRectMake(0, isRetina.size.height>480?is_IPHONE_6?568-140:568-120:is_IPHONE_6?480-140:480-120, 320, 120);
                _backView.frame = CGRectMake(0, -55, 320, _backView.frame.size.height);
                [_textField resignFirstResponder];
            }];
            _isHide = YES;
        }
        else
        {
            [_textField resignFirstResponder];
            [UIView animateWithDuration:0.25 animations:^{
                _photoView.frame = CGRectMake(0, isRetina.size.height>480?568+120:480+120, 320,120);
                _backView.frame = CGRectMake(0, 64, 320, _backView.frame.size.height);
                faceView.frame = CGRectMake(0, 568, 320, 120);
            }];
            _isHide = NO;
        }
    }
    else if(button.tag == 50)
    {
        // 照片
        [self createViewPhotoOrCarmea];
    }
    else if(button.tag == 52)
    {
        faceView = [[FaceView alloc] initWithFrame:CGRectMake(0,isRetina.size.height>480?is_IPHONE_6?568-150:568-130:is_IPHONE_6?480-150:480-130,320,150)];
        [faceView showFaceViewWithShow:NO andClassObject:self andSEL:@selector(faceClick:)];
        faceView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        [self.view addSubview:faceView];
    }
}
- (void)backClick:(UIButton *)button
{
    if(button.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        GroupSetViewController *group = [[GroupSetViewController alloc] init];
        group.groupId = _userId;
        [self.navigationController pushViewController:group animated:YES];
    }
}

- (void)textChange
{
    [UIView animateWithDuration:0.27 animations:^{
        _backView.frame = CGRectMake(0, -150, 320, _backView.frame.size.height);
    }];
}
#pragma mark - 调用相册 语音 照片

// 判断是照相还是打开相册
- (void)createViewPhotoOrCarmea
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择要上传图片的方式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相机",@"相册", nil];
    [alert show];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(_speakType == 0) // 是否单聊
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_dm sendMessageWithId:_userId andObject:image andType:1 andFrom_Id:_dm.myUserId andContentType:0];
            [_dm setSendMessageSuccess:^{

            }];
        });
       
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_dm sendMessageWithId:_userId andObject:image andType:1 andFrom_Id:_dm.myUserId andContentType:1];
            [_dm setSendMessageSuccess:^{
               
            }];
        });
    }
    NSLog(@"正在上传图片.......");
   [self dismissViewControllerAnimated:YES completion:^{
       Message *message = [[Message alloc] init];
       message.image = image;
       message.msgType = @"1";
       message.senderId = _dm.myUserId;
       [_messageArray addObject:message];
       [_tableView reloadData];
   }];
    
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
        
        [PhotosPicker showPhotosPickerUsingCompeletionBlock:^(NSArray *selectedPhotos) {
            if(selectedPhotos.count > 0)
            {
                selectImage = selectedPhotos[0];
                __block SendMessageViewController *blockSelf = self;
                if(_speakType == 0)
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [_dm sendMessageWithId:_userId andObject:selectedPhotos[0] andType:1 andFrom_Id:_dm.myUserId andContentType:0];
                        [_dm setSendMessageSuccess:^{

                        }];
                    });
                    Message *message = [[Message alloc] init];
                    message.image = selectImage;
                    message.msgType = @"1";
                    message.senderId = _dm.myUserId;
                    [_messageArray addObject:message];
                    [_tableView reloadData];
                    [blockSelf tableViewScrollCurrentIndexPath];
                }
                else
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [_dm sendMessageWithId:_userId andObject:selectedPhotos[0] andType:1 andFrom_Id:_dm.myUserId andContentType:1];
                        [_dm setSendMessageSuccess:^{
                            
                        }];
                    });
                    Message *message = [[Message alloc] init];
                    message.image = selectImage;
                    message.msgType = @"1";
                    message.senderId = _dm.myUserId;
                    [_messageArray addObject:message];
                    [_tableView reloadData];
                    [blockSelf tableViewScrollCurrentIndexPath];
                }
                
            }
            else    // 没有数据的时候返回
            {
                return;
            }
        } withRootViewController:self];
    }
}


- (void)createPhoto
{
//    __block id obj = nil;
    
    [PhotosPicker showPhotosPickerUsingCompeletionBlock:^(NSArray *selectedPhotos) {
        if(selectedPhotos.count > 0)
        {
            __block SendMessageViewController *blockSelf = self;
            if(_speakType == 0)
            {
                [_dm sendMessageWithId:_userId andObject:selectedPhotos[0] andType:1 andFrom_Id:_dm.myUserId andContentType:0];
            }
            else
            {
                [_dm sendMessageWithId:_userId andObject:selectedPhotos[0] andType:1 andFrom_Id:_dm.myUserId andContentType:1];

            }
            [_dm setSendMessageSuccess:^{
                [blockSelf->_messageArray removeAllObjects];
                [blockSelf getMessageWithFrom_Id:blockSelf->_userId];
            }];
        }
        else    // 没有数据的时候返回
        {
            return;
        }
    } withRootViewController:self];
}


#pragma mark - 加载历史消息
// 加载历史消息
- (void)getMessageWithFrom_Id:(NSString *)from_id
{
    __block SendMessageViewController *blockSelf = self;
    [_dm getMessageRepastWithFrom_Id:from_id];
    [_dm setMessageRepastBlock:^(NSArray *array) {
        [blockSelf -> _messageArray addObjectsFromArray:array];
        [blockSelf->_tableView reloadData];
        [blockSelf tableViewScrollCurrentIndexPath];
        [blockSelf -> _loadingView loadingViewDispear:0];
    }];
}
// 加载历史消息 (群聊)
- (void)getMessageWithGroupId:(NSString *)gid
{
    __block SendMessageViewController *blockSelf = self;
    [_dm getGroupMessageWithGid:gid];
    [_dm setMessageRepastBlock:^(NSArray *array) {
        [blockSelf -> _messageArray addObjectsFromArray:array];
        [blockSelf -> _tableView reloadData];
        // 滑动到当前行
        [blockSelf tableViewScrollCurrentIndexPath];
        [blockSelf -> _loadingView loadingViewDispear:0];
    }];
    
}
#pragma mark - 发送消息
// 发送聊天信息(单聊)  文本
- (void)sendMessageToUser:(NSString *)toId andContent:(id)content andType:(int)type
{
    mstr = nil;
    _textField.text = nil;
    __block SendMessageViewController *blockSelf = self;
    [_dm sendMessageWithToId:toId andContent:content andType:type];
    [_dm setSendMessageSuccess:^{
        [blockSelf->_messageArray removeAllObjects];
        [blockSelf getMessageWithFrom_Id:toId];
        // 发送成功
    }];
}
// 发送聊天信息（群聊）
- (void)sendMessageToGroup:(NSString *)gid andContent:(id)content
{
    __block SendMessageViewController *blockSelf = self;
    [_dm sendMessageWithGid:gid andContent:content andType:0];
    [_dm setSendMessageSuccess:^{
        [blockSelf -> _messageArray removeAllObjects];
        [blockSelf getMessageWithGroupId:gid];
    }];
    
}
// 创建聊天
- (void)createSpeakView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, is_IPHONE_6?_backView.frame.size.height-70:_backView.frame.size.height-50, 320,50)];
    view.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    [_backView addSubview:view];
    
    // 线条
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    lineImage.image = [UIImage imageNamed:@"line.png"];
    lineImage.alpha = 0.4;
    [view addSubview:lineImage];
    
    // 加号
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(10, 10, 30, 30);
    addBtn.tag = 40;
    [addBtn setBackgroundImage:[UIImage imageNamed:@"addContent.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];
    // 框
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(55,10, 200, 30)];
    _textField.textColor = [UIColor lightGrayColor];
    _textField.font = [UIFont systemFontOfSize:15];
    [_textField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingDidBegin];
    [_textField setBorderStyle:UITextBorderStyleRoundedRect];
    _textField.delegate = self;
    [view addSubview:_textField];
    
    // 发送
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(270, 10, 50, 30);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    sendBtn.tag = 20;
    [sendBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sendBtn];
}
// 创建弹出的照片 语音和表情功能
- (void)createPhotoAndSoundAndSmile
{
    _photoView = [[UIView alloc] init];
    _photoView.userInteractionEnabled = YES;
    _photoView.frame = CGRectMake(0, isRetina.size.height>480?is_IPHONE_6?568+100:568+120:is_IPHONE_6?480+100:480+120, 320,120);
    [_photoView setBackgroundColor:[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f]];
    [self.view addSubview:_photoView];
    
    // 线条
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    lineImage.image = [UIImage imageNamed:@"line.png"];
    lineImage.alpha = 0.4;
    [_photoView addSubview:lineImage];
    
    UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pBtn.frame = CGRectMake(20, 20, 80, 80);
    [pBtn setBackgroundImage:[UIImage imageNamed:@"对话聊天01.png"] forState:UIControlStateNormal];
    pBtn.tag = 50;
    [pBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_photoView addSubview:pBtn];
    
    UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton = mBtn;
    playButton.frame = CGRectMake(120, 20, 80, 80);
    [playButton setBackgroundImage:[UIImage imageNamed:@"对话聊天02.png"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [playButton addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside];
    [_photoView addSubview:playButton];
    
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/downloadFile.caf"];
    self.recordedFile = [[NSURL alloc] initWithString:path];
    
    [_photoView addSubview:playButton];
    
    
    
    UIButton *fBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fBtn.frame = CGRectMake(220, 20, 80, 80);
    [fBtn setBackgroundImage:[UIImage imageNamed:@"对话聊天03.png"] forState:UIControlStateNormal];
    fBtn.tag = 52;
    [fBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_photoView addSubview:fBtn];
    
    
}
#pragma mark - 语音聊天
// 按住不松的动画
- (void)createRecodeSpeak
{
    _loadingView = [[LoadingView alloc] init];
    _loadingView.frame = CGRectMake((320-80)/2, (isRetina.size.height>480?568:480-30)/2-20, 80, 80);
    [self.view addSubview:_loadingView];
    [_loadingView createRecodeBackView:YES andAlpha:1];
}

- (void)touchDown
{
    session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(session == nil)
    {
        NSLog(@"%@",[sessionError description]);
    }
    else
    {
        [session setActive:YES error:nil];
    }
    // 录音设置
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [settings setValue :[NSNumber numberWithFloat:11025] forKey: AVSampleRateKey];//44100.0
    //通道数
    [settings setValue :[NSNumber numberWithInt:1] forKey: AVNumberOfChannelsKey];
    //线性采样位数
   // [settings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:nil error:nil];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    [recorder record];
    [self createRecodeSpeak];
}
- (void)touchUp
{
    [self audio_PCMtoMP3];
    NSLog(@"%@",self.recordedFile);
    NSLog(@"%d",[[NSData dataWithContentsOfURL:self.recordedFile] length]);
    [_loadingView loadingViewDispear:1.0];
    BOOL needSend = recorder.currentTime > 1;
    NSLog(@"currentTime:%f",recorder.currentTime);
    [recorder stop];
    
    
    if(recorder)
    {
        recorder = nil;
    }
    if(_speakType == 0)
    {
        if(needSend)
        {
            [_dm sendMessageWithId:_userId andObject:self.recordedFile andType:2 andFrom_Id:_dm.myUserId andContentType:0];
            // 发送成功
            [_dm setSendMessageSuccess:^{
            }];
            Message *message = [[Message alloc] init];
            message.voiceData = [[NSData alloc] initWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/downloadFile.mp3"]];
            message.senderId = _dm.myUserId;
            message.msgType = @"2";
            message.msgContent = @"语音.caf";
            [_messageArray addObject:message];
            [_tableView reloadData];
        }
    }
    else
    {
        if(needSend)
        {
            [_dm sendMessageWithId:_userId andObject:self.recordedFile andType:2 andFrom_Id:_dm.myUserId andContentType:1];
            // 发送成功
            [_dm setSendMessageSuccess:^{
            }];
            
            Message *message = [[Message alloc] init];
            message.voiceData = [[NSData alloc] initWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/downloadFile.mp3"]];
            NSLog(@"%@",[NSHomeDirectory() stringByAppendingString:@"/Documents/downloadFile.mp3"]);
            message.senderId = _dm.myUserId;
            message.msgType = @"2";
            message.msgContent = @"语音.caf";
            [_messageArray addObject:message];
            [_tableView reloadData];
        }
    }
    [self tableViewScrollCurrentIndexPath];
}

- (void)audio_PCMtoMP3
{
    NSString *cafFilePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/downloadFile.caf"];
    NSString *mp3FilePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/downloadFile.mp3"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3FilePath error:nil])
    {
        NSLog(@"删除");
    }
    @try {
        int read, write;
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");
        fseek(pcm, 4*1024, SEEK_CUR);
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");
        const int PCM_SIZE = 8129;
        const int MP3_SIZE = 8129;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 22050);
        lame_set_num_channels(lame, 1);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        do
        {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if(read == 0)
            {
                write = lame_encode_flush(lame,mp3_buffer,MP3_SIZE);
            }
            else
            {
                write = lame_encode_buffer_interleaved(lame,pcm_buffer,read,mp3_buffer,MP3_SIZE);
            }
            fwrite(mp3_buffer, write, 1, mp3);
        }
        while (read != 0);
        {
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally
    {
        NSLog(@"data:%@  data:%lu",[NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/downloadFile.mp3"]],(unsigned long)[[NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/downloadFile.mp3"]] length]);
        
    }
}



#pragma mark - 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        _photoView.frame = CGRectMake(0, isRetina.size.height>480?568+120:480+120, 320,120);
        _backView.frame = CGRectMake(0, 64, 320, _backView.frame.size.height);
        faceView.frame = CGRectMake(0, 568, 320, 120);
    }];
    return [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 点击表情
- (void)faceClick:(UIButton *)button
{
    faceView.faceName = [[[faceView dataArray] objectAtIndex:button.tag-10] substringFromIndex:[[faceView.dataArray objectAtIndex:button.tag-10] length]-8];
     _textField.text =[NSString stringWithFormat:@"%@%@",_textField.text,[faceView getFaceName]];
}


@end
