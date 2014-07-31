//
//  Group.h
//  梧桐邑
//
//  Created by 陈磊 on 14-7-1.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject

@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *groupShield;
@property (nonatomic, strong) NSMutableArray *groupArray; // 存放群用户头像

@end
