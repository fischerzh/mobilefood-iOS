//
//  FavoriteButton.h
//  Mobile Food
//
//  Created by Lion User on 03.03.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteButton : UIButton

- (id)initWithProduct:(CGRect)frame:(NSDictionary*)product;

@property (nonatomic) NSDictionary* product;

@end
