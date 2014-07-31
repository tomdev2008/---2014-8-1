//
//  PersonInfoViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInfoViewController : UIViewController <UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (IBAction)btnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UIButton *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *sexLabel;
@property (weak, nonatomic) IBOutlet UIButton *professionLabel;
@property (weak, nonatomic) IBOutlet UIButton *trueNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneLabel;

- (IBAction)changeImage:(id)sender;

@end
