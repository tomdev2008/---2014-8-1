//
//  RealPay.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-20.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RealPay : NSObject

@property (nonatomic, strong) NSString *realId;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *realUrge;
@property (nonatomic) int realCurrent;
@property (nonatomic) int realTotal;

@end
