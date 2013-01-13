//
//  ViewController.m
//  Mobile Food
//
//  Created by Lion User on 15.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "CategoryTableViewController.h"
#import "TableViewController.h"
#import "CategoryViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([[segue identifier] isEqualToString:@"showProducts"]) {
        NSDictionary* object = [appDelegate dataBase];
        [[segue destinationViewController] setDetailItem:object];
    }else if ([[segue identifier] isEqualToString:@"showProducer"]) {
        NSDictionary* object = [appDelegate producerArray];
        NSDictionary* objectElements = [appDelegate producerElements];
        [[segue destinationViewController] setDetailItem:objectElements];
        [[segue destinationViewController] setDetailItemDescriptions:object];
    }else if ([[segue identifier] isEqualToString:@"showCategory"]) {
        NSDictionary* object = [appDelegate categoryArray];
        NSDictionary* objectElements = [appDelegate categoryElements];
        [[segue destinationViewController] setDetailItem:objectElements];
        [[segue destinationViewController] setDetailItemDescriptions:object];
    }
    
}


@end
