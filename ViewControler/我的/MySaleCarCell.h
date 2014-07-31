//
//  MySaleCarCell.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySaleCarCell : UITableViewCell

@property (nonatomic, strong) UIImageView *titleImageView;  // 展示图
@property (nonatomic, strong) UILabel *titleLabel;          // 名称
@property (nonatomic, strong) UILabel *priceLabel;          // 价格
@property (nonatomic, strong) UILabel *numberLabel;         // 数量
@property (nonatomic, strong) UIButton *isDelButton;
@property (nonatomic, strong) UILabel *numberLabel_Real;    // 实际数量
@property (nonatomic, strong) UIButton *reduceButton;       // 减号
@property (nonatomic, strong) UIButton *plusButton;         // 加号

//@property (nonatomic) NSInteger number;

@property (nonatomic, strong) void(^changeLabelBlock)(NSString *text);  // 改变值
@property (nonatomic, strong) void(^changeNumberLabelBlock)(NSString *text);

@end
