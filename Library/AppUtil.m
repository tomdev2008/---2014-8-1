//
//  AppUtil.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-10.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "AppUtil.h"

@implementation AppUtil

+ (NSString *)dataPath
{
    NSString *path = [NSString stringWithFormat:@"%@/Library/UserInfo.data",NSHomeDirectory()];
    return path;
}



+ (void)updatePlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    NSMutableDictionary *applist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    // 获取地二组的信息
    NSMutableArray *array = [applist objectForKey:@"items"];
    NSMutableDictionary *dict = [array objectAtIndex:1];
    NSString *pictureName = [dict objectForKey:@"itemselectimagename"];
    pictureName = @"呼叫管理_选中.png";
    [dict setValue:pictureName forKeyPath:@"itemselectimagename"];
    [dict writeToFile:path atomically:YES];
}

@end
