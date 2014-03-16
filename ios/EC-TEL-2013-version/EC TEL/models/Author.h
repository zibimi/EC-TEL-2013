//
//  Author.h
//  EC TEL
//
//  Created by pengyunchou on 13-11-1.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content;

@interface Author : NSObject

@property (nonatomic, strong) NSNumber * authorId;
@property (nonatomic, strong) NSString * institute;
@property (nonatomic, strong) NSString * name;
@property (nonatomic,strong)NSString* address;
@end

