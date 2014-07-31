//
//  AutoPayViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-5-30.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoPayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (IBAction)nextButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *danyuanBtn;
@property (weak, nonatomic) IBOutlet UIButton *roomBtn;

- (IBAction)danyuanClick:(id)sender;
- (IBAction)roomClick:(id)sender;

@property (nonatomic, strong) NSMutableString *unitRoom;

@property (nonatomic) int rid;

@end
