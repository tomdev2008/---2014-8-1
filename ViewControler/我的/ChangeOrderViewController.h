//
//  ChangeOrderViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-7-14.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeOrderViewControllerDelegate <NSObject>

- (void)changeOrderServerWithDict:(NSDictionary *)mdict;

@end

@interface ChangeOrderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *sid;    // 服务ID;
@property (nonatomic) __weak id <changeOrderViewControllerDelegate> delegate;

@end
