//
//  Setting VC.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "Setting VC.h"
#import "changepasswordVC.h"
#import "AppManager.h"
#import "AsyncImageView.h"
#import "notificationVC.h"
#import "FeedbackViewController.h"
#import "FirstVC.h"
#import "AppDelegate.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "TeamsVC.h"
#import "Profile VC.h"
#import "Haneke.h"


@interface Setting_VC ()

@end

@implementation Setting_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [scrollVW_setting setContentSize:CGSizeMake(320,600)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived:) name:@"TestNotification" object:nil];
    
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
-(void)pushNotificationReceived:(NSNotification*) notification
{
    //    NSLog(@"Push notification call %@",[notification object]);
    
    Statusofnotification=[[[[notification object] valueForKey:@"data"]valueForKey:@"status"] integerValue];
    
    [self.tabBarController setSelectedIndex:3];
    
    //    notificationVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"notification"];
    //    vc1.StatusNotification=Statusofnotification;
    //    [self.navigationController pushViewController:vc1 animated:YES];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    btn_facebookconnect.userInteractionEnabled=YES;
    lbl_connectTOFacebook.textColor=[UIColor darkGrayColor];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"facebooklogin"]==YES)
    {
        btn_facebookconnect.userInteractionEnabled=NO;
        lbl_connectTOFacebook.textColor=[UIColor lightGrayColor];
    }
    
    [AppManager sharedManager].navCon = self.navigationController;

    btn_submit.hidden=YES;
   
    if (isFromMethod==YES)
    {
    
    }
    else
    {
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
        [self WebServiceShowProfileData];
    }
    }
    
    imageViewProfile.layer.cornerRadius=imageViewProfile.frame.size.height/2;
    imageViewProfile.clipsToBounds = YES;

//    lbl_username.minimumScaleFactor=YES;
    lbl_email.adjustsFontSizeToFitWidth=YES;
    lbl_name.adjustsFontSizeToFitWidth=YES;
    
    self.tabBarController.tabBar.hidden=YES;
    
}
-(void)WebServiceShowProfileData
{
//    http://dev414.trigma.us/krust/Webservices/profile?user_id=781
    
    
    NSString *str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];

    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" :str_userID
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    // [appdelRef showProgress:@"Please wait.."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kprofile];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
        success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
      //   NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
                 NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
                 
                 if(Status ==1)
                 {
                lbl_username.text=[responseObject valueForKey:@"username"];
                lbl_email.text=[responseObject valueForKey:@"email"];
                lbl_name.text=[AppManager getCurrectValue:[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"first_name"]]];
                //imageViewProfile.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"profile_image"]]];
                     
                     NSString *imagestr1 =[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"profile_image"]];
                     [imageViewProfile hnk_setImageFromURL:[NSURL URLWithString:imagestr1]];


                     
                     return;
                     
                 }
                 else if (Status==0)
                 {
                     alert(@"Alert", @"Something went wrong.");

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)Logout:(id)sender
{
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
    [self WebserviceLogout];
    }
}

-(void)WebserviceLogout
{
    //http://dev414.trigma.us/krust/Webservices/logout?user_id=882
    
    NSString *str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" :str_userID
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    // [appdelRef showProgress:@"Please wait.."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Klogout];

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
                 [[FBSDKLoginManager new] logOut];
                 isFromLogout=YES;
                 
                 //    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
                 //    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
                 
                 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"alreadylogin"];
                 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"facebooklogin"];
                 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FromCustumChallenge"];
                 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FromTagTeam"];
                 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"NotificationApear"];
                 
                 AppDelegate *app_in_login =(AppDelegate *)[[UIApplication sharedApplication]delegate];
                 FirstVC *ViewController_obj=[self.storyboard instantiateViewControllerWithIdentifier:@"FirstVC"];
                 UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:ViewController_obj];
                 [self.tabBarController setSelectedIndex:0];
                 app_in_login.window.rootViewController=nav;
                 nav.navigationBarHidden=YES;
                 
                 //    [[tabbar_controller.tabBar.items objectAtIndex:3] setBadgeValue:@""];
                 notificationVC *viewController = [self.tabBarController.viewControllers objectAtIndex:3];
                 viewController.tabBarItem.badgeValue = nil;
                 
                 return;
                 
             }
             else if (Status==0)
             {
                 alert(@"Alert", @"Something went wrong.");
                 
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

-(void)WebserviceFaceBookLogout
{
    //http://dev414.trigma.us/krust/Webservices/logout?user_id=882
    
    NSString *str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" :str_userID
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    // [appdelRef showProgress:@"Please wait.."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Klogout];

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
                 [[FBSDKLoginManager new] logOut];
                 isFromLogout=YES;
                 
                 //    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
                 //    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
                 
                 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"alreadylogin"];
                 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"facebooklogin"];
                 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FromCustumChallenge"];
                 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FromTagTeam"];
                 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"NotificationApear"];
                 
                 AppDelegate *app_in_login =(AppDelegate *)[[UIApplication sharedApplication]delegate];
                 FirstVC *ViewController_obj=[self.storyboard instantiateViewControllerWithIdentifier:@"FirstVC"];
                 UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:ViewController_obj];
                 ViewController_obj.isFromSettingFacebook=YES;
                 [self.tabBarController setSelectedIndex:0];
                 app_in_login.window.rootViewController=nav;
                 nav.navigationBarHidden=YES;
                 
                 //    [[tabbar_controller.tabBar.items objectAtIndex:3] setBadgeValue:@""];
                 notificationVC *viewController = [self.tabBarController.viewControllers objectAtIndex:3];
                 viewController.tabBarItem.badgeValue = nil;
                 
                 return;
                 
             }
             else if (Status==0)
             {
                 alert(@"Alert", @"Something went wrong.");
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

- (IBAction)changepassword:(id)sender
{
    changepasswordVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"changepassword"];
    [self.navigationController pushViewController:vc1 animated:YES];
}
- (IBAction)TappedOnFeedback:(id)sender
{
    FeedbackViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
    [self.navigationController pushViewController:vc1 animated:YES];
    
}
- (IBAction)TappedOnfacebook:(id)sender
{
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
    [self WebserviceFaceBookLogout];
    }
}

#pragma mark --Action Method--
- (IBAction)TappedCamera:(id)sender
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
            isFromMethod=YES;

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
            isFromMethod=YES;

            UIImagePickerController *obj_ImagePicker=[[UIImagePickerController alloc]init];
            obj_ImagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            obj_ImagePicker.editing=YES;
            obj_ImagePicker.delegate=self;
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
   // NSLog(@"Decode String: %@", decodedString);
    
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
    [self EditProfilePIC];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)EditProfilePIC
{
    //http://dev414.trigma.us/krust/Webservices/profile_edit?user_id=781&profile_image=abc.png
    
   //http://dev414.trigma.us/krust/Webservices/profile_edit?user_id=781&first_name=dhimu&username=dhimu&email=dhimu@gmail.com&profile_image=abc.png
    
    if (isStringEmpty(encryptedString))
    {
        encryptedString=@"abc";
    }
    
    
    NSString *str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    
    if (isStringEmpty(str_userID))
    {
    str_userID=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" :str_userID,
                                         @"profile_image" :encryptedString,
                                         @"first_name" : lbl_name.text,
                                         @"username" : lbl_username.text,
                                         @"email" : lbl_email.text
                                         
                                         }];
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    // [appdelRef showProgress:@"Please wait.."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kprofileedit];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
      //   NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
             
             NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
             
             if(Status ==1)
             {
                 alert(@"Alert", @"Profile image successfully updated.");
                
                 return;
                 
             }
             
             else if (Status==0)
             {
                 alert(@"Alert", @"Failed to update profile image.");
                 
                 return;
             }
         }
         
         else
         {
             alert(@"Alert", @"Null DATA.");
             
             [[AppManager sharedManager] hideHUD];
             
         }
         
     }
     
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Alert", @"Something went wrong.");
         
     }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == lbl_username)
    {
        [lbl_username  resignFirstResponder];
    }
       return YES;
}

#pragma mark  Touch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [lbl_username resignFirstResponder];
}

-(void)textFieldDidChange:(UITextField *)textField
{
    btn_submit.hidden=NO;
}



-(void)viewWillDisappear:(BOOL)animated
{
    if (isFromLogout==YES)
    {
        isFromLogout=NO;

        [self.navigationController popViewControllerAnimated:YES];
    }
//    else
//    {
//    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)TappedOnSubmit:(id)sender
{
//    [self EditProfilePIC];
}

- (IBAction)TappedOnViewProfile:(id)sender
{
    NSString *str_userID1=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];

    Profile_VC *VC1=    [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    VC1.str_post_id=str_userID1;
    [self. navigationController pushViewController:VC1 animated:YES];
    
}

- (IBAction)TappedOnviewteams:(id)sender
{
    TeamsVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"TeamsVC"];
    [self.navigationController pushViewController:vc1 animated:YES];
}
- (IBAction)TappedOnDeleteProfile:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to delete your profile." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
    }
    else if (buttonIndex == 1)
    {
        [self WebserviceDeleteProfile];
    }
}

-(void)WebserviceDeleteProfile
{
    
   // http://dev414.trigma.us/krust/Webservices/user_profile_delete?id=445
    
    NSString *str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"id" :str_userID
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    // [appdelRef showProgress:@"Please wait.."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kuserprofiledelete];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
      //   NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
             NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
             
             if(Status ==1)
             {
                
                 [[FBSDKLoginManager new] logOut];
                 isFromLogout=YES;
                 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"alreadylogin"];
                 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"facebooklogin"];
                 
                 AppDelegate *app_in_login =(AppDelegate *)[[UIApplication sharedApplication]delegate];
                 FirstVC *ViewController_obj=[self.storyboard instantiateViewControllerWithIdentifier:@"FirstVC"];
                 UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:ViewController_obj];
                 [self.tabBarController setSelectedIndex:0];
                 app_in_login.window.rootViewController=nav;
                 nav.navigationBarHidden=YES;
                 
//                 [[tabbar_controller.tabBar.items objectAtIndex:3] setBadgeValue:@""];
                 notificationVC *viewController = [self.tabBarController.viewControllers objectAtIndex:3];
                 viewController.tabBarItem.badgeValue = nil;

                 return;
                 
             }
             else if (Status==0)
             {
                 alert(@"Alert", @"Something went wrong.");

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




@end
