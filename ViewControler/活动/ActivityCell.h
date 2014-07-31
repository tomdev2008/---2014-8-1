//
//  ActivityCell.h
//  梧桐邑
//
//  Created by 陈磊 on 14-5-28.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *faceImge;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *joinNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titlePicImage;
@property (weak, nonatomic) IBOutlet UILabel *sendTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
