//
//  ConferenceViewController.m
//  EC TEL
//
//  Created by pengyunchou on 13-11-4.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import "ConferenceViewController.h"
#import "SessionListViewController.h"
#import "Event.h"
#import "DataManager.h"
#import "MRProgress.h"
#import "AppDelegate.h"
#import "StringHelper.h"
#import "ContentDetailViewController.h"
@interface ConferenceViewController ()<UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate>
@property (nonatomic,strong)Event* event;
@property (nonatomic,strong)NSDate* selectDate;
@property (nonatomic,strong)NSMutableArray* contents;
@property BOOL inSearch;
@end

@implementation ConferenceViewController
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.contents=[NSMutableArray array];
    for (Content* c in [[DataManager sharedMgr] getAllContent]) {
        if ([c.title rangeOfString:searchText options:NSDiacriticInsensitiveSearch].location!=NSNotFound) {
            [self.contents addObject:c];
        }
    }
    [self.tableView reloadData];
}
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    self.inSearch=YES;
}
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    self.inSearch=NO;
    NSLog(@"searchDisplayControllerDidEndSearch");
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.inSearch) {
        return [self.contents count];
    }else{
        if (self.event) {
            //计算时间
            NSTimeInterval time = [self.event.enddate timeIntervalSinceDate:self.event.startdate];
            int days = time/60/60/24;
            return days +1;
        }else{
            return 0;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ConferenceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (self.inSearch) {
        Content* c=self.contents[indexPath.row];
        cell.textLabel.text=c.title;
        cell.detailTextLabel.text=c.contentType;
    }else{
        [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
        NSDateComponents *dc = [[NSDateComponents alloc] init];
        [dc setDay:indexPath.row];
        NSDate *day = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:self.event.startdate options:0];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"EEEE"];
        cell.textLabel.text = [dateformatter stringFromDate:day];
        [dateformatter setDateFormat:@"MMMM dd"];
        cell.detailTextLabel.text = [dateformatter stringFromDate:day];
    }
    
    return  cell;
}
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.inSearch) {
        return @"";
    }else{
       return @"Conference Program";
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.inSearch) {
        Content *c=self.contents[indexPath.row];
        ContentDetailViewController *ct=[self.storyboard instantiateViewControllerWithIdentifier:@"ContentDetailViewController"];
        ct.content=c;
        [self.navigationController pushViewController:ct animated:YES];
    }else{
        NSDateComponents *dc = [[NSDateComponents alloc] init];
        [dc setDay:indexPath.row];
        self.selectDate = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:self.event.startdate options:0];
        [self performSegueWithIdentifier:@"showsessions" sender:self];
    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showsessions"])
    {
        SessionListViewController *sessionlist = segue.destinationViewController;
        sessionlist.day=self.selectDate;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.inSearch) {
        Content* c=self.contents[indexPath.row];
        float height=[c.title textHeightForSystemFontOfSize:15];
        return height+20;
    }else{
        return 44;
    }
    
}
-(void)downlaodData:(void (^)(BOOL success))complete{
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    [appdelegate showLoading];
    [[DataManager sharedMgr] downloadData:^(BOOL success){
        if (success) {
            self.event=[[DataManager sharedMgr] getEvent];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        complete(success);
        [appdelegate hideLoading];
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self downlaodData:^(BOOL success) {
        if (!success) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"" message:@"down load data faild. please refresh to download again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }];
#define debugme
#ifndef debugme
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"firstrun"]==nil) {
        [defaults setValue:@"no" forKey:@"firstrun"];
        [self downlaodData];
    }
#endif
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRefreshBtnClicked:(id)sender {

    [[DataManager sharedMgr] checkUpdate:^(NSDate* updatetime) {
        if (updatetime==nil) {
            [self alert:@"can not check update." delayHide:1];
            return ;
        }else{
            NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
            NSDate* lastupdate=nil;
#ifdef DEBUG
            [defaults setValue:nil forKey:@"lastupdatetime"];
            [defaults synchronize];
#endif
            NSDateFormatter* df=[[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
            if ([defaults objectForKey:@"lastupdatetime"]==nil) {
                lastupdate=[NSDate date];
            }else{
                NSString* lastupdatestr=[defaults valueForKey:@"lastupdatetime"];
                lastupdate=[df dateFromString:lastupdatestr ];
                NSLog(@"%@",lastupdatestr);
            }
            int distanse=[updatetime timeIntervalSinceDate:lastupdate];
            
            if (distanse!=0) {
                [self downlaodData:^(BOOL success) {
                    NSString* lastupdatestr=[df stringFromDate:updatetime];
                    [defaults setValue:lastupdatestr forKey:@"lastupdatetime"];
                }];
            }else{
                [self alert:@"It's already updated!" delayHide:1];
            }
        }
        
    }];
    
}
@end
