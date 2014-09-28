//
//  FavoriteButton.m
//  Mobile Food
//
//  Created by Lion User on 03.03.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FavoriteButton.h"
#import "AppDelegate.h"

@interface FavoriteButton()

@property AppDelegate* appDelegate;

@end

@implementation FavoriteButton

@synthesize appDelegate;
@synthesize product = _product;


- (id)initWithProduct:(CGRect)frame:(NSDictionary*)product
{
    self = [super initWithFrame:frame];
    appDelegate = [[UIApplication sharedApplication] delegate];
    _product = product;
    if([[self.appDelegate favoriteArray] containsObject:self.product]) {
        [self setSelected:TRUE];
    }
    if (self) {
        [self setImage:[UIImage imageNamed:@"Favorite_on.png"] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"Favorite_on.png"] forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:@"Favorite_on.png"] forState:UIControlStateReserved];
        [self setImage:[UIImage imageNamed:@"Favorite_on.png"] forState:UIControlStateApplication];
        [self setImage:[UIImage imageNamed:@"Favorite_on.png"] forState:UIControlStateDisabled];
        [self setImage:[UIImage imageNamed:@"Favorite_off.png"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(favoriteButtonAction:) forControlEvents:UIControlEventTouchDown];
    }
    [self setHidden:false];
    [self setEnabled:TRUE];
    return self;
}

- (IBAction)favoriteButtonAction:(id)sender{
    UIButton* button = (UIButton*)sender;
    NSMutableArray* favUpdate = [self.appDelegate favoriteUpdate];
    NSMutableArray* favIds = [self.appDelegate favoriteIds];
    int idValue = [[self.product valueForKey:@"id"] intValue];
    if(button.selected) {//remove from favorites
        [favUpdate removeObject:self.product];
        for (NSNumber *num in favIds) {
            if([num intValue] == idValue){
                [favIds removeObject:num];
                break;
            }
        }
    }else { //add to favorites
        [favUpdate addObject:self.product];
        NSNumber *num = [NSNumber numberWithInt:idValue];
        NSLog(@"%@", num);
        [favIds addObject:num];
        NSLog(@"%@",[self.product valueForKey:@"id"]);
        NSLog(@"Safed Ids: %@", favIds);
        
    }
    button.selected = !button.selected;
    [appDelegate updateFavoriteArray];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end





