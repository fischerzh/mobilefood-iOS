//
//  ScanViewController.h
//  Mobile Food
//
//  Created by Lion User on 16/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface ScanView : UIViewController
<ZBarReaderDelegate>
{
    UIImageView *resultImage;
    UITextView *resultText;
}
@property (nonatomic, retain) IBOutlet UIImageView *resultImage;
@property (nonatomic, retain) IBOutlet UITextView *resultText;
- (IBAction) scanButtonTapped;
@end
