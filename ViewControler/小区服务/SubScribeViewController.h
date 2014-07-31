//
//  SubScribeViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-4.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubScribeViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic) int sid;
@property (nonatomic) int price_type;
@property (nonatomic, strong) NSString *orderType;

@end
