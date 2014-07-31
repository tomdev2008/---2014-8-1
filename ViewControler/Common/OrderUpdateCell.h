//
//  orderCell.h
//  梧桐邑
//
//  Created by 陈磊 on 14-7-11.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderUpdateCell : UITableViewCell

@property (nonatomic, strong) UIButton *selectBtn;      // 选择
@property (nonatomic, strong) UILabel *contentLabel;    // 内容
@property (nonatomic, strong) UIButton *reduceBtn;      // 减号
@property (nonatomic, strong) UILabel *numLable;        // 数量
@property (nonatomic, strong) UIButton *plusBtn;        // 加号
@property (nonatomic, strong) UILabel *indexLabel;      // 记录cell的indexPath，不显示

@end
