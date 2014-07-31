//
//  DownLoad.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-9.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "DownLoad.h"

@implementation DownLoad

- (void)downLoadData
{
    NSURL *url = [[NSURL alloc] initWithString:_downLoadURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"数据开始下载");
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_delegate downLoadFinishWithClass:self];
    NSLog(@"下载成功！");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"下载失败%@",error);
}

@end
