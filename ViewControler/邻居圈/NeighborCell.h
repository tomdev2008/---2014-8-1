//
//  NeighborCell.h
//  梧桐邑
//
//  Created by 陈磊 on 14-5-29.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeighborCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *neiFaceLabel;

@property (weak, nonatomic) IBOutlet UILabel *neiTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *neiContentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *neiPictureLabel;

@property (weak, nonatomic) IBOutlet UILabel *neiTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *neiCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *neiShareLabel;
@property (weak, nonatomic) IBOutlet UILabel *neiTranspondLabel;


@end
