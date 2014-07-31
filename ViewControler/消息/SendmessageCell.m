//
//  SendmessageCell.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-26.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "SendmessageCell.h"
#import "ZL_CONST.h"
#define BEGIN_FLAG @"["
#define END_FLAG @"]"

@implementation SendmessageCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // 消息
        _messageLable = [[UILabel alloc] init];
        _messageLable.frame = CGRectMake(0, 0, 240, 20);
        _headImage = [[UIImageView alloc] init];
        _messageImage = [[UIImageView alloc] init];
        _timeLable = [[UILabel alloc] init];
        [_messageImage addSubview:_messageLable];
        _photoImage = [[UIImageView alloc] init];
        _returnView = [[UIView alloc] init];
        _richTextView = [[TQRichTextView alloc] init];
        [_messageImage addSubview:_richTextView];
        [_messageImage addSubview:_photoImage];
        [self.contentView addSubview:_timeLable];
        [self.contentView addSubview:_headImage];
        [self.contentView addSubview:_messageImage];
    }
    return self;
}

// 自适应高度
- (void)setIntroductionText:(NSString *)text
{
    CGRect frame = [self frame];
    // 消息
    _messageLable.numberOfLines = 0;
    UIFont *tfont = [UIFont systemFontOfSize:13];
    _messageLable.userInteractionEnabled = YES;
    _messageLable.font = tfont;
    _messageLable.backgroundColor = [UIColor clearColor];
    _messageLable.lineBreakMode = NSLineBreakByTruncatingTail;
    
    CGSize size = CGSizeMake(160, 1000);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName, nil];
    CGSize actualsize;
    if(is_IPHONE_6)
    {
        actualsize = [text sizeWithFont:tfont constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    }
    else
    {
        actualsize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    }
    _timeLable.font = [UIFont systemFontOfSize:12];
    _timeLable.textColor = [UIColor darkGrayColor];
    
    UIImage *image = nil;
    if(_UserType == 0)
    {
        image = [UIImage imageNamed:@"send.png"];
        image = [image stretchableImageWithLeftCapWidth:50 topCapHeight:40];
        _messageImage.image = image;
        if(self.contentType == 0)
        {
            // 文字
            _messageImage.frame = CGRectMake(230-actualsize.width, 20, actualsize.width+40, actualsize.height+20);
            _richTextView.frame = CGRectMake(15, 8, actualsize.width, actualsize.height+5);
            _richTextView.backgroundColor = [UIColor clearColor];
            _messageLable.frame = CGRectMake(10, 8, actualsize.width, actualsize.height);
            _messageLable.textColor = [UIColor darkGrayColor];
            _headImage.frame = CGRectMake(270, _messageImage.frame.origin.y, 36, 36);
            _photoImage.frame = CGRectMake(10, 8, actualsize.width, actualsize.height);
            if(actualsize.width > 100)
            {
                _timeLable.frame = CGRectMake(_messageImage.frame.origin.x+10, _messageImage.frame.origin.y-12, 150, 10);
            }
        }
        else if(self.contentType == 1)
        {
            // 图片
            _photoImage.frame = CGRectMake(4, 5, 91, 88);
            _messageImage.frame = CGRectMake(160, 10, 110, 100);
            _headImage.frame = CGRectMake(270, _messageImage.frame.origin.y, 36, 36);
            _timeLable.frame = CGRectMake(_messageImage.frame.origin.x-120, (_messageImage.frame.size.height/2), 150, 10);
        }
        else if (self.contentType == 2)
        {
            // 语音
            _photoImage.frame = CGRectMake(40, 10, 15, 20);
            [_photoImage setImage:[UIImage imageNamed:@"right.png"]];
            _messageImage.frame = CGRectMake(180, 10, 80, 40);
            _headImage.frame = CGRectMake(270, _messageImage.frame.size.height/2-10, 36, 36);
            _timeLable.frame = CGRectMake(_messageImage.frame.origin.x-120, (_messageImage.frame.size.height/2), 150, 10);

        }
        else if(self.contentType == 3)
        {
            // 转发
            _messageImage.frame = CGRectMake(80, 20, 190, 90);
            _photoImage.frame = CGRectMake(5, 5, 75, 78);
            _messageLable.frame = CGRectMake(83, 10, 90, 60);
            _headImage.frame = CGRectMake(270, _messageImage.frame.origin.y, 36, 36);
            _timeLable.frame = CGRectMake(_messageImage.frame.origin.x, _messageImage.frame.origin.y-12, 150, 10);
            
        }
    }
    else if(_UserType == 1)
    {
        
        image = [UIImage imageNamed:@"accept.png"];
        image = [image stretchableImageWithLeftCapWidth:50 topCapHeight:40];
        _messageImage.image = image;
        if(self.contentType == 0 )
        {
            
            _messageImage.frame = CGRectMake(50, 10, actualsize.width+40, actualsize.height+20);
            _headImage.frame = CGRectMake(10, _messageImage.frame.origin.y , 36, 36);
            _richTextView.frame = CGRectMake(15, 8, actualsize.width, actualsize.height+5);
            _richTextView.backgroundColor = [UIColor clearColor];
            _messageLable.frame = CGRectMake(25, 8, actualsize.width+10, actualsize.height);
            if(actualsize.width > 100)
            {
                _timeLable.frame = CGRectMake(_messageImage.frame.origin.x+50, _messageImage.frame.origin.y-12, 150, 10);
            }
        }
        else if(self.contentType == 1)
        {
            // 图片
           
            _messageImage.frame = CGRectMake(50, 0, 110, 100);
             _headImage.frame = CGRectMake(10, _messageImage.frame.origin.y, 36, 36);
            _photoImage.frame = CGRectMake(12,5, 91, 88);
            _timeLable.frame = CGRectMake(_messageImage.frame.origin.x+120, (_messageImage.frame.size.height/2), 150, 10);
        }
        else if(self.contentType == 2)
        {
            // 语音
            _messageImage.frame = CGRectMake(50, 10, 80, 40);
            _headImage.frame = CGRectMake(10, _messageImage.frame.origin.y, 36, 36);
            [_photoImage setImage:[UIImage imageNamed:@"left.png"]];
            _photoImage.frame = CGRectMake(12,10, 15, 20);
            _timeLable.frame = CGRectMake(_messageImage.frame.origin.x+120, (_messageImage.frame.size.height/2), 150, 10);
        }
        else if(self.contentType == 3)
        {
            // 转发
            _messageImage.frame = CGRectMake(50, 20, 200, 90);
            _photoImage.frame = CGRectMake(20, 5, 75, 80);
            _messageLable.frame = CGRectMake(75+18+5, 10, 90, 60);
            _headImage.frame = CGRectMake(10, _messageImage.frame.origin.y, 36, 36);
            _timeLable.frame = CGRectMake(_messageImage.frame.origin.x+70, _messageImage.frame.origin.y-12, 150, 10);
        }
    }
    
    frame.size.height = actualsize.height+40;
    self.frame = frame;
}

- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf
{
    _returnView = [self assembleMessageAtIndex:text from:fromSelf];
    _returnView.backgroundColor = [UIColor clearColor];
    _returnView.frame = CGRectMake(8, 3, _returnView.frame.size.width+24.0f, _returnView.frame.size.height+24.0f);
    [self.contentView addSubview:_returnView];
    return self.contentView;
}

//图文混排

-(void)getImageRange:(NSString*)message : (NSMutableArray*)array {
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}

#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH 150
-(UIView *)assembleMessageAtIndex : (NSString *) message from:(BOOL)fromself
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *data = array;
    UIFont *fon = [UIFont systemFontOfSize:13.0f];
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    if (data) {
        for (int i=0;i < [data count];i++) {
            NSString *str=[data objectAtIndex:i];
            NSLog(@"str--->%@",str);
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = 150;
                    Y = upY;
                }
                NSLog(@"str(image)---->%@",str);
                NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                upX=KFacialSizeWidth+upX;
                if (X<150) X = upX;
                
                
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X = 150;
                        Y =upY;
                    }
                    CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(150, 40)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                    la.font = fon;
                    la.text = temp;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    upX=upX+size.width;
                    if (X<150) {
                        X = upX;
                    }
                }
            }
        }
    }
    returnView.frame = CGRectMake(15.0f,1.0f, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
    NSLog(@"%.1f %.1f", X, Y);
    return returnView;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
