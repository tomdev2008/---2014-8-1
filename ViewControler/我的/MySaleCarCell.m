//
//  MySaleCarCell.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-3.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "MySaleCarCell.h"

@implementation MySaleCarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.frame = CGRectMake(20, 20, 80, 80);
        _titleImageView.image = [UIImage imageNamed:@"购物车默认"];
        [self.contentView addSubview:_titleImageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(_titleImageView.frame.size.width +40, 22, 200, 20);
        _titleLabel.text = @"张家桥海鲜";
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_titleLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+29, 200, 20)];
        _priceLabel.text = @"价格：25";
        _priceLabel.font = [UIFont systemFontOfSize:15];
        _priceLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_priceLabel];
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_priceLabel.frame.origin.x, _priceLabel.frame.origin.y + 29, 200, 20)];
        _numberLabel.text = @"数量：";
        _numberLabel.font = [UIFont systemFontOfSize:15];
        _numberLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_numberLabel];
        
//        _isDelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _isDelButton.frame = CGRectMake(90, 10, 20, 20);
//        [_isDelButton setBackgroundImage:[UIImage imageNamed:@"radio_no.png"] forState:UIControlStateNormal];
//        [_isDelButton setBackgroundImage:[UIImage imageNamed:@"radio_no.png"] forState:UIControlStateSelected];
//        _isDelButton.tag = 201;
//        [_isDelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:_isDelButton];
        
        _reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reduceButton.frame  = CGRectMake(_numberLabel.frame.origin.x+40, _numberLabel.frame.origin.y, 20, 20);
        _reduceButton.tag = 202;
        [_reduceButton setBackgroundImage:[UIImage imageNamed:@"reduce.png"] forState:UIControlStateNormal];
        [_reduceButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_reduceButton];
        
        _numberLabel_Real = [[UILabel alloc] initWithFrame:CGRectMake(_priceLabel.frame.origin.x+75, _priceLabel.frame.origin.y + 30, 20, 20)];
        _numberLabel_Real.text = @"1";
        _numberLabel_Real.font = [UIFont systemFontOfSize:15];
        _numberLabel_Real.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_numberLabel_Real];

        
        _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _plusButton.frame  = CGRectMake(_numberLabel.frame.origin.x+100, _numberLabel.frame.origin.y, 20, 20);
        _plusButton.tag = 203;
        [_plusButton setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        [_plusButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_plusButton];
        
        UIImageView *footImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
        footImageView.frame = CGRectMake(0, _numberLabel_Real.frame.origin.y + 30, 320, 1);
        [self.contentView addSubview:footImageView];
        
    }
    return self;
}

- (void)btnClick:(UIButton *)button
{
    static NSInteger _number = 4;
    if(button.tag == 202)
    {
        _number --;
        if(_number <= 1)
        {
            _number = 1;
        }
        _changeLabelBlock([NSString stringWithFormat:@"%d",_number]);
    }
    else if(button.tag == 203)
    {
        _number ++;
        _changeLabelBlock([NSString stringWithFormat:@"%d",_number]);
    }
    else if(button.tag == 201)
    {
        NSLog(@"201");
        button.selected = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"我的购物车_06.png"] forState:UIControlStateNormal];
    }
    // 数量
    _changeNumberLabelBlock([NSString stringWithFormat:@"%d",_number+4]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
