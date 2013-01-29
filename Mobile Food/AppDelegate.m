//
//  AppDelegate.m
//  Mobile Food
//
//  Created by Lion User on 15.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Products.h"
#import "MainViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//#define kosherListURL [NSURL URLWithString:@"http://46.163.77.113:8080/SKoscher/JSON/ICZ%20Zuerich.json"] //"http://www.uitiwg.ch/products_contents.json"] //"http://api.kivaws.org/v1/loans/search.json?status=fundraising"] //

@interface AppDelegate()

@property NSString *productsPath;
@property NSString *favoritesPath;
@property NSString *communityPath;
@property NSString *kosherPath;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize dataBase;
@synthesize productArray;
@synthesize producerArray;
@synthesize categoryArray;
@synthesize favoriteArray;
@synthesize favoriteIds;
@synthesize favoriteUpdate;
@synthesize productsPath;
@synthesize favoritesPath;
@synthesize communityPath;
@synthesize communitiesArray;
@synthesize kosherPath;
@synthesize kosherListURL;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    productsPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"products.json"];
    favoritesPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"favorites"];
    kosherPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"kosherURL"];
    communityPath = [[NSBundle mainBundle] pathForResource:@"communities" ofType:@"json"];
    kosherListURL = [NSURL URLWithString:[NSString stringWithContentsOfFile:kosherPath encoding:NSUTF8StringEncoding error:nil]];
    dispatch_async(kBgQueue, ^{
        NSError* error;
//        NSString* raw = [NSString stringWithContentsOfURL:kosherListURL encoding:kNilOptions error:&error];
        NSString* filePath = [[NSBundle mainBundle]	pathForResource:@"Data" ofType:@"json"];
        NSString* raw = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"Error: %@", error);
        }
        if(raw == nil) {
            raw = [NSString stringWithContentsOfFile:productsPath encoding:NSUTF8StringEncoding error:nil];
        }else{
            [raw writeToFile:productsPath atomically:YES encoding:NSUTF8StringEncoding error:nil]; 
        }
        NSData* data = [raw dataUsingEncoding:NSUTF8StringEncoding];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    favoriteIds = [[NSMutableArray alloc] initWithContentsOfFile:favoritesPath];
    if (favoriteIds== nil) {
        favoriteIds = [[NSMutableArray alloc]init];
    }
    [self setCommunityData];
    return YES;
}

- (void)setCommunityData {
    NSData *responseData = [[NSString stringWithContentsOfFile:communityPath encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    NSDictionary *communities = [NSJSONSerialization 
                                 JSONObjectWithData:responseData //1
                                 options:NSUTF8StringEncoding
                                 error:&error];
    if(!error){
        NSLog(@"SerializationError: %@", error);
    }
    NSLog(@"%@", communities);
    NSDictionary *comDict = [(NSArray *)communities objectAtIndex:0];
    communitiesArray = [comDict objectForKey:@"communities"];
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error = nil;
    NSDictionary *array = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          options:NSUTF8StringEncoding
                          error:&error];
    if(!error){
        NSLog(@"SerializationError: %@", error);
    }    
    
    NSDictionary* dict = [(NSArray* )array objectAtIndex:0];
    dataBase = [dict objectForKey:@"products"]; //2
    NSSortDescriptor *descriptor =
    [[NSSortDescriptor alloc] initWithKey:@"name"
                              ascending:YES 
                              selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    productArray = [dataBase sortedArrayUsingDescriptors:descriptors];
    
    categoryArray = [self createCategoryDictionary:productArray];
    producerArray = [self createProducerDictionary:productArray];
    favoriteArray = [self createFavoriteDictionary:productArray];
    favoriteUpdate = [[NSMutableArray alloc] initWithArray:favoriteArray];
    
}

- (NSArray *)createCategoryDictionary:(NSArray *)data
{    
    NSMutableArray* values = [data valueForKeyPath:@"@distinctUnionOfObjects.category"];
    NSArray* categoriesArray = [values sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSMutableArray* categoryDictionary = [[NSMutableArray alloc] init];
    for (int i=0; i<[categoriesArray count]; i++) {
        NSMutableArray* keys = [[NSMutableArray alloc] initWithCapacity: 2];
        [keys addObject:@"name"];
        [keys addObject:@"products"];
        NSMutableArray* values = [[NSMutableArray alloc] initWithCapacity:2];
        
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"category contains[cd] %@",[categoriesArray objectAtIndex:i]];
        
        [values addObject:[categoriesArray objectAtIndex:i]];
        [values addObject:[data filteredArrayUsingPredicate:resultPredicate]];
        
        NSMutableDictionary* newDictionary = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];
        
        [categoryDictionary addObject:newDictionary];
    }
    
    return categoryDictionary;
}

- (NSArray *)createProducerDictionary:(NSArray *)data
{    
    NSMutableArray* values = [data valueForKeyPath:@"@distinctUnionOfObjects.producer"];
    NSArray* producersArray = [values sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSMutableArray* producerDictionary = [[NSMutableArray alloc] init];
    for (int i=0; i<[producersArray count]; i++) {
        NSMutableArray* keys = [[NSMutableArray alloc] initWithCapacity: 2];
        [keys addObject:@"name"];
        [keys addObject:@"products"];
        NSMutableArray* values = [[NSMutableArray alloc] initWithCapacity:2];
        
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"producer contains[cd] %@",[producersArray objectAtIndex:i]];
        
        [values addObject:[producersArray objectAtIndex:i]];
        [values addObject:[data filteredArrayUsingPredicate:resultPredicate]];
        
        NSMutableDictionary* newDictionary = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];
        
        [producerDictionary addObject:newDictionary];
    }
    return producerDictionary;
}

- (NSMutableArray *)createFavoriteDictionary:(NSArray *)data
{
    NSMutableArray* favArray = [[NSMutableArray alloc] init];
    
    if([favoriteIds count]==0)
        return favArray;
    for(NSDictionary* dict in data) {
        int value = [[dict valueForKey:@"id"] intValue];
        for(NSNumber* array in favoriteIds){
            if(value == [array intValue] ){
                [favArray addObject:dict];
            }
        }
    }
    return favArray;
}

- (void)updateFavoriteArray
{
//    NSLog(@"Favorites Updated");
    favoriteArray = favoriteUpdate;
    favoriteUpdate = [[NSMutableArray alloc]initWithArray:favoriteArray];
    [favoriteIds writeToFile:favoritesPath atomically:YES];
//    NSLog(@"check: %@", [[NSArray alloc]initWithContentsOfFile:favoritesPath]);
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [favoriteIds writeToFile:favoritesPath atomically:YES];
    NSLog(@"enter background");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [productArray writeToFile:productsPath atomically:YES];
    [favoriteIds writeToFile:favoritesPath atomically:YES];
    NSLog(@"Terminate");
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Products.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
