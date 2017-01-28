//
//  EditteamVC.m
//  Krust
//
//  Created by Pankaj Sharma on 10/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import "EditteamVC.h"
#import "AppManager.h"
#import "AddTeamVC.h"
#import "TeamMatesVC.h"
#import "TeamsVC.h"
#import "Haneke.h"

@interface EditteamVC ()

@end

@implementation EditteamVC

@synthesize  str_groupID;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    imageVW_plusIcon.hidden=NO;
    
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
        [self ShowTeamProfile];
    }
    
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

-(void)viewDidAppear:(BOOL)animated
{
   }
-(void)ShowTeamProfile
{
    // http://dev414.trigma.us/krust/Webservices/group_show?group_id=13
    if (isStringEmpty(str_groupID))
    {
        str_groupID=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"group_id" : str_groupID
                                         
                                         }];
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,kgroupshow];

    
    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     
     {
         // Get response from server
         
    //     NSLog(@"JSON: %@", responseObject);
         
         
         if ([responseObject count]>0)
         {
             
             [[AppManager sharedManager]hideHUD];
             
             NSInteger Status=[[[[responseObject objectForKey:@"list"]objectAtIndex:0] valueForKey:@"status"] integerValue];
             
             if(Status == 1)
             {
                 
                 txt_description.text=[[[responseObject objectForKey:@"list"]objectAtIndex:0] valueForKey:@"description"];
                 
                 txt_subject.text=[[[responseObject objectForKey:@"list"]objectAtIndex:0] valueForKey:@"group_name"];

                 imageViewProfile.layer.cornerRadius=imageViewProfile.frame.size.height/2;
                 imageViewProfile.clipsToBounds = YES;
                 
                 imageVW_plusIcon.hidden=YES;
                 
                 NSString *imagestr1 =[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"list"]objectAtIndex:0] valueForKey:@"image"]];
                 [imageViewProfile hnk_setImageFromURL:[NSURL URLWithString:imagestr1]];

                 

                 //                 TeamsVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"TeamsVC"];
                 //                 [self.navigationController pushViewController:vc1 animated:YES];
                 
                return;
             }
             
             else if (Status==0)
             {
                 [[AppManager sharedManager]hideHUD];
                 
                 return;
             }
         }
         
     }
     
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Error", @"something went wrong.");
     }];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    //    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Plusicon"]==YES)
    //    {
    //        imageVW_plusIcon.hidden=YES;
    //    }
    
    
    txt_description.placeholder = @"Description";
    txt_description.font=[UIFont fontWithName:@"System" size:18.0];
    txt_description.placeholderColor = [UIColor  colorWithRed:277.0/255.0 green:100.0/255.0 blue:63.0/255.0 alpha:1];
    
    txt_subject.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Team name" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:277.0/255.0 green:100.0/255.0 blue:63.0/255.0 alpha:1]}];
    
    
    [AppManager sharedManager].navCon = self.navigationController;
    
}
- (IBAction)TappedOnSubmit:(id)sender
{
    
    
  
    
    if (isStringEmpty([NSString stringWithFormat:@"%@",txt_subject.text]))
    {
        [txt_subject becomeFirstResponder];
        alert(@"Message", @"Please Enter Team name.");
        
    }
    else if (isStringEmpty([NSString stringWithFormat:@"%@",txt_description.text]))
    {
        txt_description.text=nil;
        alert(@"Message", @"Please Enter Description.");
        [txt_description becomeFirstResponder];
    }
    else
    {
        BOOL checkNet = [[AppManager sharedManager] CheckReachability];
        if(!checkNet == FALSE)
        {
            [txt_subject resignFirstResponder];
            [txt_description resignFirstResponder];
            
            [self WebServiceAddTeam];
            //            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Plusicon"];
            
        }
    }
    
}

-(void)WebServiceAddTeam
{
    
    //http://dev414.trigma.us/krust/Webservices/edit_group?user_id=12&group_name=test&description=12&group_user=1,2&group_id=6&image=6
    
    if (isStringEmpty(encryptedString))
    {
        encryptedString=@"abc";
    }
    
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" : str_userID,
                                         @"group_name" : txt_subject.text,
                                         @"description" : txt_description.text,
                                         @"group_id" : str_groupID,
                                         @"image" : encryptedString
                                         
                                         }];
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,keditgroup];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     
     {
         // Get response from server
         
   //      NSLog(@"JSON: %@", responseObject);
         
         
         if ([responseObject count]>0)
         {
             
             [[AppManager sharedManager]hideHUD];
             
             NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
             
             if(Status == 1)
             {
                 
                 //                 TeamsVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"TeamsVC"];
                 //                 [self.navigationController pushViewController:vc1 animated:YES];
                 
                 [self.navigationController popViewControllerAnimated:YES];
                 
                 return;
             }
             
             else if (Status==0)
             {
                 [[AppManager sharedManager]hideHUD];
                 
                 return;
             }
         }
         
     }
     
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Error", @"error");
     }];
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txt_subject resignFirstResponder];
    [txt_description resignFirstResponder];
}
- (IBAction)back:(id)sender
{
    txt_description.text=nil;
    txt_subject.text=nil;
    //    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Plusicon"];
    
    //    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedValueArray"];
    //    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Dic"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [txt_description resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txt_subject)
    {
        [txt_subject  resignFirstResponder];
    }
    return YES;
}

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
 //   NSLog(@"Decode String: %@", decodedString);
    
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
-(void)viewWillDisappear:(BOOL)animated
{
    imageVW_plusIcon.hidden=NO;
    
}

@end
