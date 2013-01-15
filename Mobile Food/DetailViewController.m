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
    id eanId;
    if ((eanId = [self.detailItem valueForKey:@"ean"]))
    ean.text = [NSString stringWithFormat:@"EAN: %@",[eanId description]];
    category.text = [[self.detailItem valueForKey:@"category"] description];
    contents.text = [[self.detailItem valueForKey:@"contents"] description];
    packaging.text = [[self.detailItem valueForKey:@"packaging"] description];
    controller.text = [[self.detailItem valueForKey:@"controller"] description];
    NSString* commentId = [[self.detailItem valueForKey:@"comment"] description];
    if (![commentId isEqualToString:@"<null>"])
    comment.text = [commentId description];
    verteiler.text = [[self.detailItem valueForKey:@"verteiler"] description];
    parve.image = [UIImage imageNamed:@"OK.png"];
    chalavakum.image = [UIImage imageNamed:@"NOT.png"];
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
