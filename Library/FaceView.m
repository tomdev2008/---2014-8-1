//
//  FaceView.m
//  表情
//
//  Created by 陈磊 on 14-7-16.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "FaceView.h"

@implementation FaceView
@synthesize faceView;
@synthesize dataArray;
@synthesize faceName;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        faceView = [[UIView alloc] init];
        dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

// 加载图片
- (void)loadFaceWithObject:(id)classObject andSEL:(SEL)sel
{
    for(int i = 0; i < 28; i ++)
    {
        if(i <= 9)
        {
            NSString *str = [NSString stringWithFormat:@"0%d]",i];
            NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"[f0%@",str] ofType:@"png"];
            NSLog(@"path==:%@",path);
            [dataArray addObject:path];
        }
        else
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"[f0%d]",i] ofType:@"png"];
            NSLog(@"path==:%@",path);
            [dataArray addObject:path];
        }
    }
    
    int count = 0;
    for(int i = 0; i < 4; i ++)
    {
        for(int j = 0; j < 7; j ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(30+40*j, 5+30*i, 30, 30);
            [button setBackgroundImage:[UIImage imageWithContentsOfFile:[dataArray objectAtIndex:count]] forState:UIControlStateNormal]; //= [UIImage imageWithContentsOfFile:[dataArray objectAtIndex:count]];
            button.tag = 10+count;
            [button addTarget:classObject action:sel forControlEvents:UIControlEventTouchUpInside];
            [faceView addSubview:button];
            count ++;
        }
    }
}

- (void)showFaceViewWithShow:(BOOL)flag andClassObject:(id)object andSEL:(SEL)sel
{
    faceView.frame = CGRectMake(0, 0, 320,100);
    faceView.layer.borderColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f].CGColor;
    faceView.hidden = flag;
    if(!flag)
    {
        [self loadFaceWithObject:object andSEL:sel];
    }
    [self addSubview:faceView];
}
- (void)hideFaceViewWithShow:(BOOL)flag;
{
    faceView.hidden = flag;
}
- (NSString *)getFaceName
{
    NSString *str = [NSString stringWithFormat:@"[f%@",[faceName substringToIndex:4]];
    return str;
}


@end
