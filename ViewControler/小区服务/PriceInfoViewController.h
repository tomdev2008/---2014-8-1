//
//  PriceInfoViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-4.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *type;

@end
