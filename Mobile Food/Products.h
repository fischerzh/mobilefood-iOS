//
//  Products.h
//  Mobile Food
//
//  Created by Lion User on 13.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Products : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * contents;
@property (nonatomic, retain) NSNumber * ean;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * producer;
@property (nonatomic, retain) NSString * packaging;
@property (nonatomic, retain) NSNumber * controller;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * chavalakum;
@property (nonatomic, retain) NSNumber * parve;

@end
