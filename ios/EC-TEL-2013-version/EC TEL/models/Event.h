//
//  Event.h
//  EC TEL
//
//  Created by pengyunchou on 13-11-1.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Session;

@interface Event : NSObject

@property (nonatomic, strong) NSString * abstraction;
@property (nonatomic, strong) NSString * detail;
@property (nonatomic, strong) NSDate * enddate;
@property (nonatomic, strong) NSNumber * eventid;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSNumber * selected;
@property (nonatomic, strong) NSString * shortTitle;
@property (nonatomic, strong) NSDate * startdate;
@property (nonatomic, strong) NSString * title;
@end
