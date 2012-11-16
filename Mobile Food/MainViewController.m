//
//  ViewController.m
//  Mobile Food
//
//  Created by Lion User on 15.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "ProducerViewController.h"
#import "ProductViewController.h"
#import "CategoriesViewController.h"
#import "FavoritesViewController.h"

@interface MainViewController ()
- (IBAction)switchToScanner:(id)sender;
- (IBAction)switchToProducts:(id)sender;
- (IBAction)switchToProducer:(id)sender;
- (IBAction)switchToCategories:(id)sender;
- (IBAction)switchToFavorites:(id)sender;


@end

@implementation MainViewController

@synthesize managedObject;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Home";
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

- (IBAction)switchToScanner:(id)sender {
    UINavigationController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Scanner"];
    [self presentModalViewController:controller animated:NO];
}

- (IBAction)switchToProducts:(id)sender {
    ProductViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Product"];
    [self presentViewController:controller animated:NO completion:NULL];
    controller.managedObjectContext = self.managedObject;
    
}

- (IBAction)switchToProducer:(id)sender {
    UINavigationController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Producer"];
    [self presentViewController:controller animated:NO completion:NULL];
}

- (IBAction)switchToCategories:(id)sender {
    UINavigationController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Categories"];
    [self presentModalViewController:controller animated:NO];
}

- (IBAction)switchToFavorites:(id)sender {
    UINavigationController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Favorites"];
    [self presentModalViewController:controller animated:NO];
}
@end
