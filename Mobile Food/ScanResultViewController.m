//
//  ScanResultViewController.m
//  Mobile Food
//
//  Created by Lion User on 28.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ScanResultViewController.h"

@interface ScanResultViewController ()

@end

@implementation ScanResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Wo sind Sie?";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *product;
    if([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        product = [self.searchResults objectAtIndex:indexPath.row];
    }else{
        product = [self.productList objectAtIndex:indexPath.row];
    NSLog( @"%@ Product", product);
    }
    NSString* branch = [product objectForKey:@"branch"];
    NSString* distributor = [product objectForKey:@"verteiler"];
    if (branch != nil) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", branch, distributor];
    } else {
        cell.textLabel.text = distributor;
    }
    
    return cell;
}

#pragma mark - Search View

- (void)filteredContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"(branch contains[cd] %@) OR (verteiler contains[cd] %@)",searchText, searchText];
    self.searchResults = [self.productList filteredArrayUsingPredicate:resultPredicate];
    NSLog(@"Search Results: %@ EndSearchTable", self.productList);
}

@end
