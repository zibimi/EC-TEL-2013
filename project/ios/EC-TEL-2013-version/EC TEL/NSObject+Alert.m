//
//  NSObject+Alert.m
//  EC TEL
//
//  Created by pengyunchou on 13-11-30.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import "NSObject+Alert.h"

@implementation NSObject (Alert)
-(void)alert:(NSString *)msg delayHide:(float)hidetime{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    double delayInSeconds = hidetime;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}
@end
