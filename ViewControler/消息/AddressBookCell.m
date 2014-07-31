//
//  AddressBookCell.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-30.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "AddressBookCell.h"

@implementation AddressBookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _headImage = [[UIImageView alloc] init];
        _headImage.frame = CGRectMake(20, 11, 46 , 46);
        _headImage.image = [UIImage imageNamed:@"头像-男.png"];
        [self addSubview:_headImage];
        
        // 名字
        _nameLable = [[UILabel alloc] init];
        _nameLable.frame = CGRectMake(_headImage.frame.origin.x+_headImage.frame.size.width+10, 20, 100, 20);
        _nameLable.text = @"啦啦啦啦";
        _nameLable.font = [UIFont systemFontOfSize:15];
        [self addSubview:_nameLable];
        
        _selectImage = [[UIImageView alloc] init];
        _selectImage.frame = CGRectMake(320-50, 20, 30, 30);
        [self addSubview:_selectImage];
    }
    return self;
}

- (void)setChecked:(BOOL)checked
{
    if(checked)
    {
        _selectImage.image = [UIImage imageNamed:@"我的购物车_06.png"];
    }
    else
    {
        _selectImage.image = nil;
    }
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
