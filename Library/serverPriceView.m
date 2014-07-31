//
//  serverPriceView.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-25.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "serverPriceView.h"

@implementation serverPriceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)createServerPriceView:(BOOL)isStop andAlpha:(float)alpha
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 500)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = alpha;
    [self addSubview:backView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, 300, 480)];
    scrollView.contentSize = CGSizeMake(300, 600);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor redColor];
    [backView addSubview:scrollView];
}

- (void)serverPriceViewDispear:(float)alpha
{
    self.alpha = alpha;
    [self removeFromSuperview];
}

@end
