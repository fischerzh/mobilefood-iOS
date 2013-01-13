//
//  DetailViewController.m
//  Mobile Food
//
//  Created by Lion User on 07.12.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
-(void)configureView;
	
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
if (_detailItem != newDetailItem) {
    _detailItem = newDetailItem;
    
    // Update the view.
    [self configureView];
}
}

- (void)configureView
{
// Update the user interface for the detail item.

if (self.detailItem) {
    name.text = [[self.detailItem valueForKey:@"name"] description];
    producer.text = [[self.detailItem valueForKey:@"producer"] description];
    ean.text = [NSString stringWithFormat:@"EAN: %@",[[self.detailItem valueForKey:@"ean"]description]];
    category.text = [[self.detailItem valueForKey:@"category"] description];
    ingredients.text = [[self.detailItem valueForKey:@"contents"] description];
}
}

- (void)viewDidLoad
{
[super viewDidLoad];
// Do any additional setup after loading the view, typically from a nib.
    
[self configureView];
}

- (void)viewDidUnload
{
[super viewDidUnload];
// Release any retained subviews of the main view.
self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
