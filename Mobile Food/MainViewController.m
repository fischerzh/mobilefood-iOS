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
#import "ScanResultViewController.h"
#import "DetailViewController.h"
#import "CommunityViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MainViewController ()

@property AppDelegate *appDelegate;

@end

@implementation MainViewController

@synthesize searchResults;
@synthesize appDelegate;
@synthesize activityIndicator;
@synthesize activityView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	// Do any additional setup after loading the view, typically from a nib.
    NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if(appDelegate.kosherListURL ==nil){
        TableViewController *community = [[self storyboard] instantiateViewControllerWithIdentifier:@"community"];
        appDelegate.window.rootViewController = community;
        [(id)community setDetailItem:[appDelegate communitiesArray]];
    }else {
        [self.navigationController.view addSubview:activityView];
        [activityView setFrame:self.navigationController.view.frame];
        [activityView setHidden:FALSE];
        [activityIndicator startAnimating];
        dispatch_async(kBgQueue, ^{
        [appDelegate loadProducts];
            [activityView setHidden:TRUE];
        });
     
    }
}

- (void)viewDidUnload
{
    [self setActivityView:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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
    }else if ([[segue identifier] isEqualToString:@"scanResult"]) {
        [[segue destinationViewController] setDetailItem:searchResults];
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
                            animated: NO];
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
    [reader dismissModalViewControllerAnimated: NO];
    
    NSArray *products = [appDelegate productArray];
    searchResults = [[NSMutableArray alloc] init];
    for (NSDictionary* dict in products) {
        NSString* object = [dict objectForKey:@"ean"];
            if ((![object isKindOfClass:[NSNull class]]) && ([object rangeOfString:symbol.data].location != NSNotFound)){
                    [searchResults addObject:dict];
                NSLog(@"fount");
            }
    }
    
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NULL message:NULL delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:nil, nil];
    UIColor *color;
    int numberOfResults = [searchResults count];
    if(numberOfResults == 0){
        [message setTitle:@"Produkt NICHT gefunden!"];
        [message setMessage:@"Leider kein Treffer"];
        color = [UIColor redColor];
    }else if (numberOfResults == 1) {
        NSString *remarq = [[NSString alloc] init];
        NSString *comment = [[searchResults objectAtIndex:0] valueForKey:@"comment"];
        if ([comment isKindOfClass:[NSNull class]]){
            comment = @" ";
        }
        NSString* prodFamComment = [[searchResults objectAtIndex:0] valueForKey:@"prodfamcomment"];
        if ([prodFamComment isKindOfClass:[NSNull class]]) {
            prodFamComment = @" ";
        }
        NSLog(@"%@", comment);
        if(comment != NULL){
            remarq = [[NSString alloc] initWithFormat:@"Bemerkungen Produkt:\n%@\nBemerkungen Produktfamilie:\n%@", comment, prodFamComment];
        }
        [message setTitle:@"Produkt gefunden"];
        [message setMessage:remarq];
        [message addButtonWithTitle:@"Details"];
        color = [UIColor greenColor];
    }else{ // numberOfResults >= 2
        [message setTitle:@"Mehrere Produkte gefunden"];
        [message setMessage:@"Klicken Sie Alle Produkte um alle Treffer anzuzeigen."];
        [message addButtonWithTitle:@"Alle Produkte"];
        color = [UIColor yellowColor];
    }
    [message setBackgroundColor: color];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) { //OK
        
    }else if (buttonIndex == 1) { //Cancel
        int numberOfResults = [searchResults count];
        
//        [self performSegueWithIdentifier:@"scanResult" sender:self];
        if(numberOfResults == 0){
            
        }else if (numberOfResults == 1) {
            DetailViewController *resultController =[[self storyboard] instantiateViewControllerWithIdentifier:@"DetailView"];
            [(id)resultController setDetailItem:[searchResults objectAtIndex:0]];
            [self.navigationController pushViewController:resultController animated:YES];
            
        }else{ // numberOfResults >= 2
            ScanResultViewController *resultController =[[self storyboard] instantiateViewControllerWithIdentifier:@"ScanResult"];
            [(id)resultController setDetailItem:searchResults];
            [self.navigationController pushViewController:resultController animated:YES];
        }
    }
}


@end
