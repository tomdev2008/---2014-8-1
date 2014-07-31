//
//  ShareManager.h
//  梧桐邑
//
//  Created by 陈磊 on 14-5-28.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareManager : NSObject

@property (nonatomic, assign) NSInteger pageNo;     // 控制页面

+ (ShareManager *)shareManager;

@end
