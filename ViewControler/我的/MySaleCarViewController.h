//
//  MySaleCarViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySaleCarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *numberLabel_xib;



@property (nonatomic, strong) void(^changeTitleNumberBlock)(NSString *text);

@end
