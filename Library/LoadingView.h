//
//  LoadingView.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-10.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

- (void)createLoadingView:(BOOL)isStop andAlpha:(float)alpha;
- (void)loadingViewDispear:(float)alpha;

// 消息加载
- (void)createLoadingBackView:(BOOL)isStop andAlpha:(float)alpha;

// 录音喇叭
- (void)createRecodeBackView:(BOOL)isStop andAlpha:(float)alpha;

// 按住不松说话
- (void)createSpeakLongPressWithAlpha:(float)alpha;
@end
