//
//  ChangeNumCell.h
//  梧桐邑
//
//  Created by 陈磊 on 14-7-14.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeNumCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serName;
@property (weak, nonatomic) IBOutlet UILabel *serCount;
@property (weak, nonatomic) IBOutlet UILabel *serPrice;
@property (weak, nonatomic) IBOutlet UIImageView *serTitlePic;

@property (nonatomic ,strong) UILabel *indexLable;

- (IBAction)plusClick:(id)sender;
- (IBAction)reduceClick:(id)sender;


@end
