//
//  MineViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineViewController : UIViewController 

- (IBAction)myServerClick:(id)sender;

- (IBAction)myPointClick:(id)sender;

- (IBAction)mySaleCarClick:(id)sender;

- (IBAction)changePwdClick:(id)sender;

- (IBAction)zbarClick:(id)sender;

- (IBAction)myPersonInfoClick:(id)sender;

- (IBAction)myPrivateClick:(id)sender;

@property (nonatomic, strong) UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIView *shopPersonView;


@end
