//
//  AuthorListViewController.h
//  EC TEL
//
//  Created by pengyunchou on 13-11-29.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorListViewController : UITableViewController
- (IBAction)listtypeChanged:(id)sender;
@property (nonatomic,strong)IBOutlet UISegmentedControl *segment;
@end
