//
//  LoadingView.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-10.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "LoadingView.h"
#import "ZL_CONST.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)createLoadingView:(BOOL)isStop andAlpha:(float)alpha
{
    UIImageView *imageView = [[UIImageView alloc] init];
    self.alpha = alpha;
    imageView.alpha = 0.6;
    imageView.frame = CGRectMake(0, 0,self.frame.size.width,self.frame.size.height);
    imageView.image = [UIImage imageNamed:@"loadingbg.png"];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"正在加载";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.frame = CGRectMake(12, 50, 80, 20);
    [imageView addSubview:label];
    
    UIActivityIndicatorView *activityIn = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIn.center = CGPointMake(40, 30);
    if(isStop)
    {
        [activityIn startAnimating];
    }
    else
    {
        [activityIn stopAnimating];
    }
    [imageView addSubview:activityIn];
}
- (void)loadingViewDispear:(float)alpha
{
    self.alpha = alpha;
    [self removeFromSuperview];
}

- (void)createLoadingBackView:(BOOL)isStop andAlpha:(float)alpha
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.alpha = 0.7;
    backView.frame = self.bounds;
    [self addSubview:backView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.alpha = alpha;
    imageView.alpha = 0.8;
    imageView.frame = CGRectMake((320-80)/2, isRetina.size.height>480?(568-64-80)/2:(480-64-80)/2,80,80);
    imageView.image = [UIImage imageNamed:@"loadingbg.png"];
    [backView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"刷新消息";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.frame = CGRectMake(12, 50, 80, 20);
    [imageView addSubview:label];
    
    UIActivityIndicatorView *activityIn = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIn.center = CGPointMake(40, 30);
    if(isStop)
    {
        [activityIn startAnimating];
    }
    else
    {
        [activityIn stopAnimating];
    }
    [imageView addSubview:activityIn];

}

// 录音喇叭
- (void)createRecodeBackView:(BOOL)isStop andAlpha:(float)alpha
{
    UIImageView *imageView = [[UIImageView alloc] init];
    self.alpha = alpha;
    imageView.alpha = 0.8;
    imageView.frame = self.bounds;
    imageView.image = [UIImage imageNamed:@"loadingbg.png"];
    [self addSubview:imageView];

    
    NSArray *myImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"an001.png"],[UIImage imageNamed:@"an002.png"],[UIImage imageNamed:@"an003.png"], nil];
    UIImageView *myAnimatedView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];;
    myAnimatedView.animationImages = myImages;
    myAnimatedView.animationDuration = 0.25;
    myAnimatedView.animationRepeatCount = 0;
    [myAnimatedView startAnimating];
    [imageView addSubview:myAnimatedView];
    
}



@end
