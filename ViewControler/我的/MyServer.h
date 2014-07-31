//
//  MyServer.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyServer : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serverStateLabel;

// 我的服务
@property (weak, nonatomic) IBOutlet UILabel *serverTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *serverCodeLable;
@property (weak, nonatomic) IBOutlet UILabel *serverPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *serverNameLable;
@property (weak, nonatomic) IBOutlet UIImageView *serverImage;



@end
