//
//  Detal VC.m
//  Krust
//
//  Created by Pankaj Sharma on 07/08/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "Detal VC.h"
#import "AppManager.h" 


@interface Detal_VC ()

@end

@implementation Detal_VC

@synthesize  str_encripedString;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSLog(@"%@",str_encripedString);
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    isSelected=YES;
    
    UIColor *color = [UIColor lightGrayColor];
    
    txt_challengename.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Challenge name" attributes:@{NSForegroundColorAttributeName: color}];

    [AppManager sharedManager].navCon = self.navigationController;
    
    btn_customchallenge.layer.cornerRadius=btn_customchallenge.frame.size.height/2;
    btn_customchallenge.clipsToBounds = YES;
    
    btn_adminChallenge.layer.cornerRadius=btn_adminChallenge.frame.size.height/2;
    btn_adminChallenge.clipsToBounds = YES;

    txtVW_Details.placeholder = @"Description";
    txtVW_Details.font=[UIFont fontWithName:@"System" size:18.0];
    txtVW_Details.placeholderColor = [UIColor  lightGrayColor];
    
    self.tabBarController.tabBar.hidden=NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)TappedONDone:(id)sender
{
    
    if (isStringEmpty(str_ChallengeType))
    {
        alert(@"Message", @"Please Enter Challenge Type.");
    }
    else if (isStringEmpty([NSString stringWithFormat:@"%@",txt_challengename.text]))
    {
        [txt_challengename becomeFirstResponder];
        alert(@"Message", @"Please Enter Challenge Name.");

    }
    else if (isStringEmpty([NSString stringWithFormat:@"%@",txtVW_Details.text]))
    {
        txtVW_Details.text=nil;
        alert(@"Message", @"Please Enter Description.");
        [txtVW_Details becomeFirstResponder];
    }
    else
    {
        BOOL checkNet = [[AppManager sharedManager] CheckReachability];
        if(!checkNet == FALSE)
        {
            [txt_challengename resignFirstResponder];
            [txtVW_Details resignFirstResponder];

            [self WebservicePostVideo];
            
        }
    }
}

- (IBAction)TappedOncustomChallenge:(id)sender
{
    btn_customchallenge.backgroundColor =  [UIColor colorWithRed:186.0f/255 green:53.0f/255 blue:11.0f/255 alpha:1.0f];
    btn_adminChallenge.backgroundColor =  [UIColor colorWithRed:170.0f/255 green:170.0f/255 blue:170.0f/255 alpha:1.0f];
    str_ChallengeType=@"custom";
}
- (IBAction)TappedONAdminChallenge:(id)sender
{
    btn_adminChallenge.backgroundColor =  [UIColor colorWithRed:186.0f/255 green:53.0f/255 blue:11.0f/255 alpha:1.0f];
    btn_customchallenge.backgroundColor =  [UIColor colorWithRed:170.0f/255 green:170.0f/255 blue:170.0f/255 alpha:1.0f];
    str_ChallengeType=@"admin";

}
-(void)WebservicePostVideo
{
//    http://dev414.trigma.us/krust/Webservices/videoupload?user_id=782&Video_name=abc.mp4&description=abc
    
   // http://dev414.trigma.us/krust/Webservices/videoupload?user_id=782&Video_name=abc.mp4&description=abc&challenge_name=abc&challenge_to=1,2
    
    NSString *str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    
    if (isStringEmpty(str_encripedString))
    {
        str_encripedString=@"123";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" :str_userID,
                                         @"Video_name" :str_encripedString,
                                         @"description" :txtVW_Details.text,
                                         @"challenge_name" :txt_challengename.text,
                                         @"challenge_to" : @"",
                                         @"post_valid" : @""
                                         
                                         
                                         }];
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    // [appdelRef showProgress:@"Please wait.."];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,kvideoupload];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
    //     NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
             if ([[responseObject valueForKey:@"msg"]isEqualToString:@"upload video"])
             {
                 NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
                 
                 if(Status ==1)
                 {
                     
                     alert(@"Alert", @"Video posted successfully.");
                     [self.navigationController popViewControllerAnimated:YES];
                     txtVW_Details.text=nil;
                     txt_challengename.text=nil;
                     
                     return;
                     
                 }
                 
                 else if (Status==0)
                 {
                     alert(@"Alert", @"Video not successfully post.");

                     return;
                 }
             }
             
         }
         
         else
         {
             alert(@"Alert", @"Null Occur");
             
             [[AppManager sharedManager] hideHUD];
             
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
    [txtVW_Details resignFirstResponder];
    [txt_challengename resignFirstResponder];
}
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [txtVW_Details resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

@end
