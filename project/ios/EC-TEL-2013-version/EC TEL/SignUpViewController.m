//
//  SinupViewController.m
//  EC TEL
//
//  Created by pengyunchou on 13-11-30.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import "SignUpViewController.h"
#import "CN3Config.h"
#import "DataManager.h"
@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Sinup";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.webview.multipleTouchEnabled=YES;
            self.webview.scalesPageToFit=YES;
            NSURL* siginupurl=[NSURL URLWithString:[NSString stringWithFormat:SIGNUP_URL,[DataManager sharedMgr].conferenceId]];
            NSURLRequest* signuprequest=[NSURLRequest requestWithURL:siginupurl];
            self.webview.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            [self.webview loadRequest:signuprequest];
        });
    });
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
