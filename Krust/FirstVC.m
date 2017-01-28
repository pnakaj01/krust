//
//  FirstVC.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "FirstVC.h"
#import "AppManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "RegisterVC.h"
#import "AppDelegate.h"

@interface FirstVC ()

@end

@implementation FirstVC
@synthesize isFromSettingFacebook;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    arr_Facebookdata=[[NSMutableArray alloc]init];

    if (isFromSettingFacebook==YES)
    {
        isFromSettingFacebook=NO;
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
        
        [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
   //          NSLog(@"----%@",result);
             
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
      //           NSLog(@"fb user info : %@",result);
                 
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
         
  //       NSLog(@"JSON: %@", responseObject);
         
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation\

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
