//
//  AuthorListViewController.m
//  EC TEL
//
//  Created by pengyunchou on 13-11-29.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import "AuthorListViewController.h"
#import "DataManager.h"
#import "Author.h"
#import "AppDelegate.h"
#import "AuthorDetailViewController.h"
#import "UIAlertView+Blocks.h"
#import "LoginViewController.h"
@interface AuthorListViewController ()<UIAlertViewDelegate>
@property (nonatomic,strong)NSMutableArray* authorsTitles;
@property (nonatomic,strong)NSMutableDictionary* authordatas;
@property (nonatomic) int index;
@property (nonatomic,strong)NSMutableArray* friends;
@end

@implementation AuthorListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.index=0;
    [self loadAuthors];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.index==0) {
        return [self.authorsTitles count];
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.index==0) {
        NSString* authortitle=self.authorsTitles[section];
        NSArray* authors=self.authordatas[authortitle];
        return [authors count];
    }else{
        if (section==0) {
            return [self.friends count];
        }else{
            return 0;
        }
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PeopleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.index==0) {
        NSString* authortitle=self.authorsTitles[indexPath.section];
        NSArray* authors=self.authordatas[authortitle];
        Author *a=authors[indexPath.row];
        cell.textLabel.text=a.name;
        cell.detailTextLabel.text=@"";
    }else{
        if (indexPath.section==0) {
            NSDictionary* friendItem=self.friends[indexPath.row];
            cell.textLabel.text=friendItem[@"name"];
            NSLog(@"%d",[friendItem[@"requestStatus"] intValue]);
            if ([friendItem[@"requestStatus"] intValue]==1) {
                cell.detailTextLabel.text=@"Waiting for approved";
            }else{
                cell.detailTextLabel.text=@"";
            }
        }else{
            
        }
    }
    return cell;
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.index==0) {
        return self.authorsTitles[section];
    }else{
        if (section==0) {
            return @"Friends";
        }else{
            return @"Friends Request";
        }
    }
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.authorsTitles;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index==0) {
        AuthorDetailViewController *ad=[self.storyboard instantiateViewControllerWithIdentifier:@"AuthorDetailViewController"];
        NSString* authortitle=self.authorsTitles[indexPath.section];
        NSArray* authors=self.authordatas[authortitle];
        AuthorPresenter* ap=authors[indexPath.row];
        Author *author=[[DataManager sharedMgr] authorWithId:ap.authorId];
        ad.author=author;
        [self.navigationController pushViewController:ad animated:YES];
    }
   
}
-(void)loadAuthors{
    self.authordatas=[NSMutableDictionary dictionary];
    NSArray* authors=[[DataManager sharedMgr] getAllAuthors];
    for (Author* a in authors) {
        NSString* title=nil;
        if (a.name==nil||a.name.length<1) {
            title=@"#";
        }else{
            title=[a.name substringToIndex:1];
        }
        title=[title uppercaseString];
        NSMutableArray* as=self.authordatas[title];
        if (as==nil) {
            as=[NSMutableArray array];
            self.authordatas[title]=as;
        }
        [as addObject:a];
    }
    self.authorsTitles=[NSMutableArray array];
    [self.authorsTitles addObjectsFromArray:[self.authordatas allKeys]];
    [self.authorsTitles sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    NSLog(@"%@",self.authordatas);
    [self.tableView reloadData];
}
-(void)loadFriends{
    AppDelegate* del=[UIApplication sharedApplication].delegate;
    [del showLoading];
    [[DataManager sharedMgr] loadMyfriend:^(NSArray *friends) {
        NSLog(@"%@",friends);
        self.friends=[NSMutableArray array];
        [self.friends addObjectsFromArray:friends];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [del hideLoading];
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.segment.selectedSegmentIndex=0;
    if (buttonIndex==0) {
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            LoginViewController* login=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.navigationController pushViewController:login animated:YES];
        });
        
    }
}
- (IBAction)listtypeChanged:(id)sender {
    NSLog(@"lsit type changed");
    UISegmentedControl* seg=sender;
    int index=seg.selectedSegmentIndex;
    if (index==0) {
        self.index=0;
        [self loadAuthors];
    }else{
        if ([DataManager sharedMgr].loginuser==nil) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"" message:@"To see your friends on CN3, please login first." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
            [alert show];
        }else{
            self.index=1;
            [self loadFriends];
        }
        
    }
}
@end
