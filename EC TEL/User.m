//
//  User.m
//  UMAP
//
//  Created by Gang on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"


@implementation User
-(NSDictionary *)asDict{
    NSMutableDictionary* mutabledict=[NSMutableDictionary dictionary];
    mutabledict[@"userid"]=self.userid;
    mutabledict[@"name"]=self.name;
    mutabledict[@"email"]=self.email;
    mutabledict[@"username"]=self.username;
    mutabledict[@"sessionId"]=self.sessionId;
    mutabledict[@"roleid"]=self.roleid;
    return mutabledict;
}
+(User *)fromdict:(NSDictionary *)dict{
    User *u=[User new];
    u.userid=dict[@"userid"];
    u.name=dict[@"name"];
    u.email=dict[@"email"];
    u.username=dict[@"username"];
    u.sessionId=dict[@"sessionId"];
    u.roleid=dict[@"roleid"];
    return u;
}
@end
