//
//  Session.h
//  EC TEL
//
//  Created by pengyunchou on 13-11-1.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Session : NSObject

@property (nonatomic, strong) NSDate * beginTime;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSDate * endTime;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSNumber * sID;
@property (nonatomic, strong) NSString * sTitle;
@property (nonatomic, strong) NSString * sType;
@end
