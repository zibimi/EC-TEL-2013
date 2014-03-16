//
//  AuthorDetailViewController.m
//  EC TEL
//
//  Created by pengyunchou on 13-11-29.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import "AuthorDetailViewController.h"
#import "DataManager.h"
#import "ContentDetailViewController.h"
@interface AuthorDetailViewController ()
@property (nonatomic,strong)NSMutableArray* contents;
@end

@implementation AuthorDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=self.author.name;
    self.contents=[NSMutableArray array];
    [self.contents addObjectsFromArray:[[DataManager sharedMgr] contentsByAuthorId:self.author.authorId]];
    //NSLog(@"%@",self.contents);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.contents count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"AuthorPresentationCell"];
    Content* c=self.contents[indexPath.row];
    cell.textLabel.text=c.title;
    cell.detailTextLabel.text=c.contentType;
    return cell;
    
}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        ContentDetailViewController *ct=[self.storyboard instantiateViewControllerWithIdentifier:@"ContentDetailViewController"];
        Content* c=self.contents[indexPath.row];
        ct.content=c;
        [self.navigationController pushViewController:ct animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
