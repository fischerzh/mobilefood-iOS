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
#define kosherListURL [NSURL URLWithString:@"http://www.uitiwg.ch/products_contents.json"] //"http://api.kivaws.org/v1/loans/search.json?status=fundraising"] //

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize dataBase;
@synthesize productArray;
@synthesize producerArray;
@synthesize categoryArray;
@synthesize producerElements;
@synthesize categoryElements;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    NSManagedObjectContext *context = [self managedObjectContext];
//    Products *product = [NSEntityDescription
//                                      insertNewObjectForEntityForName:@"Products"
//                                      inManagedObjectContext:context];
//    product.name = @"Kosher App";
//    product.kosher = 0;
//    NSError *error;
//    if(![context save:&error]) {
//        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//    }
    
    //Test listing all FailedBankInfos from the store
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription
//                                   entityForName:@"Products" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    for (NSManagedObject *info in fetchedObjects) {
//        NSLog(@"Name: %@", [info valueForKey:@"name"]);
//        NSLog(@"Kosher: %@", [info valueForKey:@"kosher"]);
//    }
    // Override point for customization after application launch.
//    NSLog(@"Before UINavigationController");
//    UITabBarController *tabController = (UITabBarController *) self.window.ro		
//    NSLog(@"Before ProductViewController");
//    MainViewController *controller = self.window.rootViewController;
//    controller.managedObject = self.managedObjectContext;
    
//    ProductViewController *controller = (ProductViewController *) tabController.vie
//    NSLog(@"Before Controller");
//    controller.managedObjectContext = self.managedObjectContext;
    
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:kosherListURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    return YES;
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSArray *array = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions 
                          error:&error];
    
    NSDictionary *json = [array objectAtIndex:0];
    
    //NSLog(@"after serialization...: %@", json);
    dataBase = [json objectForKey:@"products"]; //2
    NSDictionary* data = [json objectForKey:@"products"];
    NSMutableArray* category = [data valueForKeyPath:@"@distinctUnionOfObjects.category"];
    NSMutableArray* producer = [data valueForKeyPath:@"@distinctUnionOfObjects.producer"];
    NSSortDescriptor *descriptor =
    [[NSSortDescriptor alloc] initWithKey:@"name"
                              ascending:YES 
                              selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    productArray = [dataBase sortedArrayUsingDescriptors:descriptors];
    categoryArray = [category sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    producerArray = [producer sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSLog(@"Values for Key Category: %@", categoryArray);
    NSLog(@"Values for Key Producer: %@", producerArray);    
    
    //generate Dictionary for Producer and Category
    int numberOfProducts = [dataBase count];
    int numberOfProducer = [producerArray count];
    int numberOfCategory = [categoryArray count];
    NSMutableArray* newProducerElements = [[NSMutableArray alloc] initWithCapacity:numberOfProducer];
    NSMutableArray* newCategoryElements = [[NSMutableArray alloc] initWithCapacity:numberOfCategory];
    
    for (int i=0; i<numberOfCategory; i++) {
        NSMutableArray* array =[[NSMutableArray alloc]init ];
        [newCategoryElements addObject:array];
    }
    categoryElements = newCategoryElements;
    
    
    for (int i=0; i<numberOfProducer; i++) {
        NSMutableArray* array =[[NSMutableArray alloc]init ];
        [newProducerElements addObject:array];
    }
    producerElements = newProducerElements;
    
    //for each element in dataBase
    NSDictionary* product;
    for(int i=0; i<numberOfProducts; i++){
        product = [dataBase objectAtIndex:i];
    
        //Add to Producer Array
        NSString *producerProduct = [product objectForKey:@"producer"];
        for(int j=0; j < numberOfProducer; j++){
            NSString *producerName = [producerArray objectAtIndex:j];
            if([producerProduct isEqualToString:producerName]){
                NSMutableArray *array = [producerElements objectAtIndex:j];
                [array addObject:product];
            }

        }
        
        //Add to category array
        NSString *categoryProduct = [product objectForKey:@"category"];
        //        NSLog(@"Producer: %@", producer);
        for(int j=0; j < numberOfCategory; j++){
            NSString *categoryName = [categoryArray objectAtIndex:j];
            //        NSLog(@"Compare name: %@ vs %@", producerName, producerProduct);
            if([categoryProduct isEqualToString:categoryName]){
                NSMutableArray *array = [categoryElements objectAtIndex:j];
                [array addObject:product];
            }            
        }     
    }    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
