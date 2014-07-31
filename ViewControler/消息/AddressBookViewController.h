//
//  AddressBookViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-30.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressBookViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic) int comeType; // 从哪个界面进行的跳转   如果是0 就是通讯录 1 增加群组成员 2邻居说
@property (nonatomic) NSString *groupId;    // 群组ID；

@end
