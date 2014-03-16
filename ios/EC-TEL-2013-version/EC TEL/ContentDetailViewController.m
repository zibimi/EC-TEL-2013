//
//  ContentDetailViewController.m
//  EC TEL
//
//  Created by pengyunchou on 13-11-28.
//  Copyright (c) 2013年 skysent.cn. All rights reserved.
//

#import "ContentDetailViewController.h"
#import "Author.h"
#import "Content.h"
#import "DataManager.h"
#import "RecomentItem.h"
#import "ContentSummaryCell.h"
#import "AuthorDetailViewController.h"
#import "LoginViewController.h"
#import "RatingView.h"
@interface ContentDetailViewController ()<UIActionSheetDelegate,RatingViewDelegate>
@property (nonatomic,strong)NSMutableArray *authors;
@property (nonatomic,strong)NSMutableArray *recommendation;
@property (nonatomic,strong)RatingView* ratingview;
@property (nonatomic,strong)UIView* ratingviewContainer;
@property (nonatomic)int currentRate;
@end

@implementation ContentDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}
-(void)onRateSubmit{
    [[DataManager sharedMgr] rateContentOfId:self.content.contentID forValue:self.currentRate];
    self.ratingviewContainer.userInteractionEnabled=NO;
    [self.ratingviewContainer removeFromSuperview];
    [self alert:@"Thak you!" delayHide:1.0];
}
-(void)onRateBtnClicked{
    if ([DataManager sharedMgr].loginuser==nil) {
        LoginViewController* login=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    self.ratingviewContainer=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    self.ratingviewContainer.backgroundColor=[UIColor whiteColor];
    self.ratingviewContainer.center=self.view.center;
    self.ratingviewContainer.layer.borderColor=[UIColor blueColor].CGColor;
    self.ratingviewContainer.layer.borderWidth=1;
    self.ratingviewContainer.layer.cornerRadius=5;
    
    self.ratingview=[[RatingView alloc] initWithFrame:CGRectMake((300-120)/2, (150-50)/2-10, 120, 50)];
    
    [self.ratingview setImagesDeselected:@"0.png" partlySelected:@"1.png" fullSelected:@"2.png" andDelegate:self];
    self.currentRate=0;
    
	[self.ratingview displayRating:self.currentRate];
    //self.ratingview.center=self.ratingviewContainer.center;
    [self.ratingviewContainer addSubview:self.ratingview];
    UIButton* btn=[[UIButton alloc] initWithFrame:CGRectMake((300-100)/2, 150-44-15, 100, 44)];
    [btn setTitle:@"Submit" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor greenColor];
    [btn addTarget:self action:@selector(onRateSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self.ratingviewContainer addSubview:btn];
    [self.view addSubview:self.ratingviewContainer];
}
-(void)ratingChanged:(float)newRating{
    self.currentRate=newRating;
}
-(void)loadRecomendsAsync{
    [[DataManager sharedMgr] loadRecomendsOfContentId:self.content.contentID oncomplete:^(NSArray *recomends) {
        self.recommendation=[NSMutableArray array];
        [self.recommendation addObjectsFromArray:recomends];
        [self.tableView reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    self.authors=[NSMutableArray array];
    //NSLog(@"------%@",self.content.authors);
    [self.authors addObjectsFromArray:self.content.authors];
    [self loadRecomendsAsync];
    [self updateMyReadingBtn];
    [self updateSchduleBtn];
    if (self.canRating) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"✡RATE✡" style:UIBarButtonItemStyleBordered target:self action:@selector(onRateBtnClicked)];
    }else{
        self.navigationItem.rightBarButtonItem=nil;
    }
    //self.title=self.content.title;
}
- (CGFloat) cellHeightForText:(NSString *) text  fontsize:(float)fontsize{
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:fontsize];
    CGSize constraintSize = CGSizeMake(300.0f, MAXFLOAT);
    CGSize labelSize = [text sizeWithFont:cellFont constrainedToSize:constraintSize /*lineBreakMode:UILineBreakModeWordWrap*/];
    
    return labelSize.height + 5;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
	{
		return 2;
	}else if(section==1){
        return 1;
    }
	else if (section ==2) {
		return [self.authors count];
	}else if(section ==3) {
        if ([self.recommendation count] ==0){
            return 1;
        }else{
            return [self.recommendation count];
        }
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0){
        if (indexPath.row==0) {
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ContentTitleCell"];
            cell.textLabel.text=self.content.title;
            return cell;
        }else{
            static NSString* ContentSummaryCellIdentifier=@"ContentSummaryCell";
            ContentSummaryCell *cell=[tableView dequeueReusableCellWithIdentifier:ContentSummaryCellIdentifier];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MMM d"];
            
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setDateFormat:@"HH:mm"];
            Presentation* p=[[DataManager sharedMgr] presentationOfContentId:self.content.contentID];
            if (p) {
                Session *s=[[DataManager sharedMgr] sessionOfSessionId:p.sessionId];
                if (s) {
                    cell.sessionLabel.text=s.sTitle;
                }
                cell.dateLabel.text=[NSString stringWithFormat: @"%@, %@ - %@",[dateFormatter stringFromDate: p.date], [timeFormatter stringFromDate: p.beginTime],[timeFormatter stringFromDate: p.endTime] ];
                if (s.location == NULL || [s.location isEqualToString:@"null"]) {
                    cell.roomLabel.text = @"TBA";
                }else{
                    cell.roomLabel.text = s.location;
                }
            }
            cell.typeLabel.text=self.content.contentType;
            return cell;
        }
    }else if(indexPath.section==1){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        }
        cell.textLabel.text= self.content.abstract;
        return cell;
    }
    else if(indexPath.section ==2){
        static NSString *CellIdentifier = @"AuthorCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		}
        
        AuthorPresenter *ap =  [self.authors objectAtIndex:indexPath.row];
		cell.textLabel.text = ap.name;
        //cell.detailTextLabel.text = author.institute;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else {
        static NSString *CellIdentifier = @"RecomCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		}
        if([self.recommendation count] == 0){
            cell.detailTextLabel.text = @"No Records";
        }else{
            RecomentItem *recitem =[self.recommendation objectAtIndex:indexPath.row];
            cell.textLabel.text = recitem.title;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
            cell.textLabel.numberOfLines = 2;
            //cell.textLabel.minimumFontSize = 10;
            cell.detailTextLabel.text = recitem.contentType;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section ==0) {
        return @"";
    }else if(section==1){
        return @"Abstract/ Click for whole paper";
    }
    else if(section == 2)  {
        return @"Authors/Presenters";
    }else if(section == 3)  {
        return @"Recommendation";
    }
    return @"";
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if (indexPath.row==0) {
            return [self cellHeightForText:self.content.title fontsize:18];
        }else{
            return 100;
        }
    }else if(indexPath.section==1){
        return [self cellHeightForText:self.content.abstract fontsize:14] ;
    }
    else if(indexPath.section == 2){
        return 30.0f;
    }else{
        return 55.0f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        AuthorDetailViewController *ad=[self.storyboard instantiateViewControllerWithIdentifier:@"AuthorDetailViewController"];
        AuthorPresenter* ap=self.authors[indexPath.row];
        Author *author=[[DataManager sharedMgr] authorWithId:ap.authorId];
        ad.author=author;
        [self.navigationController pushViewController:ad animated:YES];
    }else if(indexPath.section==3){
        if ([self.recommendation count]>0) {
            ContentDetailViewController *ct=[self.storyboard instantiateViewControllerWithIdentifier:@"ContentDetailViewController"];
            ct.canRating=YES;
            RecomentItem *recitem =[self.recommendation objectAtIndex:indexPath.row];
            Content* c=[[DataManager sharedMgr] contentOfId:recitem.contentID];
            Presentation* p=[[DataManager sharedMgr] presentationOfPid:recitem.presentationID];
            c.sessionId=p.sessionId;
            ct.content=c;
            [self.navigationController pushViewController:ct animated:YES];
        }
    }
}

- (IBAction)addMarkBtnClicked:(UIButton *)sender {
    if ([DataManager sharedMgr].loginuser==nil) {
        LoginViewController *login=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:login animated:YES];
    }else{
        BOOL isinreading=[[DataManager sharedMgr] isInReadingList:self.content.contentID];
        BOOL newstate=!isinreading;
        if (newstate) {
            [[DataManager sharedMgr] addMyReadingList:self.content.contentID];
        }else{
            [[DataManager sharedMgr] removeReadingList:self.content.contentID];
        }
        [self updateMyReadingBtn];
        NSString* msg=nil;
        if (newstate) {
            [[DataManager sharedMgr] bookmarkContentid:self.content.contentID onComplete:^(BOOL success) {
                
            }];
            msg=@"Saved to list.";
        }else{
            msg=@"Removed from saved list.";
            [[DataManager sharedMgr] unbookmarkContentid:self.content.contentID onComplete:^(BOOL success) {
                
            }];
        }
    }
}
-(void)updateMyReadingBtn{
    BOOL isinreading=[[DataManager sharedMgr] isInReadingList:self.content.contentID];
    self.remarkBtn.selected=isinreading;
}
-(void)updateSchduleBtn{
    BOOL isinreading=[[DataManager sharedMgr] isRemarked:self.content.contentID];
    if (isinreading) {
        [self.myBtn setImage:[UIImage imageNamed:@"calendar_delete"] forState:UIControlStateNormal];
    }else{
        [self.myBtn setImage:[UIImage imageNamed:@"calendar_add"] forState:UIControlStateNormal];
    }
}
- (IBAction)addScheduleBtnClicked:(UIButton *)sender {
    if ([DataManager sharedMgr].loginuser==nil) {
        LoginViewController *login=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    BOOL isremarkd=![[DataManager sharedMgr] isRemarked:self.content.contentID];
    [[DataManager sharedMgr] setRemark:self.content.contentID remarked:isremarkd];
    [self updateSchduleBtn];
    NSString* msg=nil;
    if (isremarkd) {
        [[DataManager sharedMgr] bookmarkContentid:self.content.contentID onComplete:^(BOOL success) {
            
        }];
        msg=@"Saved to list.";
    }else{
        msg=@"Removed from saved list.";
        [[DataManager sharedMgr] unbookmarkContentid:self.content.contentID onComplete:^(BOOL success) {
            
        }];
    }
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
    
}

- (IBAction)shareBtnClicked:(id)sender {
    UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:@"Share Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Email" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
}
@end
