//
//  ForgotVC.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "ForgotVC.h"
#import "LoginVC.h"
#include "AppManager.h"

@interface ForgotVC ()

@end

@implementation ForgotVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppManager sharedManager].navCon = self.navigationController;

    UIColor *color = [UIColor colorWithRed:277.0/255.0 green:100.0/255.0 blue:63.0/255.0 alpha:1];
    txt_email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
   

    // Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txt_email)
    {
        [txt_email  resignFirstResponder];
    }
    return YES;
}


#pragma mark  Touch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txt_email resignFirstResponder];
}


- (IBAction)ForgotAction:(id)sender
{
    
    if (isStringEmpty([NSString stringWithFormat:@"%@",txt_email.text]))
    {
        
        alert(@"Message", @"Please enter email.");
        [txt_email becomeFirstResponder];
    }
    
    else if (validateEmailWithString([NSString stringWithFormat:@"%@",txt_email.text])==FALSE)
    {
        
        alert(@"Message", @"Please Enter Valid Email Address.");
        [txt_email becomeFirstResponder];
    }
    else
    {
        BOOL checkNet = [[AppManager sharedManager] CheckReachability];
        if(!checkNet == FALSE)
        {
            
            [self WebserviceForgotUser];
            
        }
        
    }
}


-(void)WebserviceForgotUser
{
   // http://dev414.trigma.us/krust/Webservices/forgot?email=rahul.kumar@trigma.in
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"register_type" :@"manual",
                                         @"email" :txt_email.text
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    // [appdelRef showProgress:@"Please wait.."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kforgot];

    
    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
     //    NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
             if ([[responseObject valueForKey:@"message"] isEqualToString:@"Check Your Email To Reset your password"])
             {
                 alert(@"Alert", @"Reset password link sent to email id.");
                 
                 LoginVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
                 [self.navigationController pushViewController:vc1 animated:YES];
                 
                 txt_email.text=nil;
                 
                 return;
  
             }
             
             else
             {
                 alert(@"Alert", @"No user found.");
                 
                 [txt_email becomeFirstResponder];
                 
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender
{
    txt_email.text=nil;

    [self.navigationController popViewControllerAnimated:YES];
}
@end
