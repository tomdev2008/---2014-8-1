//
//  AddressInfoViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-5.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) void (^addressBlock) (NSString *name, NSString *phone,NSString *address);

@end
