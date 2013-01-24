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
    [appDelegate updateFavoriteArray];
    if ([[segue identifier] isEqualToString:@"showProducts"]) {
        NSDictionary* object = [appDelegate productArray];
        [[segue destinationViewController] setDetailItem:object];
    }else if ([[segue identifier] isEqualToString:@"showProducer"]) {
        NSDictionary* object = [appDelegate producerArray];
        [[segue destinationViewController] setDetailItem:object];
    }else if ([[segue identifier] isEqualToString:@"showCategory"]) {
        NSDictionary* object = [appDelegate categoryArray];
        [[segue destinationViewController] setDetailItem:object];
    }else if ([[segue identifier] isEqualToString:@"showFavorites"]) {
        NSDictionary* object = [appDelegate favoriteArray];
        [[segue destinationViewController] setDetailItem:object];
    }
    
}

- (IBAction) scanButtonTapped
{
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Product found" message:symbol.data delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"abbrechen", nil];
    
    [message setBackgroundColor: [UIColor redColor]];
    [message show];
}


@end
