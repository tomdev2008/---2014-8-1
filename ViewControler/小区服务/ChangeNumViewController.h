//
//  ChangeNumViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-7-14.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZL_CONST.h"

@protocol ChangeNumViewControllerDelegate <NSObject>

- (void)changePrice:(NSString *)price;

@end

@interface ChangeNumViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Server *server;
@property (nonatomic, strong) NSMutableArray *Events;
@property (nonatomic, strong) NSString *serId;

@property (nonatomic) __weak id <ChangeNumViewControllerDelegate> delegate;

@end
