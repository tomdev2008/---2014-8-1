//
//  PublishViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-5-29.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"

@interface PublishViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

- (IBAction)photoClick:(id)sender;
- (IBAction)faceClick:(id)sender;
- (IBAction)submitClick:(id)sender;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FaceView *faceView;
@property (weak, nonatomic) IBOutlet UIButton *faBtn;


@end
