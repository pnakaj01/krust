//
//  FollowerlistViewController.m
//  Krust
//
//  Created by Pankaj Sharma on 16/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import "FollowerlistViewController.h"
#import "FollowersListTableViewCell.h"
#import "AppManager.h"
#import "Profile VC.h"
#import "Haneke.h"

@interface FollowerlistViewController ()

@end

@implementation FollowerlistViewController

@synthesize str_post_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    PopUp_AlertComment.hidden=YES;
    [AppManager sharedManager].navCon = self.navigationController;
    arr_likeData=[[NSMutableArray alloc]init];
    arr_Listusers=[[NSMutableArray alloc]init];
    self.tabBarController.tabBar.hidden=YES;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    
    if(!checkNet == FALSE)
    {
        _tableview_like.hidden=NO;
        
        [self GetLikeData];
    }
    else
    {
        _tableview_like.hidden=YES;
    }
}



-(void)GetLikeData
{
    
    //http://dev414.trigma.us/krust/Webservices/video_userlike_list?video_id=15&user_id=785
    
    str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    if (isStringEmpty(str_post_id))
    {
        str_post_id=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         @"user_id" : str_post_id,
                                         @"login_user_id" : str_userID
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kfollowers];
    
    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     
     {
         // Get response from server
         
   //      NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
             NSInteger Status=[[[[responseObject valueForKey:@"list"]objectAtIndex:0]valueForKey:@"status"] integerValue];
             
             if(Status == 1)
             {
                 PopUp_AlertComment.hidden=YES;
                 
                 arr_likeData=[responseObject valueForKey:@"list"];
                 
                 [_tableview_like reloadData];
                 
                 return;
             }
             else if (Status==0)
             {
                 
            //   alert(@"Alert", @"No Likes.");
                 
                 PopUp_AlertComment.hidden=NO;
                 [[AppManager sharedManager]hideHUD];
                 return;
                 
             }
         }
         
     }
     
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [[AppManager sharedManager]hideHUD];
         PopUp_AlertComment.hidden=NO;

         alert(@"Alert", @"Something went wrong.");
         
     }];
    
}

#pragma mark --TableView Delegate--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr_likeData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellIdentifier = @"FollowersListTableViewCell";
    // Similar to UITableViewCell, but
    FollowersListTableViewCell *tempcell;
    
    if (tempcell == nil)
    {
        tempcell = (FollowersListTableViewCell *)[_tableview_like dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        tempcell = (FollowersListTableViewCell *)[nib objectAtIndex:0];
        if ([arr_likeData count]>0)
        {
            
        [tempcell loaditemwithAdvertListArray:[arr_likeData objectAtIndex:indexPath.row]];
            
        }
    }
    
    if ([arr_likeData count]>0)
    {
        tempcell.selectionStyle = UITableViewCellSelectionStyleNone;
        tempcell.selectionStyle=UITableViewCellAccessoryNone;
        tempcell.btn_follow.tag=indexPath.row;
        [tempcell.btn_follow addTarget:self action:@selector(FollowAction:) forControlEvents:UIControlEventTouchUpInside];
        
        tempcell.btn_UserProfile.tag=indexPath.row;
        [tempcell.btn_UserProfile addTarget:self action:@selector(UserProfile:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    
    // Just want to test, so I hardcode the data
    return tempcell;
}

-(void)UserProfile:(id)sender
{
    Profile_VC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    vc1.str_post_id=[[arr_likeData valueForKey:@"id"]objectAtIndex:[sender tag]];
    [self.navigationController pushViewController:vc1 animated:YES];
}
-(void)FollowAction:(id)sender
{
    //http://dev414.trigma.us/krust/Webservices/follow_user?user_id=785&follow_id=786
    
    str_followfriendID=[[arr_likeData valueForKey:@"id"]objectAtIndex:[sender tag]];

    NSIndexPath *path = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    
    FollowersListTableViewCell *privateCell =(FollowersListTableViewCell*)[_tableview_like cellForRowAtIndexPath:path];
    
    privateCell.btn_follow.userInteractionEnabled=NO;

    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    
    if ([str_userID isEqualToString:str_followfriendID])
    {
        
    }
    else
    {
        str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
        
        if (isStringEmpty(str_userID))
        {
            str_userID=@"";
        }
        if (isStringEmpty(str_followfriendID)) {
            str_followfriendID=@"";
        }
        
        
        NSInteger Status=[[[arr_likeData valueForKey:@"follow_status"] objectAtIndex:[sender tag]] integerValue];
        
        if(Status ==1)
        {
            follow_status=@"0";
        }
        else
        {
            follow_status=@"1";
        }
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                           
                                           @{
                                             @"follow_id" : str_followfriendID,
                                             @"user_id" : str_userID,
                                             @"status" : follow_status
                                             
                                             }];
        
        
        //        [[AppManager sharedManager] showHUD:@"Loading..."];
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kfollowuser];
        
        [[AppManager sharedManager] getDataForUrl:url
         
                                       parameters:parameters
         
                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
         
         {
             // Get response from server
             
      //       NSLog(@"JSON: %@", responseObject);
             
             
             if ([responseObject count]>0)
             {
                 privateCell.btn_follow.userInteractionEnabled=YES;

                 [[AppManager sharedManager]hideHUD];
                 
                 NSInteger Status=[[responseObject valueForKey:@"status"]integerValue];
                 
                 if(Status == 1)
                 {
                     [self GetLikeData];
                     
                     return;
                 }
                 else if (Status==0)
                 {
                     [self GetLikeData];
                     
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
    
}



- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
