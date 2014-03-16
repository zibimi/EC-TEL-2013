//
//  Presentation.h
//  EC TEL
//
//  Created by pengyunchou on 13-11-1.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content, Session;

@interface Presentation : NSObject

@property (nonatomic, strong) NSDate * beginTime;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSDate * endTime;
@property (nonatomic, strong) NSNumber * pID;
@property (nonatomic,strong)NSNumber *sessionId;
@property (nonatomic, strong) NSString * presentationTrack;
@property (nonatomic, strong) NSString * presentationType;
@property (nonatomic,strong)NSNumber* contentId;

@end
