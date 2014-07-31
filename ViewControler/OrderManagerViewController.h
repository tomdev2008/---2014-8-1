//
//  OrderManagerViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-24.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface OrderManagerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>

@property (nonatomic, strong) EGORefreshTableHeaderView *egoRefresh;

@end
