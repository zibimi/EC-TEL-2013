//
//  AppDelegate.h
//  EC TEL
//
//  Created by pengyunchou on 10/29/13.
//  Copyright (c) 2013 skysent.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRProgress.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic,strong)MRProgressOverlayView* progress;
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)showLoading;
-(void)hideLoading;
@end
