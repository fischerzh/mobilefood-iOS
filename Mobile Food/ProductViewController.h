//
//  ProductViewController.h
//  Mobile Food
//
//  Created by Lion User on 10.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *products;

@end
