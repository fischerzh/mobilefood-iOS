//
//  ProductViewController.m
//  Mobile Food
//
//  Created by Lion User on 10.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kosherListURL [NSURL URLWithString:@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"] //"http://www.uitiwg.ch/products_contents.json"] //


#import "Products.h"
#import "ProductViewController.h"

@interface ProductViewController ()

@end

@implementation ProductViewController

@synthesize products;

@synthesize managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:kosherListURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    NSLog(@"dispatched...");*/
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSString* string = [responseData description];
    NSLog(@"String %@", string);
    NSLog(@"parse json");
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions 
                          error:&error];
    //NSLog(@"after serialization...: %@", json);
    NSArray* latestLoans = [json objectForKey:@"loans"]; //2
    
    NSLog(@"products... %@", latestLoans);
    //NSLog(@"products: %@", latestLoans); //3
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


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

@end
