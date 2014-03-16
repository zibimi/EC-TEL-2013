//
//  SessionListViewController.m
//  EC TEL
//
//  Created by pengyunchou on 13-11-28.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import "SessionListViewController.h"
#import "SessionDetailListViewController.h"
#import "DataManager.h"
#import "Session.h"
@interface SessionListViewController ()<UITableViewDataSource>
@property (nonatomic,strong)Session* selectSession;
@property (nonatomic,strong)NSArray* allsessions;
@property (nonatomic,strong)NSMutableDictionary* sections;
@property (nonatomic,strong)NSMutableArray* sectiontitles;
@end

@implementation SessionListViewController
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sectiontitles count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString* sectiontitle=self.sectiontitles[section];
    NSArray* sessions=self.sections[sectiontitle];
    return [sessions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* sessionTableIdentifier=@"SesstionCell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:sessionTableIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sessionTableIdentifier];
    }
    NSString* sectiontitle=self.sectiontitles[indexPath.section];
    NSArray* sessions=self.sections[sectiontitle];
    Session* s=sessions[indexPath.row];
    cell.textLabel.text=s.sTitle;
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectiontitles[section];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.allsessions=[[DataManager sharedMgr] getSessionForDate:self.day];
    NSDateFormatter* df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    self.sections=[NSMutableDictionary dictionary];
    for (int i=0; i<[self.allsessions count]; i++) {
        Session* s=self.allsessions[i];
        NSString* timelabel=[NSString stringWithFormat:@"%@ - %@",[df stringFromDate:s.beginTime],[df stringFromDate:s.endTime]];
        if (timelabel) {
            NSMutableArray* section=self.sections[timelabel];
            if (section==nil) {
                section=[NSMutableArray array];
                self.sections[timelabel]=section;
            }
            [section addObject:s];
        }
    }
    
    self.sectiontitles=[NSMutableArray array];
    [self.sectiontitles addObjectsFromArray:[self.sections allKeys]];
    [self.sectiontitles sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
	// Do any additional setup after loading the view.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* sectiontitle=self.sectiontitles[indexPath.section];
    NSArray* sessions=self.sections[sectiontitle];
    self.selectSession=sessions[indexPath.row];
    [self performSegueWithIdentifier:@"sessiondetail" sender:self ];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"sessiondetail"])
    {
        SessionDetailListViewController *sessionDetail = segue.destinationViewController;
        sessionDetail.session=self.selectSession;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
