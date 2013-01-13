//
//  DetailViewController.h
//  Mobile Food
//
//  Created by Lion User on 07.12.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
    IBOutlet UILabel* name;
    IBOutlet UILabel* producer;
    IBOutlet UILabel* category;
    IBOutlet UILabel* ean;
    IBOutlet UITextView* ingredients;
}

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
