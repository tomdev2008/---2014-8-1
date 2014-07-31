//
//  PaySelectViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-5-30.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySelectViewController : UIViewController

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *sign;

@property (weak, nonatomic) IBOutlet UILabel *priceLable;

@property (weak, nonatomic) IBOutlet UILabel *orderCodeLable;

- (IBAction)payClick:(id)sender;


@end
