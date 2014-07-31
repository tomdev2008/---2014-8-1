//
//  MyTabBar.m
//  MyTabBarController
//
//  Created by Visitor on 14-3-19.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "MyTabBar.h"

@implementation MyTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)createMyTabBarWithBackgroundImageName:(NSString *)bgImageName andItemTitles:(NSArray *)itemTitles andItemImagesName:(NSArray *)itemImagesName andItemSelectImagesName:(NSArray *)itemSelectImagesName andClass:(id)classObject andSEL:(SEL)sel
{
    // 1.创建背景图片
    [self createBackGroundImageViewWithImageName:bgImageName];
    // 2.创建对应数量的Item
    // Item总数
    int itemCount = itemImagesName.count;
    for(int index=0;index<itemCount;index++)
    {
        [self createItemWithItemTitle:[itemTitles objectAtIndex:index] andItemImageName:[itemImagesName objectAtIndex:index] andItemSelectImageName:[itemSelectImagesName objectAtIndex:index] andIndex:index andItemCount:itemCount andClass:classObject andSEL:sel];
    }
}

- (void)createItemWithItemTitle:(NSString *)itemTitle andItemImageName:(NSString *)itemImageName andItemSelectImageName:(NSString *)itemSelectImageName andIndex:(int)index andItemCount:(int)itemCount andClass:(id)classObject andSEL:(SEL)sel
{
    // 1.得到图片的大小
    CGSize imageSize = [UIImage imageNamed:itemImageName].size;
    // 2.计算每个Item的大小(W:总宽度/总个数,H:总高度)
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(self.frame.size.width/itemCount*index, 5, self.frame.size.width/itemCount, self.frame.size.height);
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    // 3.设置Button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((self.frame.size.width/itemCount-imageSize.width)/2+10, 0, imageSize.width/1.7, imageSize.height/1.7);
    [btn setBackgroundImage:[UIImage imageNamed:itemImageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:itemSelectImageName] forState:UIControlStateSelected];
    [btn addTarget:classObject action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.tag = index;
    [bgView addSubview:btn];
    
    UILabel *label = [[UILabel alloc] init];
    label.tag = 100 + index;
    label.frame = CGRectMake(0, 26, 65, 20);
    label.textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.text = itemTitle;
    [bgView addSubview:label];
    
}


- (void)createBackGroundImageViewWithImageName:(NSString *)imageName
{
    UIImageView *imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [imageView setBackgroundColor:[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f]];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
    [imageView release];
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






















