//
//  TableViewController.h
//  Mobile Food
//
//  Created by Lion User on 07.12.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, copy) NSArray* allItems;
@property (nonatomic, copy) NSArray* searchResults;

//@property (strong) NSArray *products;
@property (strong, nonatomic) id productList;

@end
