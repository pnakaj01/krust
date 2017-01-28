//
//  notificationVC.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "notificationVC.h"
#import "NotificationTableViewCell.h"
#import "AppManager.h"
#import "HeaderFile.h"
#import "NotificationTableViewCell.h"
#import "Profile VC.h"
#import "NotificationDetailVC.h"
#import "Haneke.h"
#import "AppDelegate.h"
@interface notificationVC ()

@end

@implementation notificationVC
@synthesize isFromSetting,StatusNotification;

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0, 0, 320, 44);
    tablevW_notification.tableFooterView = spinner;

    page_count=1;

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
//    [[tabbar_controller.tabBar.items objectAtIndex:3] setBadgeValue:@""];
//    NotificationDetailVC *viewController = [self.tabBarController.viewControllers objectAtIndex:3];
//    
//    viewController.tabBarItem.badgeValue = nil;

    Statusofnotification=[[[[notification object] valueForKey:@"data"]valueForKey:@"status"] integerValue];
    [self.tabBarController setSelectedIndex:3];

    if (Statusofnotification == 1)
    {
        segment.selectedSegmentIndex = 0;
        [self GetLeaderboardData];
    }
    else
    {
        segment.selectedSegmentIndex = 1;
        [self GetLeaderboardData];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"NotificationApear"];
    notificationVC *viewController = [self.tabBarController.viewControllers objectAtIndex:3];
    
    viewController.tabBarItem.badgeValue = nil;
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"Pushcontroller" object:self userInfo:nil];
    
    View_PoPUP.hidden=YES;
    btn_back.hidden=YES;
    str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    self.tabBarController.tabBar.hidden=NO;
    arr_notificationns=[[NSMutableArray alloc]init];
    
    if (isFromSetting==YES)
    {
        btn_back.hidden=NO;
        self.tabBarController.tabBar.hidden=YES;
        if (IS_IPHONE_5)
        {
            tablevW_notification.frame=CGRectMake(0, 100, 320, tablevW_notification.frame.size.height+44);
        }
        else if(IS_IPHONE_6)
        {
            tablevW_notification.frame=CGRectMake(0, 130, 375, tablevW_notification.frame.size.height+52);
        }
        else if (IS_IPHONE_6_PLUS)
        {
            tablevW_notification.frame=CGRectMake(0, 150, 414, tablevW_notification.frame.size.height+72);
        }
    }
    else
    {
        btn_back.hidden=YES;
    }
    
    [AppManager sharedManager].navCon = self.navigationController;
    

}
-(void)viewDidDisappear:(BOOL)animated
{
    [[tabbar_controller.tabBar.items objectAtIndex:3] setBadgeValue:@""];
    notificationVC *viewController = [self.tabBarController.viewControllers objectAtIndex:3];
    viewController.tabBarItem.badgeValue = nil;
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
 
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
        tablevW_notification.hidden=NO;
        
        [self GetLeaderboardData];
    }
    else
    {
        tablevW_notification.hidden=YES;
    }
    
//    if (StatusNotification == 1)
//    {
//        segment.selectedSegmentIndex=1;
//        [self GetLeaderboardData];
//    }
//    else
//    {
//        segment.selectedSegmentIndex=0;
//        [self GetLeaderboardData];
//    }

}

- (IBAction)segmentAction:(id)sender
{
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
        tablevW_notification.hidden=NO;
        [self GetLeaderboardData];
    }
    else
    {
        tablevW_notification.hidden=YES;
    }
    
}


-(void)GetLeaderboardData
{
    //    http://dev414.trigma.us/krust/Webservices/notification_news?user_id=785
    
    [[tabbar_controller.tabBar.items objectAtIndex:3] setBadgeValue:@""];
    notificationVC *viewController = [self.tabBarController.viewControllers objectAtIndex:3];
    viewController.tabBarItem.badgeValue = nil;
    
    if (segment.selectedSegmentIndex==0)
    {
        segment.selectedSegmentIndex=0;
        
        if (isStringEmpty(str_userID))
        {
            str_userID=@"";
        }
        
        NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithDictionary:
                                           
                                           @{
                                             
                                             @"user_id" : str_userID
                                             
                                             }];
        
        
       
            [[AppManager sharedManager] showHUD:@"Loading..."];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Knotificationnews];

        [[AppManager sharedManager] getDataForUrl:url
         
                                       parameters:parameters
         
        success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
         
         {
             // Get response from server
             
         //    NSLog(@"JSON: %@", responseObject);
             
             if ([responseObject count]>0)
             {
                 
                 [[AppManager sharedManager]hideHUD];
                 
                  NSInteger Status=[[[[responseObject objectForKey:@"list"]valueForKey:@"post_status"]objectAtIndex:0] integerValue];
            
                 
                 if(Status==1)
                 {
                     arr_notificationns=[responseObject valueForKey:@"list"];
                     View_PoPUP.hidden=YES;
                     tablevW_notification.hidden=NO;
                     [tablevW_notification reloadData];
//                     [spinner stopAnimating];
                     
                     return;
                 }
                 else if (Status==0)
                 {
                     
//                     alert(@"Alert", @"No Notifications.");
                     tablevW_notification.hidden=YES;
                     View_PoPUP.hidden=NO;
//                     [spinner stopAnimating];
                     [[AppManager sharedManager]hideHUD];
                     return;
                     
                     
                 }
             }
             
         }
         
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
         
         {
             [[AppManager sharedManager]hideHUD];
             [spinner stopAnimating];
             tablevW_notification.hidden=YES;
             View_PoPUP.hidden=NO;
             alert(@"Alert", @"Something went wrong.");
             
         }];
        
    }
    
    else
    {
//        http://dev414.trigma.us/krust/Webservices/challenge_come?user_id=785
        segment.selectedSegmentIndex=1;
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                           
                                           @{
                                             
                                             @"user_id" : str_userID
                                          
                                             }];
        
        [[AppManager sharedManager] showHUD:@"Loading..."];
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kchallengecome];

        [[AppManager sharedManager] getDataForUrl:url
         
                                       parameters:parameters
         
               success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
         
         {
             // Get response from server
             
          //   NSLog(@"JSON: %@", responseObject);
             
             if ([responseObject count]>0)
             {
                 [[AppManager sharedManager]hideHUD];
                 
                  NSString *Status=[[[responseObject valueForKey:@"list"]objectAtIndex:0]valueForKey:@"status"];
                 
                 if([Status isEqualToString:@"1"])
                 {
                     View_PoPUP.hidden=YES;
                     tablevW_notification.hidden=NO;
                     arr_notificationns=[responseObject valueForKey:@"list"];
                     [tablevW_notification reloadData];
                     return;
                 }
                 else if ([Status isEqualToString:@"0"])
                 {
//                     alert(@"Alert", @"No Notifications.");
                     tablevW_notification.hidden=YES;
                     View_PoPUP.hidden=NO;
                     [[AppManager sharedManager]hideHUD];
                     return;
                     
                 }
             }
             
         }
         
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
         
         {
             [[AppManager sharedManager]hideHUD];
             tablevW_notification.hidden=YES;
             View_PoPUP.hidden=NO;
             alert(@"Error", @"error");
             
         }];
        
    }
    
}

#pragma mark --TableView Delegate--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr_notificationns count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"NotificationTableViewCell";
    // Similar to UITableViewCell, but
    NotificationTableViewCell *tempcell;
    
    if (tempcell == nil)
    {
        tempcell = (NotificationTableViewCell *)[tablevW_notification dequeueReusableCellWithIdentifier:cellIdentifier];
        // tempcell = [[HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        tempcell = (NotificationTableViewCell *)[nib objectAtIndex:0];

        if ([arr_notificationns count]>0)
        {
            [tempcell loaditemwithAdvertListArray:[arr_notificationns objectAtIndex:indexPath.row]];
        }
    }
    if ([arr_notificationns count]>0)
    {
        tempcell.selectionStyle = UITableViewCellSelectionStyleNone;
        tempcell.selectionStyle=UITableViewCellAccessoryNone;
        tempcell.btn_Name.tag=indexPath.row;
        tempcell.btn_accpt.tag=indexPath.row;
        tempcell.btn_reject.tag=indexPath.row;

        [tempcell.btn_Name addTarget:self action:@selector(UserProfilePUSH:) forControlEvents:UIControlEventTouchUpInside];
        [tempcell.btn_accpt addTarget:self action:@selector(AcceptUSER:) forControlEvents:UIControlEventTouchUpInside];
        [tempcell.btn_reject addTarget:self action:@selector(RejectUSER:) forControlEvents:UIControlEventTouchUpInside];

        if ([[[arr_notificationns valueForKey:@"type_status"] objectAtIndex:indexPath.row]isEqualToString:@"group"])
        {
            
            NSInteger Status=[[[arr_notificationns valueForKey:@"accept"]objectAtIndex:indexPath.row]integerValue] ;
            
            if (Status==0)
            {
                if (IS_IPHONE_5)
                {
                    tempcell.lbl_notification.frame=CGRectMake(56, 4, 140, 21);
                }
                if (IS_IPHONE_6)
                {
                    tempcell.lbl_notification.frame=CGRectMake(56, 4, 150, 21);
                }
                else if (IS_IPHONE_6_PLUS)
                {
                    tempcell.lbl_notification.frame=CGRectMake(56, 4, 160, 21);
                }
                
            }

        }
        
    }
    // Just want to test, so I hardcode the data
    return tempcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[arr_notificationns valueForKey:@"type_status"]objectAtIndex:indexPath.row] isEqualToString:@"like"] || [[[arr_notificationns valueForKey:@"type_status"]objectAtIndex:indexPath.row] isEqualToString:@"comments"] || [[[arr_notificationns valueForKey:@"type_status"]objectAtIndex:indexPath.row] isEqualToString:@"challenge"])
    {
        NotificationDetailVC * VC1=[self.storyboard instantiateViewControllerWithIdentifier:@"NotificationDetailVC"];
        VC1.str_VideoID=[[arr_notificationns valueForKey:@"video_id"]objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:VC1 animated:YES];
    }
    else if ([[[arr_notificationns valueForKey:@"type_status"]objectAtIndex:indexPath.row] isEqualToString:@"follow"])
    {
        Profile_VC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
        vc1.str_post_id=[[arr_notificationns valueForKey:@"user_id"]objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc1 animated:YES];

    }
    else if ([[[arr_notificationns valueForKey:@"type_status"]objectAtIndex:indexPath.row] isEqualToString:@"group"])
    {
        Profile_VC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
        vc1.str_post_id=[[arr_notificationns valueForKey:@"user_id"]objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
    
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (scrollView==tablevW_notification)
//    {
//        
//        float bottomEdge = tablevW_notification.contentOffset.y + tablevW_notification.frame.size.height;
//        if (bottomEdge >= tablevW_notification.contentSize.height)
//        {
//            [self loadScrollViewWithPage];
//        }
//        
//        
//    }
//}
//- (void)loadScrollViewWithPage
//{
//    page_count=page_count+1;
//    [spinner startAnimating];
//    [self GetLeaderboardData];
//}


-(void)AcceptUSER:(id)sender
{
  //   http://dev414.trigma.us/krust/Webservices/group_accept_decline?group_id=35&user_accept=825&status=0
    
    NSString * str_statusAccept=[NSString stringWithFormat:@"%d",1];
    
    NSString * str_Group_id=[[arr_notificationns valueForKey:@"video_id"]objectAtIndex:[sender tag]];
    
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    if (isStringEmpty(str_Group_id))
    {
        str_Group_id=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"group_id" : str_Group_id,
                                         @"user_accept" : str_userID,
                                         @"status" : str_statusAccept
                                         
                                         }];
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kgroupacceptdecline];

    [[AppManager sharedManager] getDataForUrl:url
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     
     {
         // Get response from server
         
      //   NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
             NSInteger Status=[[responseObject valueForKey:@"status"]integerValue];
             
             if(Status==1)
             {
                 [self GetLeaderboardData];
                 segment.selectedSegmentIndex=0;
                 [tablevW_notification reloadData];
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
         tablevW_notification.hidden=YES;
         View_PoPUP.hidden=NO;
         alert(@"Error", @"Something went wrong.");
         
     }];
    

}

-(void)RejectUSER:(id)sender
{
    
  //   http://dev414.trigma.us/krust/Webservices/group_accept_decline?group_id=35&user_accept=825&status=0
    
    NSString * str_statusAccept=[NSString stringWithFormat:@"%d",0];
    
    NSString * str_Group_id=[[arr_notificationns valueForKey:@"video_id"]objectAtIndex:[sender tag]];
    
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    if (isStringEmpty(str_Group_id))
    {
        str_Group_id=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"group_id" : str_Group_id,
                                         @"user_accept" : str_userID,
                                         @"status" : str_statusAccept
                                         
                                         }];
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kgroupacceptdecline];

    
    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     
     {
         // Get response from server
         
      //   NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
             NSInteger Status=[[responseObject valueForKey:@"status"]integerValue];
             
             if(Status==1)
             {
                 [self GetLeaderboardData];
                 segment.selectedSegmentIndex=0;
                 [tablevW_notification reloadData];
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
         alert(@"Error", @"Something went wrong.");
         
     }];
    
}

-(void)UserProfilePUSH:(id)sender
{
    //    if (![spinner isAnimating])
    //    {
    
//    if ([[[arr_notificationns valueForKey:@"user_id"]objectAtIndex:[sender tag]] isEqualToString:@"780"])
//    {
//        alert(@"Alert", @"This video uploaded by admin");
//    }
//    else
//    {
         Profile_VC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
        vc1.str_post_id=[[arr_notificationns valueForKey:@"user_id"]objectAtIndex:[sender tag]];
        [self.navigationController pushViewController:vc1 animated:YES];
 
//    }
    
    //}
}


- (IBAction)TappedOnBack:(id)sender
{
    isFromSetting=NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
