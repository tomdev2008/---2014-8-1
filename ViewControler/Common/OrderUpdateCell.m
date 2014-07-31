//
//  orderCell.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-11.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "OrderUpdateCell.h"

@implementation OrderUpdateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(10, 5, 20, 20);
        [self addSubview:_selectBtn];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.frame = CGRectMake(35, 5, 100, 20);
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentLabel];
        
        // 减号
        _reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reduceBtn.frame = CGRectMake(200, 5, 25, 25);
        [self addSubview:_reduceBtn];
        
        // 数量
        _numLable = [[UILabel alloc] init];
        _numLable.frame = CGRectMake(225, 8, 30, 15);
        _numLable.textAlignment = NSTextAlignmentCenter;
        _numLable.font = [UIFont systemFontOfSize:13];
        _numLable.textColor = [UIColor darkGrayColor];
        _numLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_numLable];
        
        // 加号
        _plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _plusBtn.frame = CGRectMake(265, 5, 25, 25);
        [self addSubview:_plusBtn];
        
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.tag = 99;
        [self addSubview:_indexLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
