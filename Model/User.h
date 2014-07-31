//
//  User.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-9.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *userFace;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userNickName;
@property (nonatomic, strong) NSString *userCommunity_Type;
@property (nonatomic, strong) NSString *userCommunity_Id;
@property (nonatomic, strong) NSString *userAuthentiCate;
@property (nonatomic, strong) NSString *userPassword;
@property (nonatomic, strong) NSString *userPhone;
@property (nonatomic, strong) NSString *userSex;
@property (nonatomic, strong) NSString *userProfession;
@property (nonatomic, strong) NSString *userAddress;
@property (nonatomic, strong) NSString *userCommunity;
@property (nonatomic, strong) NSString *userRoom;
@property (nonatomic, strong) NSString *userLoginType;

@property (assign, nonatomic) BOOL isChecked;

// 积分
@property (nonatomic, strong) NSString *userTotal;
@property (nonatomic, strong) NSString *userLeave;

@end
