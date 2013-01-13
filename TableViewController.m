//
//  TableViewController.m
//  Mobile Food
//
//  Created by Lion User on 07.12.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"

@interface TableViewController ()

@property AppDelegate *appDelegate;

@end

@implementation TableViewController
@synthesize searchDisplayController;
@synthesize searchBar;
@synthesize allItems;
@synthesize searchResults;

@synthesize appDelegate;

@synthesize productList = _productList;

- (void) setDetailItem:(id)productList{
    _productList = productList;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setSearchDisplayController:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        return [searchResults count];
    }
    return [_productList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *product;
    if([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        product = [searchResults objectAtIndex:indexPath.row];
    }else{
        product = [_productList objectAtIndex:indexPath.row];
    }    
        NSLog(@"Product: %@", _productList);

    cell.textLabel.text = [product objectForKey:@"name"];
    cell.detailTextLabel.text = [product objectForKey:@"producer"];
    
    UIButton* favButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    cell.accessoryView = favButton;
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = nil;
        NSDictionary *object = nil;
        if([self.searchDisplayController isActive]){
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            object = [searchResults objectAtIndex:indexPath.row];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            object = [_productList objectAtIndex:indexPath.row];
        }
        NSLog(@"Preparefor Seque: %@", object);
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    }
}

#pragma mark - Search View

- (void)filteredContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"name contains[cd] %@",searchText];
    self.searchResults = [_productList filteredArrayUsingPredicate:resultPredicate];
    NSLog(@"Search Results: %@ EndSearchTable", _productList);
}

#pragma mark - UISearchDisplayController delegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filteredContentForSearchText:searchString
                                 scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                        objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

@end
