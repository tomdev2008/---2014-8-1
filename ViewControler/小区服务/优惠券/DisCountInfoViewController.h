//
//  DisCountInfoViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-7-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
@interface DisCountInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ISSContent>

@property (nonatomic, strong) NSString *did;

@end
