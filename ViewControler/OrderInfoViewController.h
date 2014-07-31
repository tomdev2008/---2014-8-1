//
//  OrderInfoViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-24.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoViewController : UIViewController

@property (nonatomic) int osid;
@property (nonatomic) int orderType;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollVIew;
- (IBAction)orderClick:(id)sender;
- (IBAction)tgrClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *orderCodeLable;
@property (weak, nonatomic) IBOutlet UILabel *stateLable;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLable;
@property (weak, nonatomic) IBOutlet UIImageView *serverImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UILabel *serverTimeLable;


@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end
