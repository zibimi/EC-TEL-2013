//
//  RecomentItem.h
//  EC TEL
//
//  Created by pengyunchou on 13-11-29.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecomentItem : NSObject
@property (nonatomic,strong)NSNumber *contentID;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSNumber* presentationID;
@property (nonatomic,strong)NSNumber* bookmarkno;
@property (nonatomic,strong)NSString* contentType;
@end
