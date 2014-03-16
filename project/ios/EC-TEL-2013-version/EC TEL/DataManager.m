//
//  DataManager.m
//  EC TEL
//
//  Created by pengyunchou on 13-11-1.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import "DataManager.h"
#import "AFNetworking.h"
#import "CN3Config.h"
#import "TBXML.h"
#import "Session.h"
#import "Presentation.h"
#import "Content.h"
#import "Author.h"
#import "RecomentItem.h"
#import "RecomendationItem.h"
#import "BookMarkItem.h"


@interface DataManager()
@property (nonatomic,strong)NSMutableDictionary* allMyreadingList;
@property (nonatomic,strong)NSMutableArray* allsessions;
@property (nonatomic,strong)NSMutableArray* allPresentations;
@property (nonatomic,strong)NSMutableDictionary* allcontents;
@property (nonatomic,strong)NSMutableDictionary* allauthors;
@property (nonatomic,strong)NSOperationQueue* networkoperationqueue;
@property (nonatomic,strong)NSMutableDictionary* myRemarks;
@property (nonatomic,strong)User* theloginuser;
@end
@implementation DataManager

-(void)loadMyfriend:(void (^)(NSArray *friends))oncomplete{
    NSMutableArray* friends=[NSMutableArray array];
    NSString* url=[NSString stringWithFormat:MY_FRIEND_URL,self.loginuser.userid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* str=[[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSASCIIStringEncoding];
        TBXML* xml=[TBXML tbxmlWithXMLString:str];
        if (xml) {
            TBXMLElement*Items=[TBXML childElementNamed:@"Items" parentElement:xml.rootXMLElement];
            if (Items) {
                TBXMLElement* Item=[TBXML childElementNamed:@"Item" parentElement:Items];
                while (Item) {
                    NSMutableDictionary* f=[NSMutableDictionary dictionary];
                    f[@"name"]=[TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:Item]];
                    f[@"requestStatus"]=[TBXML textForElement:[TBXML childElementNamed:@"requestStatus" parentElement:Item]];
                    f[@"userID"]=[TBXML textForElement:[TBXML childElementNamed:@"userID" parentElement:Item]];
                    [friends addObject:f];
                    Item=[TBXML nextSiblingNamed:@"Item" searchFromElement:Item];
                }
            }
        }
        
        if (oncomplete) {
            oncomplete(friends);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        if (oncomplete) {
            oncomplete(nil);
        }
    }];
}
-(void)checkUpdate:(void (^)(NSDate* time))oncomplete{
    NSString* url=[NSString stringWithFormat:CHECK_EVENT_UPDATE,self.conferenceId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* str=[[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSASCIIStringEncoding];
        //NSLog(@"%@",str);
        NSDate* updatetme=nil;
        TBXML* xml=[TBXML tbxmlWithXMLString:str];
        if (xml) {
            TBXMLElement* timestampElement=[TBXML childElementNamed:@"timestamp" parentElement:xml.rootXMLElement];
            if (timestampElement) {
                NSString* timestr=[TBXML textForElement:timestampElement];
                NSLog(@"%@",timestr);
                NSDateFormatter* df=[[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                updatetme=[df dateFromString:timestr];
            }
        }
        
        if (oncomplete) {
            oncomplete(updatetme);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        if (oncomplete) {
            oncomplete(nil);
        }
    }];
}
-(void)rateContentOfId:(NSNumber *)contentId forValue:(int)value{
    NSString* url=[NSString stringWithFormat:RATE_URL,self.loginuser.userid,contentId,@(value)];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* str=[[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSASCIIStringEncoding];
        NSLog(@"%@",str);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
       
    }];
}
-(void)bookmarkContentid:(NSNumber *)cid onComplete:(void (^)(BOOL success))oncomplete{
    NSString* url=[NSString stringWithFormat:BOOKMARK,self.loginuser.userid,cid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* str=[[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSASCIIStringEncoding];
        NSLog(@"%@",str);
        if (oncomplete) {
            oncomplete(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        if (oncomplete) {
            oncomplete(NO);
        }
    }];
}
-(void)unbookmarkContentid:(NSNumber *)cid onComplete:(void (^)(BOOL success))oncomplete{
    NSString* url=[NSString stringWithFormat:UNBOOKMARK,self.loginuser.userid,cid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* str=[[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSASCIIStringEncoding];
        NSLog(@"%@",str);
        if (oncomplete) {
            oncomplete(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        if (oncomplete) {
            oncomplete(NO);
        }
    }];
}
-(NSArray *)parseAllMySchedulesWithXMLStr:(NSString *)xmlstr{
    NSMutableArray* schedules=[NSMutableArray array];
    TBXML* xml=[TBXML tbxmlWithXMLString:xmlstr];
    if (xml) {
        TBXMLElement* items=[TBXML childElementNamed:@"Items" parentElement:xml.rootXMLElement];
        TBXMLElement* item=[TBXML childElementNamed:@"Item" parentElement:items];
        if (item) {
            while (item) {
                BookMarkItem* b=[BookMarkItem new];
                b.eventSessionID=[NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"eventSessionID" parentElement:item]] intValue]];
                b.contentId=[NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"paperID" parentElement:item]] intValue]];
                [schedules addObject:b];
                item=[TBXML nextSiblingNamed:@"Item" searchFromElement:item];
            }
        }
    }

    return schedules;
}
-(void)loadAllMySchedule:(void (^)(NSDictionary* schdules)) oncomplete{
    NSString* url=[NSString stringWithFormat:USER_BOOKMARK,self.loginuser.userid,self.conferenceId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"download all bookmark complete.");
        NSString* str=[[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSASCIIStringEncoding];
        self.myRemarks=[NSMutableDictionary dictionary];
        for (BookMarkItem* b in [self parseAllMySchedulesWithXMLStr:str]) {
            NSString* key=[NSString stringWithFormat:@"%@",b.contentId];
            self.myRemarks[key]=b;
        }
        if (oncomplete) {
            oncomplete(self.myRemarks);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        if (oncomplete) {
            oncomplete(nil);
        }
    }];
    
}
-(void)setLoginuser:(User *)aloginuser{
    self.theloginuser=aloginuser;
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    NSData* userdata=[NSJSONSerialization dataWithJSONObject:[aloginuser asDict] options:NSJSONWritingPrettyPrinted error:nil];
    NSString* userstr=[[NSString alloc] initWithData:userdata encoding:NSUTF8StringEncoding];
    [defaults setValue:userstr forKey:@"loginuser"];
    [defaults synchronize];
}
-(User *)loginuser{
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"loginuser"]!=nil) {
        NSString* userstr=[defaults valueForKey:@"loginuser"];
        NSDictionary* userdict=[NSJSONSerialization JSONObjectWithData:[userstr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (userdict) {
            self.theloginuser=[User fromdict:userdict];
        }
    }
    return self.theloginuser;
}
-(NSString *)authorsTextForContentId:(NSNumber *)contentid{
    NSMutableString* authornamesstr=[NSMutableString string];
    Content *c=[self contentOfId:contentid];
    NSArray* aps=c.authors; 
    for (int i=0;i<[aps count];i++) {
        AuthorPresenter *ap=[aps objectAtIndex:i];
        [authornamesstr appendString:ap.name];
        if (i<[aps count]-1) {
            [authornamesstr appendString:@"-"];
        }
    }
    
    return authornamesstr;
}
-(BOOL)isRemarked:(NSNumber *)contentid{
    NSString* key=[NSString stringWithFormat:@"%@",contentid];
    if (self.myRemarks[key]) {
        return YES;
    }
    return NO;
}
-(void)setRemark:(NSNumber *)contentid remarked:(BOOL)remarked{
    NSString* key=[NSString stringWithFormat:@"%@",contentid];
    if (remarked) {
        BookMarkItem* item=[BookMarkItem new];
        item.contentId=contentid;
        self.myRemarks[key]=item;
    }else{
        //self.myRemarks[key]=nil;
        [self.myRemarks removeObjectForKey:key];
    }
}

-(NSArray *)preceedingContents{
    NSMutableArray* contents=[NSMutableArray array];
    for (NSString* key in self.allcontents) {
        Content* c=self.allcontents[key];
//        if ([c.contentType isEqualToString:@"no-paper"]) {
//            [contents addObject:c];
//        }
        [contents addObject:c];
    }
    return contents;
}
-(NSArray *)getAllAuthors{
    NSMutableArray *allauthors=[NSMutableArray array];
    [allauthors addObjectsFromArray:[self.allauthors allValues]];
    return allauthors;
}
-(NSArray *)getAllContent{
    return [self.allcontents allValues];
}
-(BOOL)isContent:(Content *)c byAuthorId:(NSNumber *)aid{
    BOOL flag=NO;
    int aid_i=[aid intValue];
    NSArray* cas=c.authors;
    for (AuthorPresenter *ap in cas) {
        if ([ap.authorId intValue]==aid_i) {
            flag=YES;
            break;
        }
    }
    return flag;
}
-(NSArray *)contentsByAuthorId:(NSNumber *)aid{
    
    NSMutableArray* contents=[NSMutableArray array];
    for (NSString* key in self.allcontents) {
        Content* c=self.allcontents[key];
        if ([self isContent:c byAuthorId:aid]) {
            [contents addObject:c];
        }
    }
    return contents;
}
-(Author *)authorWithId:(NSNumber *)aid{
    NSString* key=[NSString stringWithFormat:@"%@",aid];
    return self.allauthors[key];
}
-(Session *)sessionOfSessionId:(NSNumber *)sid{
    Session* findsession=nil;
    int sid_i=[sid intValue];
    for (int i=0; i<[self.allsessions count]; i++) {
        Session* s=self.allsessions[i];
        if (sid_i==[s.sID intValue]) {
            findsession=s;
            break;
        }
    }
    return findsession;
}
-(Event *)getEvent{
    Event* event=[Event new];
    [event setEventid:self.conferenceId];
    [event setShortTitle:@"EC-TEL 2013"];
    [event setTitle:@"EC-TEL 2013"];
    [event setAbstraction:@"The European Conference on Technology Enhanced Learning (EC-TEL) is a unique opportunity for researchers, practitioners, and policy makers to address current challenges and advances in the field. "];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
    [event setStartdate:[dateFormatter dateFromString:@"09-17-2013"]];
    [event setEnddate:[dateFormatter dateFromString:@"09-20-2013"]];
    [event setLocation:@"Paphos (Cyprus)"];
    return event;
}
-(Presentation *)presentationOfContentId:(NSNumber *)cid{
    Presentation* findpresentation=nil;
    int cid_i=[cid intValue];
    for (int i=0; i<[self.allPresentations count]; i++) {
        Presentation* p=self.allPresentations[i];
        if ([p.contentId intValue]==cid_i) {
            findpresentation=p;
            break;
        }
    }
    return findpresentation;
}
-(Presentation *)presentationOfPid:(NSNumber *)pid{
    Presentation* findpresentation=nil;
    int pid_i=[pid intValue];
    for (int i=0; i<[self.allPresentations count]; i++) {
        Presentation* p=self.allPresentations[i];
        if ([p.pID intValue]==pid_i) {
            findpresentation=p;
            break;
        }
    }
    return findpresentation;
}
-(NSArray *)presentationsOfSessionId:(NSNumber *)sessionid{
    //NSLog(@"--->%@",sessionid);
    NSMutableArray *ps=[NSMutableArray array];
    for (Presentation* p in self.allPresentations) {
        //NSLog(@"++++>%@",p.sessionId);
        if ([p.sessionId intValue]==[sessionid intValue]) {
            [ps addObject:p];
        }
    }
    return ps;
}
-(Session *)parseOneSession:(TBXMLElement *)element{
    Session* s=[[Session alloc] init];
    s.sTitle=[TBXML textForElement:[TBXML childElementNamed:@"sessionName" parentElement:element]];
    s.sID=[NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"eventSessionID" forElement:element] intValue]];
    s.sType=[TBXML valueOfAttributeNamed:@"displayingRow" forElement:element];
    s.location=[TBXML textForElement:[TBXML childElementNamed:@"location" parentElement:element]];
    NSDateFormatter* df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    s.date=[df dateFromString:[TBXML textForElement:[TBXML childElementNamed:@"sessionDate" parentElement:element]]];
    s.beginTime=[df dateFromString:[TBXML textForElement:[TBXML childElementNamed:@"beginTime" parentElement:element]]];
    s.endTime=[df dateFromString:[TBXML textForElement:[TBXML childElementNamed:@"endTime" parentElement:element]]];
    return s;
}
-(Presentation *)parseOnePrestation:(TBXMLElement *)element{
    Presentation* p=[[Presentation alloc] init];
    p.sessionId=[NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"eventSessionID" forElement:element] intValue]];
    p.contentId=[NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"contentID" forElement:element] intValue]];
    p.pID=[NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"presentationID" forElement:element] intValue]];
    NSDateFormatter* df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    p.date=[df dateFromString:[TBXML textForElement:[TBXML childElementNamed:@"presentationDate" parentElement:element]]];
    p.beginTime=[df dateFromString:[TBXML textForElement:[TBXML childElementNamed:@"beginTime" parentElement:element]]];
    NSString *endtimestr=[TBXML textForElement:[TBXML childElementNamed:@"endTime" parentElement:element]];
    p.endTime=[df dateFromString:endtimestr];
    //NSLog(@"%@,%@,%@",p.pID,endtimestr,p.endTime);
    p.presentationTrack=[TBXML textForElement:[TBXML childElementNamed:@"track" parentElement:element]];
    return p;
}
-(void)parsePresentationXmlString:(NSString *)xmlstr{
    self.allPresentations=[NSMutableArray array];
    TBXML *xml=[TBXML tbxmlWithXMLString:xmlstr];
    if (xml==NULL) {
        return;
    }
    TBXMLElement *presentatonsElement=[TBXML childElementNamed:@"PRESENTATIONS" parentElement:xml.rootXMLElement];
    TBXMLElement* presentation=[TBXML childElementNamed:@"PRESENTATION" parentElement:presentatonsElement];
    while (presentation) {
        [self.allPresentations addObject:[self parseOnePrestation:presentation]];
        presentation=[TBXML nextSiblingNamed:@"PRESENTATION" searchFromElement:presentation];
    }
    //NSLog(@"%@",self.allPresentations);
}
-(void)parseSessonsXmlString:(NSString *)xmlstr{
    //NSLog(@"%@",xml);
    self.allsessions=[NSMutableArray array];
    TBXML *xml=[TBXML tbxmlWithXMLString:xmlstr];
    if (xml==NULL) {
        return;
    }
    TBXMLElement *sessionsElement=[TBXML childElementNamed:@"SESSIONS" parentElement:xml.rootXMLElement];
    TBXMLElement *sessionElement=[TBXML childElementNamed:@"SESSION" parentElement:sessionsElement];
    while (sessionElement) {
        [self.allsessions addObject:[self parseOneSession:sessionElement]];
        sessionElement=[TBXML nextSiblingNamed:@"SESSION" searchFromElement:sessionElement];
    }
}
-(void)downloadEvents:(void(^)(BOOL success))complete{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString* urlstr=[NSString stringWithFormat:ALL_SESSIONS,self.conferenceId];
    [manager GET:urlstr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"download events complete.");
        NSString* str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self parseSessonsXmlString:str];
            [self parsePresentationXmlString:str];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (complete) {
                    complete(YES);
                }
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (complete) {
            complete(NO);
        }
    }];
}
-(Content *)parseOneContent:(TBXMLElement *)element{
    Content* c=[[Content alloc] init];
    c.contentID=[NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"contentID" parentElement:element]] intValue]];
    c.title=[TBXML textForElement:[TBXML childElementNamed:@"title" parentElement:element]];
    c.abstract=[TBXML textForElement:[TBXML childElementNamed:@"abstract" parentElement:element]];
    c.contentType=[TBXML textForElement:[TBXML childElementNamed:@"contentType" parentElement:element]];
    c.track=[TBXML textForElement:[TBXML childElementNamed:@"contentTrack" parentElement:element]];
    c.authors=[NSMutableArray array];
    TBXMLElement* authorsElements=[TBXML childElementNamed:@"authorpresenters" parentElement:element];
    if (authorsElements) {
        TBXMLElement* authorElement=[TBXML childElementNamed:@"authorpresenter" parentElement:authorsElements];
        while (authorElement) {
            AuthorPresenter* ap=[AuthorPresenter new];
            ap.num=[NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"authorNo" parentElement:authorElement]] intValue]];
            ap.authorId=[NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"authorID" parentElement:authorElement]] intValue]];
            ap.name=[TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:authorElement]];
            [c.authors addObject:ap];
            //NSLog(@"%@",c.authors);
            authorElement=[TBXML nextSiblingNamed:@"authorpresenter" searchFromElement:authorElement];
        }
    }
    
    return c;
}

-(void)insertContentToDb:(Content *)c{
    
}
-(Content *)contentOfId:(NSNumber *)cid{
    NSString* key=[NSString stringWithFormat:@"%@",cid];
    return self.allcontents[key];
}
-(void)parseContentsXmlStr:(NSString *)xmlstr{
    //NSLog(@"%@",xmlstr);
    self.allcontents=[NSMutableDictionary dictionary];
    TBXML* xml=[TBXML tbxmlWithXMLString:xmlstr];
    if (xml==NULL) {
        
        return;
    }
    TBXMLElement* contentsElement=[TBXML childElementNamed:@"contents" parentElement:xml.rootXMLElement];
    TBXMLElement* contentElement=[TBXML childElementNamed:@"content" parentElement:contentsElement];
    while (contentElement) {
        Content* c=[self parseOneContent:contentElement];
        NSString* key=[NSString stringWithFormat:@"%@",c.contentID];
        self.allcontents[key]=c;
        contentElement=[TBXML nextSiblingNamed:@"content" searchFromElement:contentElement];
    }
    
}
-(Author *)parseOneAuthor:(TBXMLElement *)element{
    Author *a=[Author new];
    a.authorId=[NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"authorID" parentElement:element]] intValue]];
    a.institute=[TBXML textForElement:[TBXML childElementNamed:@"universityAffiliation" parentElement:element]];
    a.name=[TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:element]];
    a.address=[TBXML textForElement:[TBXML childElementNamed:@"address" parentElement:element]];
    return a;
}
-(void)parseAuthorsXmlStr:(NSString *)xmlstr{
    self.allauthors=[NSMutableDictionary dictionary];
    TBXML* xml=[TBXML tbxmlWithXMLString:xmlstr];
    if (xml==NULL) {
        return;
    }
    TBXMLElement* authorsElement=[TBXML childElementNamed:@"authors" parentElement:xml.rootXMLElement];
    if (!authorsElement) {
        return;
    }
    TBXMLElement* authorElement=[TBXML childElementNamed:@"author" parentElement:authorsElement];
    if (!authorElement) {
        return;
    }
    while (authorElement) {
        Author* a=[self parseOneAuthor:authorElement];
        NSString* key=[NSString stringWithFormat:@"%@",a.authorId];
        self.allauthors[key]=a;
        authorElement=[TBXML nextSiblingNamed:@"author" searchFromElement:authorElement];
    }
    //NSLog(@"%@",self.allauthors);
}
-(void)downLoadContents:(void(^)(BOOL))complete{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString* contentsurl=[NSString stringWithFormat:ALL_CONTENTS,self.conferenceId ];
    NSLog(@"contentsurl:%@",contentsurl);
    [manager POST:contentsurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"download content complete.");
        NSString* str=[[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSASCIIStringEncoding];
        [self parseContentsXmlStr:str];
        [self parseAuthorsXmlStr:str];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(YES);
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        if (complete) {
            complete(NO);
        }
    }];
    
}
-(NSOperationQueue *)networkoperationqueue{
    if (_networkoperationqueue==nil) {
        _networkoperationqueue=[[NSOperationQueue alloc] init];
        _networkoperationqueue.maxConcurrentOperationCount=1;
    }
    return _networkoperationqueue;
}
-(void)downloadData:(void(^)(BOOL))complete{
    [self.networkoperationqueue addOperationWithBlock:^{
        __block BOOL downloadcomplete=NO;
        [self loadAllMySchedule:^(NSDictionary *schdules) {
            downloadcomplete=YES;
        }];
        while (!downloadcomplete) {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate distantFuture]];
        }
    }];
    [self.networkoperationqueue addOperationWithBlock:^{
        __block BOOL downloadcomplete=NO;
        [self downLoadContents:^(BOOL success) {
            downloadcomplete=YES;
            if (!success) {
                [self.networkoperationqueue cancelAllOperations];
                if (complete) {
                    complete(NO);
                }
            }
        }];
        while (!downloadcomplete) {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate distantFuture]];
        }
    }];
    
    [self.networkoperationqueue addOperationWithBlock:^{
        __block BOOL downloadcomplete=NO;
        [self downloadEvents:^(BOOL success) {
            
            downloadcomplete=YES;
            if (!downloadcomplete) {
                [self.networkoperationqueue cancelAllOperations];
                if (complete) {
                    complete(NO);
                }
            }
        }];
        while (!downloadcomplete) {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate distantFuture]];
        }
    }];
    
    [self.networkoperationqueue addOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(YES);
            }
        });
    }];
}
-(NSArray *)getSessionForDate:(NSDate *)date{
    NSMutableArray* sessions=[NSMutableArray array];
    NSDateFormatter* fm=[[NSDateFormatter alloc] init];
    [fm setDateFormat:@"MM-dd"];
    NSString* ds=[fm stringFromDate:date];
    for (Session* s in self.allsessions) {
        NSString* st=[fm stringFromDate:s.date];
        if ([st isEqualToString:ds]) {
            [sessions addObject:s];
        }
    }
    return sessions;
}
-(RecomentItem *)parseRecomendItem:(TBXMLElement *)element{
    RecomentItem* item=[RecomentItem new];
    item.contentID=[NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"contentID" parentElement:element]] intValue]];
    item.title=[TBXML textForElement:[TBXML childElementNamed:@"title" parentElement:element]];
    item.presentationID=[NSNumber numberWithInt:[[TBXML textForElement:[TBXML childElementNamed:@"presentationID" parentElement:element]] intValue]];
    item.contentType=[TBXML textForElement:[TBXML childElementNamed:@"contentType" parentElement:element]];
    return item;
}
-(NSArray* )parseRecomendsXmlStr:(NSString *)xmlstr{
    NSMutableArray *recomends=[NSMutableArray array];
    TBXML *xml=[TBXML tbxmlWithXMLString:xmlstr];
    if (xml==NULL) {
        return @[];
    }
    TBXMLElement* Items=[TBXML childElementNamed:@"Items" parentElement:xml.rootXMLElement];
    if (Items) {
        TBXMLElement *Item=[TBXML childElementNamed:@"Item" parentElement:Items];
        while (Item) {
            [recomends addObject:[self parseRecomendItem:Item]];
            Item=[TBXML nextSiblingNamed:@"Item" searchFromElement:Item];
        }
    }
    return recomends;
}
-(NSArray *)parseUserRecomendataionItems:(NSString *)xmlstr{
    NSMutableArray *res=[NSMutableArray array];
    TBXML *xml=[TBXML tbxmlWithXMLString:xmlstr];
    if (xml) {
        TBXMLElement* Items=[TBXML childElementNamed:@"Items" parentElement:xml.rootXMLElement];
        TBXMLElement* item=[TBXML childElementNamed:@"Item" parentElement:Items];
        while (item) {
            
            RecomendationItem *ri=[RecomendationItem new];
            ri.contentID=[TBXML textForElement:[TBXML childElementNamed:@"contentID" parentElement:item]];
            ri.feedback=[TBXML textForElement:[TBXML childElementNamed:@"feedback" parentElement:item]];
            [res addObject:ri];
            item=[TBXML nextSiblingNamed:@"Item" searchFromElement:item];
        }
    }
    return res;
}
-(void)loadRecomendataion:(void (^)(NSArray *recomends))oncomplete{
    User* u=self.loginuser;
    NSString *url=[NSString stringWithFormat:RECOMENDATION_URL,u.userid,self.conferenceId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* str=[[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSASCIIStringEncoding];
        NSArray* recomens=[self parseUserRecomendataionItems:str];
        if (oncomplete) {
            oncomplete(recomens);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (oncomplete) {
            oncomplete(@[]);
        }
    }];
}

-(void)loadRecomendsOfContentId:(NSNumber *)cid oncomplete:(void(^)(NSArray *recomends))complete{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString* contentsurl=[NSString stringWithFormat:RECOMEND_URL,cid,self.conferenceId,@(5)];
    //NSLog(@"loadRecomendsOfContentId=>%@",contentsurl);
    [manager GET:contentsurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* str=[[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSASCIIStringEncoding];
        NSArray* recomens=[self parseRecomendsXmlStr:str];
        if (complete) {
            complete(recomens);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (complete) {
            complete(@[]);
        }
    }];
}
-(NSDictionary *)getMyReadingList{
    return self.allMyreadingList;
}
-(BOOL)isInReadingList:(NSNumber *)contentid{
    if (self.allMyreadingList[[NSString stringWithFormat:@"%@",contentid]]) {
        return YES;
    }else{
        return NO;
    }
}
-(void)removeReadingList:(NSNumber *)contentid{
    //self.allMyreadingList[[NSString stringWithFormat:@"%@",contentid]]=nil;
    [self.allMyreadingList removeObjectForKey:[NSString stringWithFormat:@"%@",contentid]];
}
-(void)addMyReadingList:(NSNumber *)contentid{
    self.allMyreadingList[[NSString stringWithFormat:@"%@",contentid]]=contentid;
}
-(void)setup{
    self.conferenceId=@(124);
    self.myRemarks=[NSMutableDictionary dictionary];
    self.allMyreadingList=[NSMutableDictionary dictionary];
}

+(DataManager *)sharedMgr{
    static DataManager* _mgr=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mgr=[[DataManager alloc] init];
    });
    return _mgr;
}
@end
