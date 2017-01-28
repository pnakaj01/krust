//
//  LeaderBoardVC.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "LeaderBoardVC.h"
#import "LeaderBoradTableViewCell.h"
#import "AppManager.h"
#import "LeaderBoardVideosViewController.h"
#import "Profile VC.h"
#import "Haneke.h"

@interface LeaderBoardVC ()

@end

@implementation LeaderBoardVC

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
    [AppManager sharedManager].navCon = self.navigationController;

//    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//    [nc postNotificationName:@"Pushcontroller" object:self userInfo:nil];
    
    view_popup.hidden=YES;
    Movie_View.hidden=YES;
    str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    arr_Leaderboarddata=[[NSMutableArray alloc]init];
    self.tabBarController.tabBar.hidden=NO;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
        tableVW_leaderBoard.hidden=NO;

    [self GetLeaderboardData];
    }
    else
    {
        tableVW_leaderBoard.hidden=YES;
    }
    
}

- (IBAction)segmentAction:(id)sender
{
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
    tableVW_leaderBoard.hidden=NO;
    [self GetLeaderboardData];
    }
    else
    {
    tableVW_leaderBoard.hidden=YES;
    }
    
}

-(void)GetLeaderboardData
{
//    http://dev414.trigma.us/krust/Webservices/globle_follow_list?id=782
    
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    
    if (segment.selectedSegmentIndex==0)
    {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                           
                                           @{
                                             
                                             @"id" : str_userID
                                             
                                             }];
        
        
        [[AppManager sharedManager] showHUD:@"Loading..."];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kgloblefollowlist];
 
        [[AppManager sharedManager] getDataForUrl:url
         
                                       parameters:parameters
         
                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
         
         {
             // Get response from server
             
      //       NSLog(@"JSON: %@", responseObject);
             
             
             if ([responseObject count]>0)
             {
                 [[AppManager sharedManager]hideHUD];
                 
                 
                 NSInteger Status=[[[[responseObject valueForKey:@"globle_follow_list"]objectAtIndex:0]valueForKey:@"status"] integerValue];
                 
                 if(Status == 1)
                 {
                     view_popup.hidden=YES;
                     arr_Leaderboarddata=[responseObject valueForKey:@"globle_follow_list"];
                     tableVW_leaderBoard.hidden=NO;
                     [tableVW_leaderBoard reloadData];
                     
                     return;
                 }
                 else if (Status==0)
                 {
                     
//                     alert(@"Alert", @"No user.");
                     lbl_popupMessage.text=@"No user";
                     tableVW_leaderBoard.hidden=YES;
                     view_popup.hidden=NO;
                     [[AppManager sharedManager]hideHUD];
                     return;
                     
                     
                 }
             }
             
         }
         
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
         
         {
             [[AppManager sharedManager]hideHUD];
             lbl_popupMessage.text=@"No user";
             tableVW_leaderBoard.hidden=YES;
             view_popup.hidden=NO;
             alert(@"Alert", @"Something went wrong.");
             
         }];
        
    }
    
    else
    {
        segment.selectedSegmentIndex=1;
        
        if (isStringEmpty(str_userID)) {
            str_userID=@"";
        }
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                           
                                           @{
                                             
                                             @"id" : str_userID
                                             
                                             }];
        
        [[AppManager sharedManager] showHUD:@"Loading..."];
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kselectfriendlist];

        [[AppManager sharedManager] getDataForUrl:url
         
                                       parameters:parameters
         
        success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
         
         {
             // Get response from server
             
       //      NSLog(@"JSON: %@", responseObject);
             
             
             if ([responseObject count]>0)
             {
                 [[AppManager sharedManager]hideHUD];
                 
                 NSInteger Status=[[[[responseObject valueForKey:@"select_friend_list"]objectAtIndex:0]valueForKey:@"status"] integerValue];
                 
                 if(Status == 1)
                 {
                     view_popup.hidden=YES;
                     tableVW_leaderBoard.hidden=NO;
                     arr_Leaderboarddata=[responseObject valueForKey:@"select_friend_list"];
                     [tableVW_leaderBoard reloadData];
                     return;
                 }
                 else if (Status==0)
                 {
//                     alert(@"Alert", @"No Followed Friend.");
                     lbl_popupMessage.text=@"No Followed Friend";
                     view_popup.hidden=NO;
                     tableVW_leaderBoard.hidden=YES;
                     [[AppManager sharedManager]hideHUD];
                     return;
                     
                 }
             }
             
         }
         
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
         
         {
             [[AppManager sharedManager]hideHUD];
             view_popup.hidden=NO;
             tableVW_leaderBoard.hidden=YES;
             [[AppManager sharedManager]hideHUD];
             alert(@"Error", @"something went wrong");
             
         }];
        
    }
    
}

-(void)playVideo:(id)sender
{
}


- (IBAction)DoneVideoAction:(id)sender
{
    [MoviePlayer stop];
    Movie_View.hidden=YES;
    self.tabBarController.tabBar.hidden=NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    Movie_View.hidden=YES;
    self.tabBarController.tabBar.hidden=NO;
}

#pragma mark --TableView Delegate--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr_Leaderboarddata count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    static NSString *cellIdentifier = @"LeaderBoradTableViewCell";
//    // Similar to UITableViewCell, but
//    LeaderBoradTableViewCell *tempcell = (LeaderBoradTableViewCell *)[tableVW_leaderBoard dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    if (tempcell == nil)
//    {
//        tempcell = [[LeaderBoradTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
//        tempcell = (LeaderBoradTableViewCell *)[nib objectAtIndex:0];
//        
//        tempcell.selectionStyle = UITableViewCellSelectionStyleNone;
//        tempcell.selectionStyle=UITableViewCellAccessoryNone;
//        
//        [tempcell loaditemwithAdvertListArray:[arr_Leaderboarddata objectAtIndex:indexPath.row]];
//        
//        tempcell.btn_follow.tag=indexPath.row;
//        [tempcell.btn_follow addTarget:self action:@selector(FollowAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
    
    
    static NSString *cellIdentifier = @"LeaderBoradTableViewCell";
    // Similar to UITableViewCell, but
    LeaderBoradTableViewCell *tempcell;
    
    if (tempcell == nil)
    {
        tempcell = (LeaderBoradTableViewCell *)[tableVW_leaderBoard dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        tempcell = (LeaderBoradTableViewCell *)[nib objectAtIndex:0];
        if ([arr_Leaderboarddata count]>0)
        {
            
            [tempcell loaditemwithAdvertListArray:[arr_Leaderboarddata objectAtIndex:indexPath.row]];
            
        }
    }
    
    if ([arr_Leaderboarddata count]>0)
    {
        tempcell.selectionStyle = UITableViewCellSelectionStyleNone;
        tempcell.selectionStyle=UITableViewCellAccessoryNone;
        
        tempcell.btn_follow.tag=indexPath.row;
        tempcell.btn_UserProfile.tag=indexPath.row;
        
        [tempcell.btn_follow addTarget:self action:@selector(FollowAction:) forControlEvents:UIControlEventTouchUpInside];
        [tempcell.btn_UserProfile addTarget:self action:@selector(PushUSERPROFILE:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    // Just want to test, so I hardcode the data
    return tempcell;
}
-(void)PushUSERPROFILE:(id)sender
{
    Profile_VC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    vc1.str_post_id=[[arr_Leaderboarddata valueForKey:@"id"]objectAtIndex:[sender tag]];
    [self.navigationController pushViewController:vc1 animated:YES];

}
-(void)FollowAction:(id)sender
{
    //http://dev414.trigma.us/krust/Webservices/follow_user?user_id=785&follow_id=786
    
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    
    LeaderBoradTableViewCell *privateCell =(LeaderBoradTableViewCell*)[tableVW_leaderBoard cellForRowAtIndexPath:path];
    
    privateCell.btn_follow.userInteractionEnabled=NO;
    privateCell.userInteractionEnabled=NO;
    
    str_followfriendID=[[arr_Leaderboarddata valueForKey:@"id"]objectAtIndex:[sender tag]];


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
                
        
        NSInteger Status=[[[arr_Leaderboarddata valueForKey:@"follow"] objectAtIndex:[sender tag]] integerValue];
        
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
                 [[AppManager sharedManager]hideHUD];
                 
                 privateCell.btn_follow.userInteractionEnabled=YES;
                 privateCell.userInteractionEnabled=YES;

                 NSInteger Status=[[responseObject valueForKey:@"status"]integerValue];
                 
                 if(Status == 1)
                 {
                     [self GetLeaderboardData];
                     
                     return;
                 }
                 else if (Status==0)
                 {
                     [self GetLeaderboardData];
                     
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaderBoardVideosViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"LeaderBoardVideosViewController"];
    vc1.str_post_id=[[arr_Leaderboarddata valueForKey:@"id"]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc1 animated:YES];
    
//    NSString *str_VideoUrl=[NSString stringWithFormat:@"%@",[[arr_Leaderboarddata valueForKey:@"video_url"] objectAtIndex:indexPath.row]];
//    
//    if ([str_VideoUrl isEqualToString:@"no data"])
//    {
//        alert(@"Alert", @"There is no video.");
//    }
//   else
//   {
//    
//    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
//    if(!checkNet == FALSE)
//    {
//        NSURL *url = [NSURL URLWithString:str_VideoUrl];
//
//        MoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];;
//        
//        if (IS_IPHONE_5)
//        {
//            MoviePlayer.view.frame = CGRectMake(0,64,320,504);
//        }
//        else if (IS_IPHONE_6)
//        {
//            MoviePlayer.view.frame = CGRectMake(0,64,375,603);
//            
//        }
//        else if (IS_IPHONE_6_PLUS)
//        {
//            MoviePlayer.view.frame = CGRectMake(0,64,414,672);
//            
//        }
//        self.tabBarController.tabBar.hidden=YES;
//        
//        Movie_View.hidden=NO;
//        [MoviePlayer play];
//        //    [MoviePlayer setFullscreen:YES animated:NO];
//        //    MoviePlayer.controlStyle = MPMovieControlStyleFullscreen;
//        //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//        [Movie_View addSubview:MoviePlayer.view];
//        
//        //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackComplete:)name:MPMoviePlayerPlaybackDidFinishNotification                                               object:MoviePlayer];
//    }
//
//   }
    
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
