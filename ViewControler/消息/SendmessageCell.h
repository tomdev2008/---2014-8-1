//
//  SendmessageCell.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-26.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQRichTextView.h"

@interface SendmessageCell : UITableViewCell

@property (nonatomic, strong) UILabel *messageLable;
@property (nonatomic ,strong) UIImageView *headImage;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UIImageView *messageImage;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UIImageView *photoImage;  // 图片

@property (nonatomic, strong) UIView *returnView;   // 图文混排View

@property (nonatomic) int UserType;
@property (nonatomic) int contentType;      // 内容

- (void)setIntroductionText:(NSString *)text;
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf;
@property (nonatomic, strong) TQRichTextView *richTextView;

@end
