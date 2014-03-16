//
//  ProceedingViewController.m
//  EC TEL
//
//  Created by pengyunchou on 13-11-29.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import "ProceedingViewController.h"
#import "DataManager.h"
#import "StringHelper.h"
#import "Author.h"
#import "ContentDetailViewController.h"
@interface ProceedingViewController ()
@property (nonatomic,strong)NSMutableArray* sectiontitles;
@property (nonatomic,strong)NSMutableDictionary* sectiondatas;
@property (nonatomic,strong)NSMutableArray* allcontents;
@property (nonatomic)int sortOption;
@end

@implementation ProceedingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sectiontitles count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString* sectiontite=self.sectiontitles[section];
    return [self.sectiondatas[sectiontite] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"ProceedingCell"];
    NSArray* section=self.sectiondatas[self.sectiontitles[indexPath.section]];
    Content* c=section[indexPath.row];
    cell.textLabel.text=c.title;
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.detailTextLabel.text=[[DataManager sharedMgr] authorsTextForContentId:c.contentID];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* section=self.sectiondatas[self.sectiontitles[indexPath.section]];
    Content* c=section[indexPath.row];
    float height=[c.title textHeightForSystemFontOfSize:15];
    return height+20;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContentDetailViewController *ct=[self.storyboard instantiateViewControllerWithIdentifier:@"ContentDetailViewController"];
    NSArray* section=self.sectiondatas[self.sectiontitles[indexPath.section]];
    Content* c=section[indexPath.row];
    ct.content=c;
    [self.navigationController pushViewController:ct animated:YES];
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectiontitles;
}
-(void)sort{
    self.sectiondatas=[NSMutableDictionary dictionary];
    if (self.sortOption==0) {
        for (Content*c in self.allcontents) {
            NSArray* authors=c.authors;
            NSString* key=@"";
            if (authors==nil||[authors count]<1) {
                key=@"#";
            }else{
                AuthorPresenter* ap=authors[0];
                Author* a=[[DataManager sharedMgr] authorWithId:ap.authorId];
                if (a==nil||a.name==nil||a.name.length<1) {
                    key=@"#";
                }else{
                    key=[a.name substringToIndex:1];
                }
            }
            key=[key uppercaseString];
            NSMutableArray* section=self.sectiondatas[key];
            if (section==nil) {
                section=[NSMutableArray array];
                self.sectiondatas[key]=section;
            }
            [section addObject:c];
        }
    }else if(self.sortOption==1){
        for (Content*c in self.allcontents) {
            NSString* title=c.title;
            NSString* key=@"";
            if (title==nil||title.length<1) {
                key=@"#";
            }else{
                key=[title substringToIndex:1];
            }
            key=[key uppercaseString];
            NSMutableArray* section=self.sectiondatas[key];
            if (section==nil) {
                section=[NSMutableArray array];
                self.sectiondatas[key]=section;
            }
            [section addObject:c];
        }
    }else{
        for (Content*c in self.allcontents) {
            NSString* title=c.contentType;
            NSString* key=@"";
            if (title==nil||title.length<1) {
                key=@"#";
            }else{
                key=[title substringToIndex:1];
            }
            key=[key uppercaseString];
            NSMutableArray* section=self.sectiondatas[key];
            if (section==nil) {
                section=[NSMutableArray array];
                self.sectiondatas[key]=section;
            }
            [section addObject:c];
        }
    }
    self.sectiontitles=[NSMutableArray array];
    [self.sectiontitles addObjectsFromArray:[self.sectiondatas allKeys]];
    [self.sectiontitles sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
    [self.tableView reloadData];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return  self.sectiontitles[section];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.allcontents=[NSMutableArray array];
    [self.allcontents addObjectsFromArray:[[DataManager sharedMgr] preceedingContents]];
    [self sort];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sortOptionChanged:(UISegmentedControl *)sender {
    self.sortOption=sender.selectedSegmentIndex;
    [self sort];
}
@end
