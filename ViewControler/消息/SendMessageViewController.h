//
//  SendMessageViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-26.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TQRichTextView.h"

@interface SendMessageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AVAudioPlayerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TQRichTextViewDelegate, AVAudioRecorderDelegate>
{
    UIButton *playButton;
    AVAudioSession *session;
    
    NSURL *recordedFile;
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
}
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSURL *recordedFile;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userFace;

@property (nonatomic) int speakType;    // 聊天类型  多人 1 单聊 0
@property (nonatomic, strong) NSMutableArray *personArray;



@end
