//
//  MyScheduleViewController.m
//  EC TEL
//
//  Created by pengyunchou on 13-11-30.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import "MyScheduleViewController.h"
#import "DataManager.h"
#import "BookMarkItem.h"
#import "AppDelegate.h"
#import "ContentDetailViewController.h"
@interface MyScheduleViewController ()
@property (nonatomic,strong)NSArray* sectiontitles;
@property (nonatomic,strong)NSMutableDictionary* sectiondatas;
@end

@implementation MyScheduleViewController

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
    AppDelegate* delegate=[UIApplication sharedApplication].delegate;
    [delegate showLoading];
    [[DataManager sharedMgr] loadAllMySchedule:^(NSDictionary *schdules) {
        self.sectiondatas=[NSMutableDictionary dictionary];
        for (NSString* key in schdules) {
            BookMarkItem* item=schdules[key];
            Presentation* p=[[DataManager sharedMgr] presentationOfContentId:item.contentId];
            Content* c=[[DataManager sharedMgr] contentOfId:item.contentId];
            NSString* sectiontitle=[NSString stringWithFormat:@"%@",p.sessionId];
            NSMutableArray* section=self.sectiondatas[sectiontitle];
            if (section==nil) {
                section=[NSMutableArray array];
                self.sectiondatas[sectiontitle]=section;
            }
            if (c) {
                [section addObject:c];
            }
            
        }
        self.sectiontitles=[self.sectiondatas allKeys];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [delegate hideLoading];
    }];
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
    return [self.sectiontitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* sectiontitle=self.sectiontitles[section];
    NSArray* sectiondata=self.sectiondatas[sectiontitle];
    return  [sectiondata count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 26.0)];
	customView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.9];
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    UILabel *detailLabel =[[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor blackColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:14];
	headerLabel.frame = CGRectMake(5.0, 0.0, 300.0, 16.0);
    detailLabel.backgroundColor = [UIColor clearColor];
	detailLabel.opaque = NO;
	detailLabel.textColor = [UIColor blackColor];
	detailLabel.highlightedTextColor = [UIColor whiteColor];
	detailLabel.font = [UIFont boldSystemFontOfSize:12];
	detailLabel.frame = CGRectMake(5.0, 15.0, 300.0, 14.0);
    NSString* sesstiontitle=[self.sectiontitles objectAtIndex:section];
    Session *tempSession = [[DataManager sharedMgr] sessionOfSessionId:@([sesstiontitle intValue])];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd"];
    [timeFormatter setDateFormat:@"HH:mm"];
	headerLabel.text = [NSString stringWithFormat:@"%@", tempSession.sTitle];// i.e. array element
    
    detailLabel.text = [NSString stringWithFormat:@"%@ %@-%@",[dateformatter stringFromDate:tempSession.date], [timeFormatter stringFromDate:tempSession.beginTime], [timeFormatter stringFromDate:tempSession.endTime]];
	[customView addSubview:headerLabel];
    [customView addSubview:detailLabel];
	return customView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyScheduleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString* sectiontitle=[self.sectiontitles objectAtIndex:indexPath.section];
    //Session *tempSession = [[DataManager sharedMgr] sessionOfSessionId:@([sectiontitle intValue])];
    Content *pres =  [self.sectiondatas[sectiontitle] objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    //[cell.textLabel setMinimumFontSize:12];
    cell.textLabel.numberOfLines =2;
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    Presentation *tempPresentation = [[DataManager sharedMgr] presentationOfContentId:pres.contentID];
    cell.textLabel.text = pres.title ;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@%@",[timeFormatter stringFromDate:tempPresentation.beginTime ],[timeFormatter stringFromDate:tempPresentation.endTime], [[DataManager sharedMgr] authorsTextForContentId:pres.contentID]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContentDetailViewController *ct=[self.storyboard instantiateViewControllerWithIdentifier:@"ContentDetailViewController"];
    NSString* sectiontitle=[self.sectiontitles objectAtIndex:indexPath.section];
    //Session *tempSession = [[DataManager sharedMgr] sessionOfSessionId:@([sectiontitle intValue])];
    Content* c =  [self.sectiondatas[sectiontitle] objectAtIndex:indexPath.row];
    Presentation* p=[[DataManager sharedMgr] presentationOfContentId:c.contentID];
    c.sessionId=p.sessionId;
    ct.content=c;
    [self.navigationController pushViewController:ct animated:YES];
}

@end
