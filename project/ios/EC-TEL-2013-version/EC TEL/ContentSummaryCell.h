//
//  ContentSummaryCell.h
//  EC TEL
//
//  Created by pengyunchou on 13-11-29.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentSummaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionLabel;

@end
