//
//  CommunityViewController.m
//  Mobile Food
//
//  Created by Lion User on 29.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CommunityViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@interface CommunityViewController ()

@end

@implementation CommunityViewController

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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *product = [super.productList objectAtIndex:indexPath.row];   
    
    cell.textLabel.text = [product objectForKey:@"name"];  
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Wählen Sie Ihre Gemeinde:";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected");
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MainViewController *view = [[self storyboard] instantiateViewControllerWithIdentifier:@"root"];
    
    NSDictionary *product = [super.productList objectAtIndex:indexPath.row];
    NSString *url = [product objectForKey:@"url"];
    [appDelegate saveKosherListURL:[NSURL URLWithString:url]];
    NSLog(@"%@",appDelegate.kosherListURL);
    appDelegate.window.rootViewController = view;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"setComunity"]){
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        NSDictionary *object = [super.productList objectAtIndex:indexPath.row];
        
    }
}

@end
