//
//  User.h
//  UMAP
//
//  Created by Gang on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSString *username;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *institue;
@property (nonatomic, strong) NSString *status;
@property (nonatomic,strong)NSString* sessionId;
@property (nonatomic,strong)NSString* roleid;
-(NSDictionary *)asDict;
+(User *)fromdict:(NSDictionary *)dict;
@end
