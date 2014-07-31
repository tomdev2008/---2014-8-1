//
//  SortView.h
//  梧桐邑
//
//  Created by 陈磊 on 14-7-24.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortView : UIView

@property (nonatomic, strong) UIView *backView;

// 排序界面
- (void)createSortCouponWithObject:(id)object andSEL:(SEL)sel;

// 筛选界面
- (void)createSelectCouponWithObject:(id)object andSEL:(SEL)sel;

@end
