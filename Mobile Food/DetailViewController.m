//
//  DetailViewController.m
//  Mobile Food
//
//  Created by Lion User on 07.12.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "FavoriteButton.h"


#define jsonKey [NSArray arrayWithObjects:@"name",@"ean",@"producer", @"category", @"packaging", @"kosher", @"comment", @"controller", @"contents",nil]
#define jsonValues [NSArray arrayWithObjects:@"Name", @"EAN", @"Hersteller", @"Kategorie", @"Verpackung", @"Koscher", @"Bemerkungen", @"Kontrolleur", @"Inhaltsstoffe", nil]
#define sideDistance 10
#define topDistance 5
#define bottomDistance 10

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
    float tempPosition = topDistance;
    UIScrollView* view = [[UIScrollView alloc]initWithFrame:self.view.frame];
    NSString* key;
    NSString* title;
    NSString* value;
    UIView* titleView;
    UIView* content;
    UIView* line;
    CGRect frame;
    view.backgroundColor = [UIColor whiteColor];
//    ((UIScrollView*)self.view) scr
    
    //Product Title with Name
    title = [self.detailItem objectForKey:[jsonKey objectAtIndex:0]];
    titleView = [self getProductTitleLabel:tempPosition :title];
    [view insertSubview:titleView atIndex:0];
    tempPosition += titleView.frame.size.height;
    
    line = [self addBlueLine:tempPosition];
    frame = line.frame;
    frame.size.height = 3;
    frame.size.width = view.frame.size.width - 2*sideDistance -40;
    line.frame = frame;
    [view insertSubview:line atIndex:0];
    tempPosition += frame.size.height;
    
    //Favorite Button
    CGRect favFrame;
    favFrame.size.height = 30	;
    favFrame.size.width = favFrame.size.height;
    favFrame.origin.y = topDistance;
    favFrame.origin.x = self.view.frame.size.width - sideDistance - favFrame.size.width;
    FavoriteButton* favButton = [[FavoriteButton alloc]initWithProduct:favFrame:_detailItem];
    [view addSubview:favButton];

    
    for (int i=1; i < [(NSArray*) jsonKey count]; i++) {
        key = [jsonKey objectAtIndex:i];
        title = [jsonValues objectAtIndex:i];
        value = [self.detailItem objectForKey:key];
        if (![value isKindOfClass:[NSNull class]] && [key isEqualToString:@"contents"]) {
            NSMutableString* contentValues = [[NSMutableString alloc]init];
            int size = [((NSArray*) value) count];
            if (size > 0) {
                [contentValues appendString:[((NSArray*) value) objectAtIndex:0]];
                for (int j=1; j < size; j++){
                    [contentValues appendString:@", "];
                    [contentValues appendString:[((NSArray*) value) objectAtIndex:j]];
                }
            }
            value = contentValues;
        } else if ([key isEqualToString:@"comment"]) {
            NSString* commentProduct = [self.detailItem objectForKey:@"comment"];
            if([commentProduct isKindOfClass:[NSNull class]]){
                commentProduct = @" ";
            }
            NSString* commentFamily = [self.detailItem objectForKey:@"prodfamcomment"];
            if([commentFamily isKindOfClass:[NSNull class]]){
                commentFamily = @" ";
            }
            value = [[NSString alloc] initWithFormat:@"Produkt: \n%@\nProduktfamilie:\n%@", commentProduct, commentFamily];
        } else if([value isKindOfClass:[NSNull class]] || NULL){
            value = @" ";
        }
            
            titleView = [self getTitleLabel:tempPosition :title];
            tempPosition += titleView.frame.size.height;
            line = [self addBlueLine:tempPosition];
            tempPosition += line.frame.size.height;
        if([key isEqualToString:@"kosher"]){
            content = [self getKosherView:tempPosition :title];
        }else {
            content = [self getContentLabel:tempPosition :value];
        }
        tempPosition += content.frame.size.height;
        [view insertSubview:titleView atIndex:0];
        [view insertSubview:line atIndex:0];
        [view insertSubview:content atIndex:0];
        tempPosition += 2;
        
        CGSize content = view.contentSize;
        content.height = tempPosition;
        view.contentSize = content;
        self.view = view;
    }

    
}
}
- (UILabel*)addBlueLine:(CGFloat)y{
    UILabel* line = [[UILabel alloc]init];
    line.hidden = FALSE;
    CGRect frame;
    frame = line.frame;
    frame.origin.x = sideDistance;
    frame.origin.y = y;
    frame.size.height = 1;
    frame.size.width = self.view.frame.size.width - 2*sideDistance;
    line.frame = frame;
    line.backgroundColor = [UIColor blueColor];
    line.autoresizingMask =UIViewAutoresizingFlexibleWidth;
    return line;
}

- (UILabel*)getProductTitleLabel:(CGFloat)y:(NSString*)text{
    UILabel* label = [self getTitleLabel:y :text];
    label.font =[UIFont boldSystemFontOfSize:17];
    CGRect frame = label.frame;
    frame.size.width = self.view.frame.size.width - 2*sideDistance -40;
    label.frame = frame; 
    CGSize maxLabelSize = CGSizeMake(self.view.frame.size.width - 2*sideDistance -40, 9999);
    [self resizeLabel:label :maxLabelSize];
    return label;
}

- (UILabel*)getTitleLabel:(CGFloat)y:(NSString*)text{
    CGSize maxLabelSize = CGSizeMake(self.view.frame.size.width - 2*sideDistance, 9999);
        
    UILabel* label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont boldSystemFontOfSize:15];
    label.numberOfLines = 0;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CGSize expectedSize = [text sizeWithFont:label.font constrainedToSize:maxLabelSize];
    CGRect frame = label.frame;
    frame.origin.x = sideDistance;
    frame.size.width = self.view.frame.size.width - 2*sideDistance;
    frame.size.height = expectedSize.height;
    frame.origin.y = y;
    label.frame = frame;
    return label;
}

- (UILabel*)getContentLabel:(CGFloat)y:(NSString*)text{
    CGSize maxLabelSize = CGSizeMake(self.view.frame.size.width - 2*sideDistance, 9999);
    UILabel* label = [self getTitleLabel:y :text];
    label.font = [UIFont systemFontOfSize:15];
    return [self resizeLabel:label :maxLabelSize];
    
}

- (UIView*)getKosherView:(CGFloat)y:(NSString*)text{
    float tempPosition = 0;
    UIView* view = [[UIView alloc]init];
    UILabel* kosher = [self getKosherLabel:tempPosition :text];
    UIImageView* kosherImage = [self getKosherImage:kosher.frame:TRUE];
    tempPosition += kosher.frame.size.height;
    UILabel* parve = [self getKosherLabel:tempPosition :@"Parve"];
    UIImageView* parveImage = [self getKosherImage:parve.frame :[[self.detailItem valueForKey:@"parve"] boolValue]];
    tempPosition += parve.frame.size.height;
    UILabel* chalavakum = [self getKosherLabel:tempPosition :@"Chalav akum"];
    UIImageView* chalavakumImage = [self getKosherImage:chalavakum.frame :[[self.detailItem valueForKey:@"chalavakum"] boolValue]];
    
    [view addSubview:kosher];
    [view insertSubview:parve atIndex:0];
    [view insertSubview:chalavakum atIndex:0];
    [view addSubview:kosherImage];
    [view addSubview:parveImage];
    [view addSubview:chalavakumImage];
    CGRect frame = view.frame;
    frame.origin.x = sideDistance;
    frame.origin.y = y;
    frame.size.height = kosher.frame.size.height + parve.frame.size.height + chalavakum.frame.size.height;
    view.frame = frame;
    
    return view;    
}

- (UILabel*)getKosherLabel:(CGFloat)y:(NSString*)text{
    UILabel* label = [self getContentLabel:y :text];
    CGRect frame = label.frame;
    frame.size.width = (self.view.frame.size.width - 2*sideDistance)/2;
    frame.origin.x = 0;
    label.frame = frame;
    return label;
}

- (UIImageView*)getKosherImage:(CGRect)frame:(BOOL)value{
    UIImageView* image = [[UIImageView alloc]initWithFrame:frame];
    CGRect imageFrame = image.frame;
    imageFrame.origin.y = frame.origin.y+1;
    imageFrame.size.height = frame.size.height - 2;
    imageFrame.origin.x = frame.size.width;
    imageFrame.size.width = frame.size.height;
    image.frame = imageFrame;
    if (value) {
        [image setImage:[UIImage imageNamed:@"OK.png"]];
    }else {
    [image setImage:[UIImage imageNamed:@"NOT.png"]];
    }
    return image;
}

- (UILabel*)resizeLabel:(UILabel*)label:(CGSize)maxSize{
    CGSize expectedSize = [label.text sizeWithFont:label.font constrainedToSize:maxSize];
    CGRect frame = label.frame;
    frame.size.height = expectedSize.height;
    label.frame = frame;
    return label;
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
    [self configureView];
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
