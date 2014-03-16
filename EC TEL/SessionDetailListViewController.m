//
//  SessionDetailListViewController.m
//  EC TEL
//
//  Created by pengyunchou on 13-11-28.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import "SessionDetailListViewController.h"
#import "Presentation.h"
#import "DataManager.h"
#import "ContentDetailViewController.h"
@interface SessionDetailListViewController ()
@property (nonatomic,strong)NSArray *sectiontitles;
@property (nonatomic,strong)NSMutableDictionary* sections;
@property (nonatomic,strong)Content* selectContent;
@end

@implementation SessionDetailListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=self.session.sTitle;
    self.sections=[NSMutableDictionary dictionary];
    NSArray* allpresentations=[[DataManager sharedMgr] presentationsOfSessionId:self.session.sID];
    //NSLog(@"%@",allpresentations);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd"];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    for (Presentation* p in allpresentations) {
        NSString* key = [NSString stringWithFormat:@"%@, %@ - %@",[dateFormatter stringFromDate:self.session.date], [timeFormatter stringFromDate:self.session.beginTime], [timeFormatter stringFromDate: self.session.endTime]];
        NSMutableArray* sectiondatas=self.sections[key];
        if (sectiondatas==nil) {
            sectiondatas=[NSMutableArray array];
            self.sections[key]=sectiondatas;
        }
        [sectiondatas addObject:p];
    }
    self.sectiontitles=[self.sections allKeys];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sectiontitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* sectiontitle=[self.sectiontitles objectAtIndex:section];
    NSArray* sectiondatas=self.sections[sectiontitle];
    return [sectiondatas count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sectiontitles objectAtIndex:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* sectiontitle=[self.sectiontitles objectAtIndex:indexPath.section];
    NSArray* sectiondatas=self.sections[sectiontitle];
    Presentation* p=sectiondatas[indexPath.row];
    Content* c=[[DataManager sharedMgr] contentOfId:p.contentId];
    CGSize constraint = CGSizeMake(320-30, 20000.0f);
    CGSize size = [c.title sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:constraint];
    CGFloat height = MAX(size.height, 22.0f);
    return height+ 10*2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.numberOfLines =3;
    }
    NSString* sectiontitle=[self.sectiontitles objectAtIndex:indexPath.section];
    NSArray* sectiondatas=self.sections[sectiontitle];
    Presentation* p=sectiondatas[indexPath.row];
    Content* c=[[DataManager sharedMgr] contentOfId:p.contentId];
    
    cell.textLabel.text = c.title ;
    cell.detailTextLabel.text=c.contentType;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* sectiontitle=[self.sectiontitles objectAtIndex:indexPath.section];
    NSArray* sectiondatas=self.sections[sectiontitle];
    Presentation* p=sectiondatas[indexPath.row];
    Content* c=[[DataManager sharedMgr] contentOfId:p.contentId];
    self.selectContent=c;
    [self performSegueWithIdentifier:@"contentdetail" sender:self ];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"contentdetail"])
    {
        ContentDetailViewController *sessionDetail = segue.destinationViewController;
        self.selectContent.sessionId=self.session.sID;
        sessionDetail.content=self.selectContent;
    }
}

@end
