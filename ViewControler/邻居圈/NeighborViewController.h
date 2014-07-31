//
//  NeighborViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-5-28.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "TQRichTextView.h"

@interface NeighborViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, TQRichTextViewDelegate>

@property (nonatomic, strong) EGORefreshTableHeaderView *egoRefresh;

@property (nonatomic, strong) void (^zanNumblock)();

@property (nonatomic, strong) TQRichTextView *richTextView;

// 是否发生变化
@property (nonatomic)   BOOL flag;  // NO 没有  YES

@end
