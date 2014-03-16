//
//  MyProgramViewController.m
//  EC TEL
//
//  Created by pengyunchou on 13-11-30.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import "MyProgramViewController.h"
#import "Recommendatons.h"
#import "LoginViewController.h"
#import "DataManager.h"
#import "MyScheduleViewController.h"
#import "MyReadingListViewController.h"
@interface MyProgramViewController ()
@property (nonatomic,strong)NSMutableArray* tableviewconfigs;
@end

@implementation MyProgramViewController

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
    self.tableviewconfigs=[NSMutableArray array];
    [self.tableviewconfigs addObject:@{
                                       @"name":@"My Schedule",
                                       @"icon":@"myschedule.png"
                                       }];
    [self.tableviewconfigs addObject:@{
                                       @"name":@"My Reading List",
                                       @"icon":@"tags.png"
                                       }];
    [self.tableviewconfigs addObject:@{
                                       @"name":@"Recommendations",
                                       @"icon":@"thumb-25.png"
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableviewconfigs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyProgramCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSDictionary* cellconfig=[self.tableviewconfigs objectAtIndex:indexPath.row];
    cell.imageView.image=[UIImage imageNamed:cellconfig[@"icon"]];
    cell.textLabel.text=cellconfig[@"name"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        
        
        MyScheduleViewController* myschedule=[self.storyboard instantiateViewControllerWithIdentifier:@"MyScheduleViewController"];
        [self.navigationController pushViewController:myschedule animated:YES];
    }else if(indexPath.row==1){
        
        MyReadingListViewController* myreadinglist=[self.storyboard instantiateViewControllerWithIdentifier:@"MyReadingListViewController"];
        [self.navigationController pushViewController:myreadinglist animated:YES];
        
    }else if(indexPath.row==2){
    
        //Recommendatons
        Recommendatons* recomendviewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"Recommendatons"];
        [self.navigationController pushViewController:recomendviewcontroller animated:YES];

        
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
