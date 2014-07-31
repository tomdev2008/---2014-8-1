//
//  AddressBookCell.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-30.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressBookCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UIImageView *selectImage;

- (void) setChecked:(BOOL)checked;

@end
