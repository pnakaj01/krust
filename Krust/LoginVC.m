//
//  ViewController.m
//  Krust
//
//  Created by Pankaj Sharma on 24/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginVC.h"
#import "AppManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "RegisterVC.h"


@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    arr_Facebookdata=[[NSMutableArray alloc]init];
    [AppManager sharedManager].navCon = self.navigationController;

    UIColor *color = [UIColor colorWithRed:277.0/255.0 green:100.0/255.0 blue:63.0/255.0 alpha:1];
    txt_username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    txt_password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];

    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)LoginAction:(id)sender
{
   if (isStringEmpty([NSString stringWithFormat:@"%@",txt_username.text]))
    {
        txt_username.text=nil;
        alert(@"Message", @"Please Enter Your Email.");
        [txt_username becomeFirstResponder];

    }
     else if (validateEmailWithString([NSString stringWithFormat:@"%@",txt_username.text])==FALSE)
        {
            
        alert(@"Message", @"Please Enter Valid Email Address.");
        [txt_username becomeFirstResponder];
        
        }
        else if (isStringEmpty([NSString stringWithFormat:@"%@",txt_password.text]))
        {
            alert(@"Message", @"Please Enter Your Password.");
            [txt_password becomeFirstResponder];
        }
        else
        {
            BOOL checkNet = [[AppManager sharedManager] CheckReachability];
            if(!checkNet == FALSE)
            {
                [self WebserviceLoginUser];
            }
        }
}

-(void)WebserviceLoginUser
{
    // http://dev414.trigma.us/krust/Webservices/login?email=rahul@gmail.com&password=123&register_type=manual
    
    str_deviceToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"DeviceToken"];
    
    if (isStringEmpty(str_deviceToken))
    {
        str_deviceToken=@"12345";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"register_type" :@"manual",
                                         @"email" :txt_username.text,
                                         @"password" :txt_password.text,
                                         @"device_tocken" : str_deviceToken
                                         
                                         }];
    
    [[AppManager sharedManager] showHUD:@"Loading..."];

    
    // [appdelRef showProgress:@"Please wait.."];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,kLogin];
    
    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
         NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
                 NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
                 
                 if(Status ==1)
                 {
//                     alert(@"Alert", @"You are register successfully.");
                     
                     [[NSUserDefaults standardUserDefaults]setObject:[responseObject valueForKey:@"user_id"] forKey:@"USERID"];
                     
                     AppDelegate *app_in_login =(AppDelegate *)[[UIApplication sharedApplication]delegate];
                     app_in_login.window.rootViewController=tabbar_controller;
                     
                     [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"alreadylogin"];
                    
                     txt_username.text=nil;
                     txt_password.text=nil;
                 
                     return;
                     
                 }
                 
                 else if (Status==0)
                 {
                     alert(@"Alert", @"Invalid Username or Password.");
                     
                     [txt_username becomeFirstResponder];
                     
                     return;
                     
                 }
             
         }
         
         else
         {
            alert(@"Alert", @"Null Data");
             
             [[AppManager sharedManager]hideHUD];
             
         }
         
     }
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Alert", @"Something went wrong.");
         
     }];
    
    
    
}

- (IBAction)TappedONFacebook:(id)sender
{
    
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
//    {
//        NSLog(@"Facbook Data %@",result);
//        if (error) {
//            // Process error
//            
//        } else if (result.isCancelled) {
//            // Handle cancellations
//            
//        }
//        else
//        {
//            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
//             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
//            {
//                 if (error)
//                 {
//                     
//                 }
//                 else
//                 {
//                     NSString *userID = [[FBSDKAccessToken currentAccessToken] userID];
//                     [[NSUserDefaults standardUserDefaults]setObject:userID forKey:@"fbid"];
//                    [self getFBResult];
//                 }}];
//        }}];
    
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
    //     NSLog(@"----%@",result);
         
         if (error)
         {
             // Error
             
         }
         else if (result.isCancelled)
         {
             // Cancelled
         }
         else
         {
             if ([result.grantedPermissions containsObject:@"email"])
             {
                 [self getFBResult];
             }
         }
     }];

 }


-(void)getFBResult
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, first_name, last_name, picture.type(large),email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
        {
             if (!error)
             {
            //     NSLog(@"fb user info : %@",result);
                 
                 [arr_Facebookdata addObject:result];
                 
                 NSMutableDictionary *pictureURL = [NSMutableDictionary new];
                 pictureURL = [result objectForKey:@"picture"];
                 FacebookImageString = [NSString stringWithFormat:@"%@",[[pictureURL valueForKey:@"data"] valueForKey:@"url"]];
                 FacebookNameString = [NSString stringWithFormat:@"%@",[result objectForKey:@"name"]];
                 FacebookIdString = [NSString stringWithFormat:@"%@",[result objectForKey:@"id"]];
                 FacebookEmailString = [NSString stringWithFormat:@"%@",[result objectForKey:@"email"]];
                 NSArray *NameArray= [FacebookNameString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                 FacebookFirstName = [NSString stringWithFormat:@"%@",[NameArray objectAtIndex:0]];
                 FacebookLastName=[NSString stringWithFormat:@"%@",[NameArray objectAtIndex:1]];
                 
                 [self FacebookLogin_API];
                 
                 [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FacebookLogin"];
                 
             }
             else
             {
                 alert(@"Alert", @"Something went wrong.");
             }
         }];
    }

}
-(void)FacebookLogin_API
{
   // http://dev414.trigma.us/krust/Webservices/facebook_login?first_name=dhimu&last_name=dhimu&username=dhimu&email=dhimu@gmail.com&image=b.png&register_type=facebook&fb_id=123456
    
    str_deviceToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"DeviceToken"];
    
    if (isStringEmpty(FacebookEmailString))
    {
        FacebookEmailString=@"";
    }
    if (isStringEmpty(FacebookNameString))
    {
        FacebookNameString=@"";
    }
    if (isStringEmpty(FacebookLastName))
    {
        FacebookLastName=@"";
    }
    if (isStringEmpty(FacebookIdString))
    {
        FacebookIdString=@"";
    }
    if (isStringEmpty(FacebookImageString))
    {
        FacebookImageString=@"";
    }
    if (isStringEmpty(str_deviceToken))
    {
        str_deviceToken=@"12345";
    }

    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"register_type" :@"facebook",
                                         @"fb_id" :FacebookIdString,
                                         @"first_name" :FacebookNameString,
                                         @"last_name" : FacebookLastName,
                                         @"email" :FacebookEmailString,
                                         @"image" :FacebookImageString,
                                         @"username" : FacebookNameString,
                                         @"device_tocken" : str_deviceToken
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kfacebooklogin];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // Get response from server
         
    //     NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             
                 NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
                 
                 if(Status ==1)
                 {
                     
                     [[NSUserDefaults standardUserDefaults]setObject:[responseObject valueForKey:@"user_id"] forKey:@"USERID"];
                     
                     [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"facebooklogin"];

                     
                     AppDelegate *app_in_login =(AppDelegate *)[[UIApplication sharedApplication]delegate];
                     app_in_login.window.rootViewController=tabbar_controller;
                     
                     [[AppManager sharedManager]hideHUD];
                     
                     [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"alreadylogin"];
                     
                     return;
                 }
                 
                 else if (Status ==0)
                     
                 {
                     RegisterVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"register"];
                     vc1.FaceBookData=arr_Facebookdata;
                     vc1.isFromFacebookSignIN=YES;
                     [self.navigationController pushViewController:vc1 animated:YES];

                     [[AppManager sharedManager]hideHUD];
                     
                     return;
                 }
                 
         }
     }
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         // [appdelRef hideProgress];
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Alert", @"Something went wrong.");
         
     }];
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txt_username)
    {
        [txt_password  becomeFirstResponder];
    }
    else if (textField == txt_password)
    {
        [txt_password resignFirstResponder];
    }
    
    return YES;
}


#pragma mark  Touch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txt_username resignFirstResponder];
    [txt_password resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    txt_password.text=nil;
    txt_username.text=nil;

}
- (IBAction)tappedonsignup:(id)sender
{
    [[FBSDKLoginManager new] logOut];
    
    RegisterVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"register"];
    [self.navigationController pushViewController:vc1 animated:YES];
    
}

//-(void)fetchUserInfo
//{
//    if ([FBSDKAccessToken currentAccessToken])
//    {
//        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
//        
//        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
//         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//             if (!error)
//             {
//                 NSLog(@"resultis:%@",result);
//                 [self getFBResult];
//             }
//             else
//             {
//                 NSLog(@"Error %@",error);
//             }
//         }];
//        
//    }
//    
//}


@end
