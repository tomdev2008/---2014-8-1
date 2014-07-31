//
//  SortView.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-24.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "SortView.h"

@implementation SortView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)createSortCouponWithObject:(id)object andSEL:(SEL)sel
{
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 91)];
    _backView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    _backView.userInteractionEnabled = YES;
    [self addSubview:_backView];
    
    // button
    NSArray *array = [NSArray arrayWithObjects:@"默认",@"按价格从低到高",@"领取数由高到低", nil];
    for(int i = 0; i < 3;i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(45, 30*i, 320, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.tag = i;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:object action:sel forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:button];
    }
    for(int i = 0; i < 4; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30*i, 310,1)];
        imageView.image = [UIImage imageNamed:@"line.png"];
        imageView.alpha = 0.5;
        [_backView addSubview:imageView];
    }
}

- (void)createSelectCouponWithObject:(id)object andSEL:(SEL)sel
{
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 181)];
    _backView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    _backView.userInteractionEnabled = YES;
    [self addSubview:_backView];
    
    // button
    NSArray *array = [NSArray arrayWithObjects:@"默认",@"扣次型储值卡",@"扣费型储值卡",@"代金券",@"低值券",@"折扣券",@"会员卡", nil];
    for(int i = 0; i < 7;i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(45, 30*i, 320, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.tag = i;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:object action:sel forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:button];
    }
    for(int i = 0; i < 8; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30*i, 310,1)];
        imageView.image = [UIImage imageNamed:@"line.png"];
        imageView.alpha = 0.5;
        [_backView addSubview:imageView];
    }

}


@end
