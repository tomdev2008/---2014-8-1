//
//  User.m
//  梧桐邑
//
//  Created by 陈磊 on 14-6-9.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "User.h"

@implementation User

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self userId] forKey:@"id"];
    [aCoder encodeObject:[self userNickName] forKey:@"nickname"];
    [aCoder encodeObject:[self userFace] forKey:@"face"];
    [aCoder encodeObject:[self userCommunity_Id] forKey:@"community_id"];
    [aCoder encodeObject:[self userCommunity_Type] forKey:@"community_type"];
    [aCoder encodeObject:[self userAuthentiCate] forKey:@"authenticate"];
    [aCoder encodeObject:[self userPhone] forKey:@"phone"];
    [aCoder encodeObject:[self userPassword] forKey:@"password"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self == [super init])
    {
        [self setUserId:[aDecoder decodeObjectForKey:@"id"]];
        [self setUserNickName:[aDecoder decodeObjectForKey:@"nickname"]];
        [self setUserFace:[aDecoder decodeObjectForKey:@"face"]];
        [self setUserCommunity_Id:[aDecoder decodeObjectForKey:@"community_id"]];
        [self setUserCommunity_Type:[aDecoder decodeObjectForKey:@"community_type"]];
        [self setUserAuthentiCate:[aDecoder decodeObjectForKey:@"authenticate"]];
        [self setUserPhone:[aDecoder decodeObjectForKey:@"phone"]];
        [self setUserPassword:[aDecoder decodeObjectForKey:@"password"]];
    }
    return self;
}

@end
