//
//  ViewController.h
//  Krust
//
//  Created by Pankaj Sharma on 24/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController
{
    IBOutlet UITextField *txt_username;
    
    IBOutlet UITextField *txt_password;
    NSString *FacebookImageString;
    NSString *str_name;
    NSString *FacebookIdString;
    NSString *FacebookEmailString;
    NSString *FacebookFirstName;
    NSString *FacebookLastName;
    NSString *FaceBookUserFullname;
    NSString* FacebookNameString;
    NSMutableArray * arr_Facebookdata;
    
    NSString * str_deviceToken;
}

@end

