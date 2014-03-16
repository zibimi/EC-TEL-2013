//
//  NetUtil.m
//  UMAP
//
//  Created by Gang on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetUtil.h"
#import "Reachability.h"

#define NET_FAIL 0;
#define WIFI_OK 1;
#define WAN_OK 2;
#define HOST_OK 3;
@implementation NetUtil

+(NSInteger) checkNetworkStatus:(id) sender{

    NetworkStatus hostStatus = [[Reachability reachabilityWithHostName:
                                  @"halley.exp.sis.pitt.edu"]currentReachabilityStatus];
    switch (hostStatus)
    
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            return NET_FAIL;
            break;
            
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            return HOST_OK;
            break;
            
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            return HOST_OK;
            break;
            
        }default:{
            
            return NET_FAIL;
        }
    }
    
    
}
@end
