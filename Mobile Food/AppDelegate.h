//
//  AppDelegate.h
//  Mobile Food
//
//  Created by Lion User on 15.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSArray *dataBase;
@property (readonly, strong, nonatomic) NSArray *productArray;
@property (readonly, strong, nonatomic) NSArray *producerArray;
@property (readonly, strong, nonatomic) NSArray *categoryArray;
@property (readonly, strong, nonatomic) NSMutableArray *favoriteArray;
@property (strong) NSMutableArray *favoriteIds;
@property (strong) NSMutableArray *favoriteUpdate;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)updateFavoriteArray;

@end
