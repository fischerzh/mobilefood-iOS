//
//  Products.h
//  Mobile Food
//
//  Created by Lion User on 02.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Products : NSManagedObject

@property (nonatomic, retain) NSString * distributor;
@property (nonatomic, retain) NSNumber * ean;
@property (nonatomic, retain) NSString * family;
@property (nonatomic, retain) NSString * ingredients;
@property (nonatomic, retain) NSNumber * kosher;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * package;
@property (nonatomic, retain) NSString * remarks;

@end
