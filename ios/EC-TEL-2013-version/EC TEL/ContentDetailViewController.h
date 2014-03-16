//
//  ContentDetailViewController.h
//  EC TEL
//
//  Created by pengyunchou on 13-11-28.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Content.h"
@interface ContentDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *remarkBtn;
@property (weak, nonatomic) IBOutlet UIButton *myBtn;
@property (nonatomic,strong)Content* content;
- (IBAction)addMarkBtnClicked:(UIButton *)sender;
- (IBAction)addScheduleBtnClicked:(UIButton *)sender;
- (IBAction)shareBtnClicked:(id)sender;
@property (nonatomic,strong)IBOutlet UITableView* tableView;
@property (nonatomic)BOOL canRating;
@end
