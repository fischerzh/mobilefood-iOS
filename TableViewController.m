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
#import "FavoriteButton.h"

@interface TableViewController ()

@property AppDelegate* appDelegate; 

@end

@implementation TableViewController
@synthesize searchDisplayController;
@synthesize searchBar;
@synthesize allItems;
@synthesize searchResults = _searchResults;

@synthesize productList = _productList;
@synthesize appDelegate;




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
    appDelegate  = [[UIApplication sharedApplication] delegate];
    [appDelegate updateFavoriteArray];
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        return [_searchResults count];
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
        product = [_searchResults objectAtIndex:indexPath.row];
    }else{
        product = [_productList objectAtIndex:indexPath.row];
    }    

    cell.textLabel.text = [product objectForKey:@"name"];
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@ \n%@",[product objectForKey:@"packaging"], [product objectForKey:@"producer"]];
    
    CGRect favFrame;
    favFrame.size.height = 30	;
    favFrame.size.width = favFrame.size.height;
    UIButton *favButton = [[FavoriteButton alloc] initWithProduct:favFrame :product];
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
            object = [_searchResults objectAtIndex:indexPath.row];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            object = [_productList objectAtIndex:indexPath.row];
        }
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
