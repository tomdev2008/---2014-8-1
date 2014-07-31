//
//  RegiestViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-5-28.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegiestViewController :UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) int count;    // 是0  地址  1  注册


@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *commId;
@property (nonatomic, strong) void (^addressBlock) (NSString *address, NSString *date, NSString *time, NSString *commId);

@end
