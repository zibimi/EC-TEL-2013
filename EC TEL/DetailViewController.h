//
//  DetailViewController.h
//  EC TEL
//
//  Created by pengyunchou on 10/29/13.
//  Copyright (c) 2013 skysent.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
