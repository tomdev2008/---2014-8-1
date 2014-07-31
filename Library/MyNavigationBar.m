//
//  MyNavigationBar.m
//  VistaDemo
//
//  Created by Visitor on 14-4-2.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "MyNavigationBar.h"
#import "ZL_CONST.h"

@implementation MyNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)createMyNavigationBarWithBackGroundImage:(NSString *)bgImageName andTitleViewImage:(NSString *)titleImageName andtTitleLabel:(NSString *)titleLabel andLeftButtonImage:(NSString *)leftBtnImageName andRightButtonImage:(NSString *)rightBtnImageName andSEL:(SEL)sel andClass:(id)classObject
{
    [self createBackGroundImageViewWithImageName:bgImageName];
    [self createTitleWithTitleImageName:titleImageName andTitleText:titleLabel];
    if(leftBtnImageName.length > 0)
    {
       [self createButtonWithButtonImageName:leftBtnImageName andisLeft:YES andSEL:sel andClass:classObject];
    }
    if(rightBtnImageName.length > 0)
    {
        [self createButtonWithButtonImageName:rightBtnImageName andisLeft:NO andSEL:sel andClass:classObject];
    }
    
}

- (void)createBackGroundImageViewWithImageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = CGRectMake(0, -20, self.frame.size.width, self.frame.size.height+20);
    [self addSubview:imageView];
}

- (void)createTitleWithTitleImageName:(NSString *)imageName andTitleText:(NSString *)text
{
    if(imageName.length <= 0)
    {
        // 代表没有图片有文字
        UILabel *label = [[UILabel alloc] init];
        label.frame = self.bounds;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"黑体" size:24.0];
        label.textColor = [UIColor colorWithRed:0.05f green:0.64f blue:0.49f alpha:1.00f];
        label.text = text;
        [self addSubview:label];
    }
    else
    {
        // 有图片没文字
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = self.bounds;
        // 设置内容位置
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        
    }
}

- (void)createButtonWithButtonImageName:(NSString *)imageName andisLeft:(BOOL)isLeft andSEL:(SEL)sel andClass:(id)classObject
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = isLeft?CGRectMake(10, (self.frame.size.height-35)/2, 30, 30):CGRectMake(320-35-10, (self.frame.size.height-35)/2, 30, 30);
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:classObject action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.tag = isLeft?1:2;
    [self addSubview:btn];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
















