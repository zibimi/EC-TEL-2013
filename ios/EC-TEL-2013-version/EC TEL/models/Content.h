//
//  Content.h
//  EC TEL
//
//  Created by pengyunchou on 13-11-1.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Session.h"
@interface AuthorPresenter : NSObject
@property (nonatomic,strong)NSNumber* apid;
@property (nonatomic,strong)NSNumber* num;
@property (nonatomic,strong)NSNumber* authorId;
@property (nonatomic,strong)NSString* name;
@end


@class Author, Presentation;

@interface Content : NSObject
@property (nonatomic,strong) NSNumber* sessionId;
@property (nonatomic, strong) NSString * abstract;
@property (nonatomic, strong) NSNumber * contentID;
@property (nonatomic, strong) NSString * contentType;
@property (nonatomic, strong) NSNumber * marked;
@property (nonatomic, strong) NSNumber * scheduled;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * track;
@property (nonatomic, strong) NSMutableArray* authors;
@end

