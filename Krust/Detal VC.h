//
//  Detal VC.h
//  Krust
//
//  Created by Pankaj Sharma on 07/08/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"

@interface Detal_VC : UIViewController
{
    IBOutlet PlaceholderTextView *txtVW_Details;
    IBOutlet UIButton *btn_customchallenge;
    IBOutlet UIButton *btn_adminChallenge;
    BOOL isSelected;
    NSString *str_ChallengeType;
    IBOutlet UITextField *txt_challengename;
}

@property(nonatomic,strong)NSString *str_encripedString;

- (IBAction)TappedONDone:(id)sender;
- (IBAction)TappedOnselectChallenge:(id)sender;

@end
