//
//  DownLoad.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-9.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownLoadDelegate <NSObject>

- (void)downLoadFinishWithClass:(id)classObject;

@end

@interface DownLoad : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak)__weak id <DownLoadDelegate> delegate;

@property (nonatomic, strong) NSString *downLoadURL;
@property (nonatomic) NSInteger downLoadType;
@property (nonatomic, strong) NSMutableData *data;

- (void)downLoadData;

@end
