//
//  changepasswordVC.h
//  Krust
//
//  Created by Pankaj Sharma on 26/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface changepasswordVC : UIViewController
{
    IBOutlet UITextField *txt_password;
    
    IBOutlet UITextField *txt_confirmpassword;
    IBOutlet UITextField *txt_finalpassword;
}
- (IBAction)changepassword:(id)sender;

@end
