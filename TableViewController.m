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

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kosherListURL [NSURL URLWithString:@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"] //"http://www.uitiwg.ch/products_contents.json"] //

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
    
    
    //dispatch_async(kBgQueue, ^{
//        NSData* data = [NSData dataWithContentsOfURL:kosherListURL];
//        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
//    //});
//    NSLog(@"dispatched...");

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//- (void)fetchedData:(NSData *)responseData {
//    //parse out the json data
//    NSLog(@"parse json");
//    NSError* error;
//    NSDictionary* json = [NSJSONSerialization 
//                          JSONObjectWithData:responseData //1
//                          
//                          options:kNilOptions 
//                          error:&error];
//    
//    //NSLog(@"after serialization...: %@", json);
//    products = [json objectForKey:@"loans"]; //2
//    //NSLog(@"products: %@", latestLoans); //3
//}


- (void)viewDidUnload
{
    [self setSearchDisplayController:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = [_productList objectAtIndex:indexPath.row];
        NSLog(@"Preparefor Seque: %@", object);
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Search View

- (void)filteredContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",searchText];
    self.searchResults = [_productList filteredArrayUsingPredicate:resultPredicate];
    NSLog(@"Search Results: %@ EndSearch", _productList);
}

#pragma mark - UISearchDisplayController delegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filteredContentForSearchText:searchString
                                 scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                        objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
     
}

@end
