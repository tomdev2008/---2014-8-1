//
//  CommentViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-5-29.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"

@interface CommentViewController : UIViewController

- (IBAction)forwordClick:(id)sender;
@property (nonatomic, strong) NSString *mid;    // 模块ID 1 邻居说 2 活动 3 优惠券 4 服务
@property (nonatomic, strong) NSString *pid;    // 对象ID;
@property (nonatomic, strong) FaceView *faceView;
- (IBAction)faceClick:(id)sender;


@end
