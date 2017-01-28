//
//  FeedbackViewController.h
//  Krust
//
//  Created by Pankaj Sharma on 22/08/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"

@interface FeedbackViewController : UIViewController
{
    
    IBOutlet UITextField *txt_subject;
    IBOutlet PlaceholderTextView *txt_description;
    NSInteger Statusofnotification;
}

@end
