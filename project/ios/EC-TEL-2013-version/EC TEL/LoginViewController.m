//
//  LoginViewController.m
//  EC TEL
//
//  Created by pengyunchou on 13-11-30.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import "LoginViewController.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "CN3Config.h"
#import "TBXML.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.canceld=NO;
    }
    return self;
}
-(BOOL)isNilString:(NSString *)str{
    if (str==nil||str.length==0) {
        return YES;
    }else{
        return NO;
    }
}

-(User *)parseUser:(TBXML *)xml{
    TBXMLElement* Items=[TBXML childElementNamed:@"Items" parentElement:xml.rootXMLElement];
    if (Items) {
        TBXMLElement* Item=[TBXML childElementNamed:@"Item" parentElement:Items];
        if (Item) {
            User* u=[User new];
            u.userid=[TBXML textForElement:[TBXML childElementNamed:@"UserID" parentElement:Item]];
            u.name=[TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:Item]];
            u.username=[TBXML textForElement:[TBXML childElementNamed:@"username" parentElement:Item]];
            u.email=[TBXML textForElement:[TBXML childElementNamed:@"email" parentElement:Item]];
            u.roleid=[TBXML textForElement:[TBXML childElementNamed:@"UserroleID" parentElement:Item]];
            u.sessionId=[TBXML textForElement:[TBXML childElementNamed:@"UserSessionID" parentElement:Item]];
            return u;
        }
    }
    return nil;
}
- (IBAction)loginBtnClicked:(UIButton *)sender {
    NSString* username=self.usernameField.text;
    NSString* password=self.passwordField.text;
    if ([self isNilString:username]) {
        [self alert:@"Please input Username." delayHide:1];
        return;
    }
    if ([self isNilString:password]) {
        [self alert:@"Please input Password." delayHide:1];
        return;
    }
    //LOGIN_URL
    AppDelegate* appdelegate=[UIApplication sharedApplication].delegate;
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [appdelegate showLoading];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"email": username,
                                 @"password":password
                                 };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:LOGIN_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        TBXML* xml=[TBXML tbxmlWithXMLString:str];
        if (xml) {
            TBXMLElement* statuselement=[TBXML childElementNamed:@"status" parentElement:xml.rootXMLElement];
            NSString* status=[TBXML textForElement:statuselement];
            if (![status isEqualToString:@"OK"]) {
                NSString* msg=nil;
                TBXMLElement* msgelement=[TBXML childElementNamed:@"message" parentElement:xml.rootXMLElement];
                msg=[TBXML textForElement:msgelement];
                [self alert:msg delayHide:1];
            }else{
                [DataManager sharedMgr].loginuser=[self parseUser:xml];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [self alert:@"Login fail." delayHide:1];
        }
        [appdelegate hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [appdelegate hideLoading];
    }];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if ([DataManager sharedMgr].loginuser==nil) {
        self.canceld=YES;
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.canceld=NO;
#ifdef DEBUG
    self.usernameField.text=@"jig32@pitt.edu";
    self.passwordField.text=@"8872975";
#endif
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
