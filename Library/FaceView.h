//
//  FaceView.h
//  表情
//
//  Created by 陈磊 on 14-7-16.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceView : UIView
@property (nonatomic, strong) UIView *faceView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *faceName;


- (void)showFaceViewWithShow:(BOOL)flag andClassObject:(id)object andSEL:(SEL)sel;
- (void)hideFaceViewWithShow:(BOOL)flag;
// 获取头像的信息
- (NSString *)getFaceName;

@end
