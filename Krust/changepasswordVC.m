//
//  changepasswordVC.m
//  Krust
//
//  Created by Pankaj Sharma on 26/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "changepasswordVC.h"
#import "AppManager.h"
#include "Setting VC.h"

@interface changepasswordVC ()

@end

@implementation changepasswordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AppManager sharedManager].navCon = self.navigationController;

    
    UIColor *color = [UIColor colorWithRed:277.0/255.0 green:100.0/255.0 blue:63.0/255.0 alpha:1];
    txt_password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Current Password" attributes:@{NSForegroundColorAttributeName: color}];
    txt_confirmpassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName: color}];
    txt_finalpassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm New Password" attributes:@{NSForegroundColorAttributeName: color}];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txt_password)
    {
        [txt_confirmpassword  becomeFirstResponder];
    }
    else if (textField == txt_confirmpassword)
    {
        [txt_finalpassword becomeFirstResponder];
    }
    else if (textField == txt_finalpassword)
    {
        [txt_finalpassword resignFirstResponder];
    }
    
    return YES;
}


#pragma mark  Touch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txt_password resignFirstResponder];
    [txt_confirmpassword resignFirstResponder];
    [txt_finalpassword resignFirstResponder];

}


- (IBAction)ChangePasswordAction:(id)sender
{
    if (isStringEmpty([NSString stringWithFormat:@"%@",txt_password.text]))
    {
        txt_password.text=nil;
        alert(@"Message", @"Please Enter Your Password.");
        [txt_password becomeFirstResponder];
    }
    else if (isStringEmpty([NSString stringWithFormat:@"%@",txt_confirmpassword.text]))
    {
        alert(@"Message", @"Please Enter Your Password.");
        [txt_confirmpassword becomeFirstResponder];
    }
    else if (isStringEmpty([NSString stringWithFormat:@"%@",txt_finalpassword.text]))
    {
        alert(@"Message", @"Please Enter Your Password.");
        [txt_finalpassword becomeFirstResponder];
    }
    else if (![txt_confirmpassword.text isEqualToString:txt_finalpassword.text])
    {
        alert(@"Oops!", @"Password don't match\nPlease try again.");
        [txt_confirmpassword becomeFirstResponder];
    }
    else
    {
        BOOL checkNet = [[AppManager sharedManager] CheckReachability];
        if(!checkNet == FALSE)
        {
            
            [self WebserviceChangePassword];
            
        }
        
    }
}


-(void)WebserviceChangePassword
{
    //http://dev414.trigma.us/krust/Webservices/change_password?user_id=782&old_password=
    
    NSString *str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" :str_userID,
                                         @"old_password" :txt_password.text,
                                         @"new_password" :txt_finalpassword.text,
                                         @"con_password" :txt_confirmpassword.text

                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,KChangePassword];

    // [appdelRef showProgress:@"Please wait.."];
    
    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
      //   NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
             
             if([[responseObject valueForKey:@"message"]isEqualToString:@"Password updated"])
             {
                 
                alert(@"Alert", @"Your Password updated successfully.");
                 
                 
                 [self.navigationController popViewControllerAnimated:YES];
                 
                 txt_finalpassword.text=nil;
                 txt_password.text=nil;
                 txt_confirmpassword.text=nil;

                 
                 return;
                 
             }
             
             else
             {
                 alert(@"Alert", @"Your old password did not match.");
                 
                 [txt_password becomeFirstResponder];
                 
                 return;
                 
             }
             
             
         }
         
         else
         {
             alert(@"Alert", @"Null Data.");
             
             [[AppManager sharedManager]hideHUD];
             
         }
         
     }
     
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Alert", @"Something went wrong.");
         
     }];
    
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changepassword:(id)sender
{
    txt_finalpassword.text=nil;
    txt_password.text=nil;
    txt_confirmpassword.text=nil;

    [self.navigationController popViewControllerAnimated:YES];
}
@end
