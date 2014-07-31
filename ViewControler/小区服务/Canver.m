//
//  Canver.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-8.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "Canver.h"

@implementation Canver

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(context, 0.5);
    // 矩形
    CGPoint points[] = {CGPointMake(10, 10),CGPointMake(310, 10),CGPointMake(310,35*4),CGPointMake(10, 35*4)};
    CGContextAddLines(context, points, 4);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    // 直线
    CGContextRef context_line = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context_line, 10, 45);
    CGContextAddLineToPoint(context_line, 310, 45);
    CGContextClosePath(context_line);
    CGContextStrokePath(context_line);
    
    // 发票信息
    CGContextRef contextPage = UIGraphicsGetCurrentContext();
    CGPoint pointPage[] = {CGPointMake(10, 35*4+10),CGPointMake(310, 35*4+10),CGPointMake(310,35*4+10+35*2),CGPointMake(10, 35*4+10+35*2)};
    CGContextAddLines(contextPage, pointPage, 4);
    CGContextClosePath(contextPage);
    CGContextStrokePath(contextPage);
    
    // 直线
    CGContextRef context_Page_line = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context_Page_line, 10, 35*4+10+35);
    CGContextAddLineToPoint(context_Page_line, 310, 35*4+10+35);
    CGContextClosePath(context_Page_line);
    CGContextStrokePath(context_Page_line);

    // 优惠券抵扣
    CGContextRef contextCoupon = UIGraphicsGetCurrentContext();
    CGPoint pointCounpon[] = {CGPointMake(10, 35*6+20),CGPointMake(310, 35*6+20),CGPointMake(310,35*9),CGPointMake(10, 35*9)};
    CGContextAddLines(contextCoupon, pointCounpon, 4);
    CGContextClosePath(contextCoupon);
    CGContextStrokePath(contextCoupon);
    
    // 直线
    CGContextRef context_Coupon_line = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context_Coupon_line, 10, 35*7+20);
    CGContextAddLineToPoint(context_Coupon_line, 310, 35*7+20);
    CGContextClosePath(context_Coupon_line);
    CGContextStrokePath(context_Coupon_line);
    
    // 积分抵扣支付
    CGContextRef contextPoint = UIGraphicsGetCurrentContext();
    CGPoint pointPoint[] = {CGPointMake(10, 35*9+10),CGPointMake(310, 35*9+10),CGPointMake(310, 35*11+10),CGPointMake(10, 35*11+10)};
    CGContextAddLines(contextPoint, pointPoint, 4);
    CGContextClosePath(contextPoint);
    CGContextStrokePath(contextPoint);
    
    // 直线
    CGContextRef context_line_point = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context_line_point, 10, 35*10+10);
    CGContextAddLineToPoint(context_line_point, 310, 35*10+10);
    CGContextClosePath(context_line_point);
    CGContextStrokePath(context_line_point);

    // 查看服务清单
    CGContextRef conte_server = UIGraphicsGetCurrentContext();
    CGPoint pointServer[] = {CGPointMake(10, 35*11+20),CGPointMake(310, 35*11+20),CGPointMake(310, 35*12+20),CGPointMake(10, 35*12+20)};
    CGContextAddLines(conte_server, pointServer, 4);
    CGContextClosePath(conte_server);
    CGContextStrokePath(conte_server);
    
    // 结算信息
    CGContextRef context_toTal = UIGraphicsGetCurrentContext();
    CGPoint pointToatal[] = {CGPointMake(10, 35*12+30),CGPointMake(310, 35*12+30),CGPointMake(310, 35*16+10),CGPointMake(10, 35*16+10)};
    CGContextAddLines(context_toTal, pointToatal, 4);
    CGContextClosePath(context_toTal);
    CGContextStrokePath(context_toTal);
    
    // 直线
    CGContextRef context_line_total = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context_line_total, 10, 35*14-5);
    CGContextAddLineToPoint(context_line_total, 310, 35*14-5);
    CGContextClosePath(context_line_total);
    CGContextStrokePath(context_line_total);
    
    
}

@end
