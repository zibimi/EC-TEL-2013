//
//  DataManager.h
//  EC TEL
//
//  Created by pengyunchou on 13-11-1.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "Content.h"
#import "Presentation.h"
#import "Session.h"
#import "User.h"
@interface DataManager : NSObject
@property (nonatomic,strong)NSNumber* conferenceId;
-(void)rateContentOfId:(NSNumber *)contentId forValue:(int)value;
-(void)loadRecomendataion:(void (^)(NSArray *recomends))oncomplete;
-(NSDictionary *)getMyReadingList;
-(void)loadMyfriend:(void (^)(NSArray *friends))oncomplete;
-(BOOL)isInReadingList:(NSNumber *)contentid;
-(void)addMyReadingList:(NSNumber *)contentid;
-(void)removeReadingList:(NSNumber *)contentid;
+(DataManager *)sharedMgr;
-(void)bookmarkContentid:(NSNumber *)cid onComplete:(void (^)(BOOL success))oncomplete;
-(void)unbookmarkContentid:(NSNumber *)cid onComplete:(void (^)(BOOL success))oncomplete;
-(void)loadAllMySchedule:(void (^)(NSDictionary* schdules)) oncomplete;
-(User *)loginuser;
-(void)setLoginuser:(User *)aloginuser;
-(NSString *)authorsTextForContentId:(NSNumber *)contentid;
-(NSArray *)preceedingContents;
-(void)downloadData:(void(^)(BOOL))complete;
-(Author *)authorWithId:(NSNumber *)aid;
-(NSArray *)getAllAuthors;
-(NSArray *)getAllContent;
-(Event *)getEvent;
-(void)checkUpdate:(void (^)(NSDate* time))complete;
-(NSArray *)presentationsOfSessionId:(NSNumber *)sessionid;
-(void)setup;
-(BOOL)isRemarked:(NSNumber *)contentid;
-(void)setRemark:(NSNumber *)contentid remarked:(BOOL)remarked;
-(Content *)contentOfId:(NSNumber *)cid;
-(NSArray *)contentsByAuthorId:(NSNumber *)aid;
-(Presentation *)presentationOfContentId:(NSNumber *)cid;
-(Presentation *)presentationOfPid:(NSNumber *)pid;
-(Session *)sessionOfSessionId:(NSNumber *)sid;
-(NSArray *)getSessionForDate:(NSDate *)date;
-(void)loadRecomendsOfContentId:(NSNumber *)cid oncomplete:(void(^)(NSArray *recomends))complete;
@end
