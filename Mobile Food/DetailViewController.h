//
//  DetailViewController.h
//  Mobile Food
//
//  Created by Lion User on 07.12.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
    IBOutlet UITextView* name;
    IBOutlet UILabel* nameLine;
    
    IBOutlet UILabel* eanTitle;
    IBOutlet UILabel* ean;
    IBOutlet UILabel* eanLine;
    
    IBOutlet UILabel* producerTitle;
    IBOutlet UITextView* producer;
    IBOutlet UILabel* producerLine;
    
    IBOutlet UILabel* distributorTitle;
    IBOutlet UILabel* distributor;
    IBOutlet UILabel* distributorLine;
    
    IBOutlet UILabel* categoryTitle;
    IBOutlet UITextView* category;
    IBOutlet UILabel* categoryLine;
    
    IBOutlet UILabel* packagingTitle;
    IBOutlet UILabel* packaging;
    IBOutlet UILabel* packagingLine;
    
    IBOutlet UILabel* kosherTitle;
    IBOutlet UILabel* kosherLine;
    IBOutlet UILabel* kosherLabel;
    IBOutlet UILabel* kosherImage;
    IBOutlet UIImageView* parveImage;
    IBOutlet UIImageView* chalavakumImage;
    
    IBOutlet UILabel* commentTitle;
    IBOutlet UILabel* commentLine;
    IBOutlet UILabel* commentProduct;
    IBOutlet UILabel* commentFamily;
    
    IBOutlet UILabel* controllerTitle;
    IBOutlet UILabel* controllerLine;
    IBOutlet UILabel* controller;
    
    IBOutlet UILabel* contentsTitle;
    IBOutlet UILabel* contentsLine;
    IBOutlet UITextView* contents;
    
}

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
