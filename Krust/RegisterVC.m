//
//  RegisterVC.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "RegisterVC.h"
#import "AppManager.h"
#import "HeaderFile.h"
#import "AppDelegate.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LoginVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Haneke.h"

@interface RegisterVC ()

@end

@implementation RegisterVC
@synthesize FaceBookData,isFromFacebookSignIN;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AppManager sharedManager].navCon = self.navigationController;
    
    imageVW_plusIcon.hidden=NO;
    
    arr_Facebookdata=[[NSMutableArray alloc]init];
    
    UIColor *color = [UIColor colorWithRed:277.0/255.0 green:100.0/255.0 blue:63.0/255.0 alpha:1];
   
    txt_firstname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName: color}];
    txt_lastname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: color}];
    txt_username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    txt_email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: color}];
    txt_password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    txt_confirmPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: color}];
//    NSLog(@"%@",FaceBookData);
    
    [self FacebookDatafromlogin];
    
    HNKCacheFormat *format = [HNKCache sharedCache].formats[@"thumbnail"];
    if (!format)
    {
        format = [[HNKCacheFormat alloc] initWithName:@"thumbnail"];
        format.size = CGSizeMake(320, 240);
        format.scaleMode = HNKScaleModeAspectFill;
        format.compressionQuality = 0.5;
        format.diskCapacity = 1 * 1024 * 1024;
        format.preloadPolicy = HNKPreloadPolicyLastSession;
    }

    // Do any additional setup after loading the view.
}

-(void)FacebookDatafromlogin
{
    if (isFromFacebookSignIN==YES )
    {
        imageVW_plusIcon.hidden=YES;
        
        txt_firstname.text=[[FaceBookData valueForKey:@"first_name"]objectAtIndex:0];;
        txt_lastname.text=[[FaceBookData valueForKey:@"last_name"]objectAtIndex:0];
        
        NSString * str_email=[NSString stringWithFormat:@"%@",[[FaceBookData valueForKey:@"email"]objectAtIndex:0]];
        
        if (isStringEmpty(str_email) || [str_email isEqualToString:@"<null>"] || (str_email==[NSNull class])||([str_email isEqual:@"null"])||([str_email isEqual:@"(null)"])||([str_email isEqual:@"<null>"])||([str_email isEqual:@"nil"])||([str_email isEqual:@""])||([str_email isEqual:@"<nil>"]))
        {
            
        }
        else
        {
            txt_email.text=[[FaceBookData valueForKey:@"email"]objectAtIndex:0];
        }
        
        Fcaebook_id=[[FaceBookData valueForKey:@"id"]objectAtIndex:0];
        
        
        str_facebookimage=[[[[FaceBookData valueForKey:@"picture"]valueForKey:@"data"]objectAtIndex:0]valueForKey:@"url"];
        dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:str_facebookimage]];
        //      dataImage = UIImageJPEGRepresentation(image, 1.0);
        encryptedString = [dataImage base64EncodedStringWithOptions:0];
        
        NSString *imagestr = [NSString stringWithFormat:@"%@",str_facebookimage];
        [imageViewProfile hnk_setImageFromURL: [NSURL URLWithString:imagestr]];
        
        imageViewProfile.layer.cornerRadius=imageViewProfile.frame.size.height/2;
        imageViewProfile.clipsToBounds = YES;
        
    }
}

-(void)RegisterFacebookLogin
{
    imageVW_plusIcon.hidden=YES;
    
    txt_firstname.text=[[arr_Facebookdata valueForKey:@"first_name"]objectAtIndex:0];;
    txt_lastname.text=[[arr_Facebookdata valueForKey:@"last_name"]objectAtIndex:0];
    NSString * str_email=[NSString stringWithFormat:@"%@",[[arr_Facebookdata valueForKey:@"email"]objectAtIndex:0]];
    
    if (isStringEmpty(str_email) || [str_email isEqualToString:@"<null>"] || (str_email==[NSNull class])||([str_email isEqual:@"null"])||([str_email isEqual:@"(null)"])||([str_email isEqual:@"<null>"])||([str_email isEqual:@"nil"])||([str_email isEqual:@""])||([str_email isEqual:@"<nil>"]))
    {

    }
    else
    {
    txt_email.text=[[arr_Facebookdata valueForKey:@"email"]objectAtIndex:0];
    }
    Fcaebook_id=[[arr_Facebookdata valueForKey:@"id"]objectAtIndex:0];
    
    
    str_facebookimage=[[[[arr_Facebookdata valueForKey:@"picture"]valueForKey:@"data"]objectAtIndex:0]valueForKey:@"url"];
    dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:str_facebookimage]];
    //      dataImage = UIImageJPEGRepresentation(image, 1.0);
    encryptedString = [dataImage base64EncodedStringWithOptions:0];
    
    NSString *imagestr = [NSString stringWithFormat:@"%@",str_facebookimage];
    [imageViewProfile hnk_setImageFromURL: [NSURL URLWithString:imagestr]];

    
    imageViewProfile.layer.cornerRadius=imageViewProfile.frame.size.height/2;
    imageViewProfile.clipsToBounds = YES;

}

-(void)viewWillDisappear:(BOOL)animated
{
    imageVW_plusIcon.hidden=NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txt_firstname)
    {
        [txt_lastname  becomeFirstResponder];
    }
    else if (textField == txt_lastname)
    {
        [txt_username becomeFirstResponder];
    }
    else if (textField == txt_username)
    {
        [txt_email becomeFirstResponder];
    }
    else if (textField == txt_email)
    {
        [txt_password becomeFirstResponder];
    }
    else if (textField == txt_password)
    {
        [txt_confirmPassword becomeFirstResponder];
    }
    else if (textField == txt_confirmPassword)
    {
        [txt_confirmPassword resignFirstResponder];
    }
    
    return YES;
}

#pragma mark  Touch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txt_email resignFirstResponder];
    [txt_firstname resignFirstResponder];
    [txt_lastname resignFirstResponder];
    [txt_password resignFirstResponder];
    [txt_confirmPassword resignFirstResponder];
    [txt_username resignFirstResponder];
}

#pragma mark --Action Method--
- (IBAction)TappedOnCamera:(id)sender
{
    UIActionSheet *obj_ActionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Camera", nil),NSLocalizedString(@"Photo album", nil), nil];
    [obj_ActionSheet showInView:self.view];
}

#pragma mark  ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *obj_ImagePicker=[[UIImagePickerController alloc]init];
                obj_ImagePicker.delegate=self;
                obj_ImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                obj_ImagePicker.editing=NO;
                obj_ImagePicker.videoQuality=UIImagePickerControllerQualityTypeHigh;
                [self.navigationController presentViewController:obj_ImagePicker animated:YES completion:nil];
            }
            else
            {
                //                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK"                                                          otherButtonTitles: nil];
                alert(@"Message", @"Device has no camera");
                
                //                [myAlertView show];
            }
        }
            
            break;
        case 1:
        {
            UIImagePickerController *obj_ImagePicker=[[UIImagePickerController alloc]init];
            obj_ImagePicker.delegate=self;
            obj_ImagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            obj_ImagePicker.editing=YES;
            [self.navigationController presentViewController:obj_ImagePicker animated:YES completion:nil];
        }
            
            break;
        default:
            break;
    }
}


#pragma mark  UIImagePickerController Delegates

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info

{
    dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],.1);
    //   _profilephoto.image = [[UIImage alloc] initWithData:dataImage];
    
    encryptedString = [dataImage base64EncodedStringWithOptions:0];
    
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:encryptedString options:0];
        NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    //    NSLog(@"Decode String: %@", decodedString);
    
    //encryptedString=[NSString stringWithFormat:@"%@",[dataImage base64Encoding]];
    obj_imagePick=[info valueForKey:UIImagePickerControllerOriginalImage];
    CGSize imageSize;
    if(obj_imagePick.size.height>900 && obj_imagePick.size.width>700)
    {
        imageSize = CGSizeMake(500,500);
    }
    else if(obj_imagePick.size.height>960)
    {
        imageSize = CGSizeMake(500,500);
    }
    else if(obj_imagePick.size.width>640)
    {
        imageSize = CGSizeMake(500,500);
    }
    else
    {
        imageSize=CGSizeMake(400,400);
    }
    
    UIGraphicsBeginImageContext(imageSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.width);
    [obj_imagePick drawInRect:imageRect];
    obj_imagePick = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageViewProfile.image=obj_imagePick;
    imageViewProfile.layer.cornerRadius=imageViewProfile.frame.size.height/2;
    imageViewProfile.clipsToBounds = YES;
    
    imageVW_plusIcon.hidden=YES;

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Register:(id)sender
{
    if (isStringEmpty([NSString stringWithFormat:@"%@",txt_firstname.text]))
    {
        txt_firstname.text=nil;
        alert(@"Message", @"Please Enter Your First Name.");
        [txt_firstname becomeFirstResponder];
    }
    else if (isStringEmpty([NSString stringWithFormat:@"%@",txt_lastname.text]))
    {
        alert(@"Message", @"Please Enter Your Last Name.");
        [txt_lastname becomeFirstResponder];
    }
    else if (txt_username.text.length==0){
        alert(@"Message", @"Please Enter Username.");
        [txt_username becomeFirstResponder];
    }
    else if (validateEmailWithString([NSString stringWithFormat:@"%@",txt_email.text])==FALSE)
    {
        alert(@"Message", @"Please Enter Valid Email Address.");
        
        [txt_email becomeFirstResponder];
    }
    else if (txt_password.text.length==0){
        
        alert(@"Message", @"Please Enter Password.");
        [txt_password becomeFirstResponder];
        
    }
    else if (txt_confirmPassword.text.length==0)
    {
        alert(@"Message", @"Please Enter Confirm Password.");
        [txt_confirmPassword becomeFirstResponder];
    }
    
    else if (![txt_password.text isEqualToString:txt_confirmPassword.text])
    {
        alert(@"Oops!", @"Password don't match\nPlease try again.");
        [txt_confirmPassword becomeFirstResponder];
    }
    else
    {
        BOOL checkNet = [[AppManager sharedManager] CheckReachability];
        if(!checkNet == FALSE)
        {
            if (isFromFacebookSignIN==YES || iSFromRegisterFacebookLogin==YES)
            {
                [self WebserviceFacebookUser];

            }
            else
            {
                [self WebserviceRegisterUser];

            }
            
        }
        
    }
    
}

-(void)WebserviceRegisterUser
{
   // http://dev414.trigma.us/krust/Webservices/signup?first_name=dhimu&last_name=dhimu&username=dhimu&email=dhimu@gmail.com&password=123456&image=b.png&register_type=manual&cpass=123456
    
   // http://dev414.trigma.us/krust/Webservices/signup?first_name=dhimu&last_name=dhimu&username=dhimu&email=dhimu@gmail.com&password=123456&image=b.png&register_type=facebook&cpass=123456&fb_id=123456
    
    if (encryptedString.length==0)
    {
        encryptedString=@"abc";
    }
    str_deviceToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"DeviceToken"];
    if (isStringEmpty(str_deviceToken))
    {
        str_deviceToken=@"12345";
    }
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"register_type" :@"manual",
                                         @"first_name" :txt_firstname.text,
                                         @"last_name" :txt_lastname.text,
                                         @"username" :txt_username.text,
                                         @"email" :txt_email.text,
                                         @"password" :txt_password.text,
                                         @"image" :encryptedString,
                                         @"cpass" :txt_confirmPassword.text,
                                         @"device_tocken" : str_deviceToken

                                         }];
   
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    // [appdelRef showProgress:@"Please wait.."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Ksignup];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
     //    NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];

             if ([[responseObject valueForKey:@"type"]isEqualToString:@"manual"])
             {
                 NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
                 
                 if(Status ==1)
                 {
                    
                     [[NSUserDefaults standardUserDefaults]setObject:[responseObject valueForKey:@"user_id"] forKey:@"USERID"];
                     
//                     alert(@"Alert", @"You are register successfully.");
                     
                     AppDelegate *app_in_login =(AppDelegate *)[[UIApplication sharedApplication]delegate];
                     app_in_login.window.rootViewController=tabbar_controller;
                     
                     [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"alreadylogin"];

                     txt_email.text=nil;
                     txt_firstname.text=nil;
                     txt_lastname.text=nil;
                     txt_password.text=nil;
                     txt_username.text=nil;
                     txt_confirmPassword.text=nil;
                     
                     return;
                     
                 }
                 
                 else if (Status==0)
                 {
                     alert(@"Alert", @"User not register.");
                     
                     [txt_email becomeFirstResponder];
                     
                     return;
                     
                 }
                 else if (Status==3)
                 {
                     alert(@"Alert", @"Email already exist.");
                     
                     [txt_email becomeFirstResponder];
                     
                     return;

                 }
             }
             
         }
         
         else
         {
             alert(@"Alert", @"Something went wrong.");
             
             [[AppManager sharedManager]hideHUD];
             
         }
         
     }
     
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Alert", @"Something went wrong.");
         
     }];
    
 
    
}

-(void)WebserviceFacebookUser
{
    if (encryptedString.length==0)
    {
        encryptedString=@"abc";
    }
    
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
                                         @"first_name" :txt_firstname.text,
                                         @"last_name" :txt_lastname.text,
                                         @"username" :txt_username.text,
                                         @"email" :txt_email.text,
                                         @"password" :txt_password.text,
                                         @"image" :encryptedString,
                                         @"cpass" :txt_confirmPassword.text,
                                         @"fb_id" : Fcaebook_id,
                                         @"device_tocken" : str_deviceToken
                                         
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    // [appdelRef showProgress:@"Please wait.."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Ksignup];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
    //     NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
    
                 NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
                 
                 if(Status ==1)
                 {
                     
                     [[NSUserDefaults standardUserDefaults]setObject:[responseObject valueForKey:@"user_id"] forKey:@"USERID"];
                     
                     //   alert(@"Alert", @"You are register successfully.");
                     
                     AppDelegate *app_in_login =(AppDelegate *)[[UIApplication sharedApplication]delegate];
                     app_in_login.window.rootViewController=tabbar_controller;
                     
                     [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"alreadylogin"];
                     [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"facebooklogin"];

                     txt_email.text=nil;
                     txt_firstname.text=nil;
                     txt_lastname.text=nil;
                     txt_password.text=nil;
                     txt_username.text=nil;
                     txt_confirmPassword.text=nil;
                     
                     return;
                 }
                 
                 else if (Status==0)
                 {
                     alert(@"Alert", @"User not register.");
                     
                     [txt_email becomeFirstResponder];
                     
                     return;
                     
                 }
                 else if (Status==3)
                 {
                     alert(@"Alert", @"Email already exist.");
                     
                     [txt_email becomeFirstResponder];
                     
                     return;
                     
                 }
             
         }
         
         else
         {
             alert(@"Alert", @"Something went wrong.");
             
             [[AppManager sharedManager]hideHUD];
             
         }
         
     }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Alert", @"Something went wrong.");
         
     }];
}

- (IBAction)TappedOnsingIn:(id)sender
{
    [[FBSDKLoginManager new] logOut];
    
    LoginVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self.navigationController pushViewController:vc1 animated:YES];


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
        // NSLog(@"----%@",result);
         
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
//                 NSLog(@"fb user info : %@",result);
                 
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
         
      //   NSLog(@"JSON: %@", responseObject);
         
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
//                 RegisterVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"register"];
//                 vc1.FaceBookData=arr_Facebookdata;
//                 vc1.isFromFacebookSignIN=YES;
//                 [self.navigationController pushViewController:vc1 animated:YES];
                 iSFromRegisterFacebookLogin=YES;
                 [self RegisterFacebookLogin];
                 
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

@end
