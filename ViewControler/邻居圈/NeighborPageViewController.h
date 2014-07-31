//
//  NeighborPageViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-7-7.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeighborPageViewController : UIViewController

@property (nonatomic, strong) NSString *neighobrId;
@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtn;


@property (weak, nonatomic) IBOutlet UILabel *userNickName;
@property (weak, nonatomic) IBOutlet UIImageView *userFace;
@property (weak, nonatomic) IBOutlet UILabel *userSex;
@property (weak, nonatomic) IBOutlet UILabel *userAge;
@property (weak, nonatomic) IBOutlet UILabel *userProfession;
@property (weak, nonatomic) IBOutlet UILabel *userFavorite;
@property (weak, nonatomic) IBOutlet UILabel *userContent;
@property (weak, nonatomic) IBOutlet UILabel *userphone;
@property (weak, nonatomic) IBOutlet UILabel *userRealName;
@property (weak, nonatomic) IBOutlet UILabel *userSay;
- (IBAction)sendMessageClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end
