//
//  Profile VC.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "Profile VC.h"
#import "commentVC.h"
#import "LikesVC.h"
#import "ProfileCell.h"
#import "AppManager.h"
#import "LikesVC.h"
#import "PrivateChat.h"
#import "AppManager.h"
#import "AsyncImageView.h"
#import <Social/Social.h>
#import "FollowerlistViewController.h"
#import "FollowingListViewController.h"
#import "Haneke.h"

@interface Profile_VC ()

@end

@implementation Profile_VC

@synthesize str_post_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    page_count=1;
    SegmentSelection=2;
    
    NSLog(@"POst ID %@",str_post_id);
    
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
    
    arr_UserData=[[NSMutableArray alloc]init];
    View_popup.hidden=YES;
    user_profileImage.layer.cornerRadius=user_profileImage.frame.size.height/2;
    user_profileImage.clipsToBounds = YES;
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0, 0, 320, 44);
    tableVW_profile.tableFooterView = spinner;

    [AppManager sharedManager].navCon = self.navigationController;
    str_USERID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    Movie_View.hidden=YES;
    arr_PostData=[[NSMutableArray alloc]init];
    self.tabBarController.tabBar.hidden=YES;
    
    [btn_solo setBackgroundImage:[UIImage imageNamed:@"Solo-active"] forState:UIControlStateNormal];
    [btn_challenge setBackgroundImage:[UIImage imageNamed:@"Challenges"] forState:UIControlStateNormal];

     if(isStringEmpty(str_post_id))
    {
        str_post_id=@"";
    }
    
    if ([str_post_id isEqualToString:str_USERID])
    {
        btn_follow.hidden=YES;
    }
    else
    {
        btn_follow.hidden=NO;

    }

}
-(void)viewDidAppear:(BOOL)animated
{

    [self WebServiceShowProfileData];
    
    if (SegmentSelection==2)
    {
        
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];

    if(!checkNet == FALSE)
    {
        [self WebServiceShowProfileData];
        tableVW_profile.hidden=NO;
        [self GetVideoPostData];
    }
    else
    {
        
         tableVW_profile.hidden=YES;
    }
    }
    else if (SegmentSelection==0)
    {
        BOOL checkNet = [[AppManager sharedManager] CheckReachability];
        if(!checkNet == FALSE)
        {
                tableVW_profile.hidden=NO;
            
                [btn_solo setBackgroundImage:[UIImage imageNamed:@"Solo-active"] forState:UIControlStateNormal];
                [btn_challenge setBackgroundImage:[UIImage imageNamed:@"Challenges"] forState:UIControlStateNormal];
                [self GetVideoPostData];
        }
        
            else
            {
                tableVW_profile.hidden=YES;
            }

        
    }
    else if (SegmentSelection==1)
    {
        
        BOOL checkNet = [[AppManager sharedManager] CheckReachability];
        if(!checkNet == FALSE)
        {
            tableVW_profile.hidden=NO;

            [btn_challenge setBackgroundImage:[UIImage imageNamed:@"Challenges-active"] forState:UIControlStateNormal];
            [btn_solo setBackgroundImage:[UIImage imageNamed:@"Solo"] forState:UIControlStateNormal];
            [self getChallengeVideo];
        }
        
        else
        {
            tableVW_profile.hidden=YES;
        }

    }
}

-(void)WebServiceShowProfileData
{

//http://dev414.trigma.us/krust/Webservices/profile?user_id=781
    
//NSString *str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    if (isStringEmpty(str_post_id))
    {
        str_post_id=@"";
    }
    if (isStringEmpty(str_USERID))
    {
        str_USERID=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" :str_post_id,
                                         @"check_profile" : str_USERID
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    //[appdelRef showProgress:@"Please wait.."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kprofile];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
        success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
//         NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
             NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
             
             if(Status ==1)
             {
                 arr_UserData=responseObject;
                 lbl_username.text=[responseObject valueForKey:@"username"];
                 lbl_followers.text=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"Followers"]];
                 lbl_following.text=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"Following"]];
                 lbl_post.text=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"post"]];
                 user_profileImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"profile_image"]]];
                 
                 
                
                 
                 NSInteger Status=[[responseObject valueForKey:@"check_profile_follow"] integerValue];
                 
                 if(Status == 1)
                 {
                     [btn_follow setImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];

                 }
                 else
                 {
                     [btn_follow setImage:[UIImage imageNamed:@"btn-follow"] forState:UIControlStateNormal];

                 }
                 
                 if ([[responseObject valueForKey:@"id"]isEqualToString:str_USERID])
                 {
                     btn_follow.hidden=YES;
                 }
                 
                 return;
                 
             }
             else if (Status==0)
             {
                 alert(@"Alert", @"User does not exist");
                 return;
                 
             }
         }
         
         else
         {
             alert(@"Alert", @"Something went wrong");
             
             [[AppManager sharedManager]hideHUD];
             
         }
         
     }
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Error", @"Something went wrong.");
         
     }];
    
    
}

- (IBAction)SegmentAction:(id)sender
{
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
        tableVW_profile.hidden=NO;

    if ([sender tag]==0)
    {
        [btn_solo setBackgroundImage:[UIImage imageNamed:@"Solo-active"] forState:UIControlStateNormal];
        [btn_challenge setBackgroundImage:[UIImage imageNamed:@"Challenges"] forState:UIControlStateNormal];
        [self GetVideoPostData];
        

    }
    else
    {
        [btn_challenge setBackgroundImage:[UIImage imageNamed:@"Challenges-active"] forState:UIControlStateNormal];
        [btn_solo setBackgroundImage:[UIImage imageNamed:@"Solo"] forState:UIControlStateNormal];
        [self getChallengeVideo];


    }
    }
    else
    {
        tableVW_profile.hidden=YES;
    }
    
}

-(void)GetVideoPostData
{
    // http://dev414.trigma.us/krust/Webservices/video_solo?user_id=785&page=1
    
    
//        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
//                                           
//                                           @{
//                                             
//                                             @"user_id" : str_post_id,
//                                             @"page" : [NSString stringWithFormat:@"%ld",(long)page_count]
//                                             
//                                             }];
//        
////    if (isFromScrollPage==TRUE)
////    {
////        isFromScrollPage=FALSE;
////    }
////    else
////    {
//        [[AppManager sharedManager] showHUD:@"Loading..."];
////    }
//    
//        [[AppManager sharedManager] getDataForUrl:@"http://dev414.trigma.us/krust/Webservices/user_accept_challenge?"
    
    if (isStringEmpty(str_post_id))
    {
        str_post_id=@"";
    }
    if (isStringEmpty(str_USERID))
    {
        str_USERID=@"";
    }
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         @"user_id" : str_USERID,
                                         @"check_profile":[NSString stringWithFormat:@"%@",str_post_id ] ,
                                         @"page" : [NSString stringWithFormat:@"%ld",(long)page_count]
                        
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kvideoadmin];

    [[AppManager sharedManager] getDataForUrl:url

                                       parameters:parameters
         
    success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
         
         {
             // Get response from server
             
//             NSLog(@"JSON: %@", responseObject);
             
             
             if ([responseObject count]>0)
             {
                 [[AppManager sharedManager]hideHUD];
                 SegmentSelection=0;
                 
                 NSInteger Status=[[[[responseObject valueForKey:@"post"]objectAtIndex:0]valueForKey:@"status"] integerValue];
                 
                 Numberofpages=[[[[responseObject valueForKey:@"post"]objectAtIndex:0]valueForKey:@"countdata"] integerValue];

                 [spinner stopAnimating];

                 if(Status == 1)
                 {
                     arr_PostData=[responseObject valueForKey:@"post"];
                     View_popup.hidden=YES;
                     tableVW_profile.hidden=NO;
                     [tableVW_profile reloadData];
                     
                     return;
                 }
                 else if (Status==0)
                 {
                     
//                   alert(@"Alert", @"No Post.");
                     tableVW_profile.hidden=YES;
                     View_popup.hidden=NO;
                     [[AppManager sharedManager]hideHUD];
                     return;
                     
                 }
             }
             
         }
         
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
         
         {
             [[AppManager sharedManager]hideHUD];
             
             alert(@"Alert", @"Something went wrong.");
             
         }];
        
}
-(void)getChallengeVideo
{
//  http://dev414.trigma.us/krust/Webservices/video?user_id=785&page=1&challenge=admin
   // http://dev414.trigma.us/krust/Webservices/user_accept_challenge?user_id=880&page=1
    
    if (isStringEmpty(str_post_id))
    {
        str_post_id=@"";
    }

    if (isStringEmpty(str_USERID))
    {
        str_USERID=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" : str_post_id,
                                         @"login_user" : str_USERID,
                                         @"page" : [NSString stringWithFormat:@"%ld",(long)page_count]
                                     

                                         }];
    
    
    
//    if (isFromScrollPage==TRUE)
//    {
//        isFromScrollPage=FALSE;
//    }
//    else
//    {
        [[AppManager sharedManager] showHUD:@"Loading..."];
//    }
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kvideosolo];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     
     {
         // Get response from server
         
//         NSLog(@"JSON: %@", responseObject);
         
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
             NSInteger Status=[[[[responseObject valueForKey:@"post"]objectAtIndex:0]valueForKey:@"status"] integerValue];
             
             Numberofpages=[[[[responseObject valueForKey:@"post"]objectAtIndex:0]valueForKey:@"countdata"] integerValue];
             [spinner stopAnimating];

             
             if(Status == 1)
             {

                 SegmentSelection=1;
                 View_popup.hidden=YES;
                 tableVW_profile.hidden=NO;
                 arr_PostData=[responseObject valueForKey:@"post"];
                 [tableVW_profile reloadData];
                 return;
             }
             else if (Status==0)
             {
                 
//                 alert(@"Alert", @"No Post.");
                 tableVW_profile.hidden=YES;
                 View_popup.hidden=NO;
                 [[AppManager sharedManager]hideHUD];
                 return;
                 
                 
             }
         }
         
     }
     
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Alert", @"Something went wrong.");
         
     }];
    

}

#pragma mark --TableView Delegate--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [arr_PostData count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 380;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"ProfileCell";
    // Similar to UITableViewCell, but
    ProfileCell *tempcell;
    
    if (tempcell == nil)
    {
        tempcell = (ProfileCell *)[tableVW_profile dequeueReusableCellWithIdentifier:cellIdentifier];
        // tempcell = [[HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        tempcell = (ProfileCell *)[nib objectAtIndex:0];
//        NSLog(@"%ld",(long)indexPath.row);
        if ([arr_PostData count]>0) {
            
            [tempcell loaditemwithAdvertListArray:[arr_PostData objectAtIndex:indexPath.row]];
        }
    }
    if ([arr_PostData count]>0)
    {
        tempcell.selectionStyle = UITableViewCellSelectionStyleNone;
        tempcell.selectionStyle=UITableViewCellAccessoryNone;
        
        tempcell.btn_comment.tag=indexPath.row;
        tempcell.btn_like.tag=indexPath.row;
        tempcell.btn_more.tag=indexPath.row;
        tempcell.Btn_like_unlike.tag=indexPath.row;
        tempcell.btn_playVideo.tag=indexPath.row;
        tempcell.btn_UserProfilePush.tag=indexPath.row;
        tempcell.btn_DeleteVideo.tag=indexPath.row;


        [tempcell.btn_UserProfilePush addTarget:self action:@selector(UserProfile:) forControlEvents:UIControlEventTouchUpInside];

        
        [tempcell.btn_comment addTarget:self action:@selector(CommentVCPUSH:) forControlEvents:UIControlEventTouchUpInside];
        
        [tempcell.btn_like addTarget:self action:@selector(LikeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [tempcell.btn_more addTarget:self action:@selector(MoreAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [tempcell.Btn_like_unlike addTarget:self action:@selector(LikeUnlikeAction:) forControlEvents:UIControlEventTouchUpInside];

        [tempcell.btn_playVideo addTarget:self action:@selector(playvideo:) forControlEvents:UIControlEventTouchUpInside];
        
        tempcell.btn_DeleteVideo.hidden=YES;

        if ([[[arr_PostData valueForKey:@"user_id"] objectAtIndex:indexPath.row] isEqualToString:str_USERID])
        {
            
            tempcell.btn_DeleteVideo.hidden=NO;
            [tempcell.btn_DeleteVideo addTarget:self action:@selector(TappedOnDeleteVideo:) forControlEvents:UIControlEventTouchUpInside];
        }

        
        
    }
    
    return tempcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
-(void)UserProfile:(id)sender
{
    str_post_id=[[arr_PostData valueForKey:@"user_id"]objectAtIndex:[sender tag]];

    [self WebServiceShowProfileData];
    
}
-(void)playvideo:(id)sender
{
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arr_PostData valueForKey:@"video_name"] objectAtIndex:[sender tag]]]];
    MoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];;
    
    if (IS_IPHONE_5)
    {
        MoviePlayer.view.frame = CGRectMake(0,64,320,504);
    }
    else if (IS_IPHONE_6)
    {
        MoviePlayer.view.frame = CGRectMake(0,64,375,603);
        
    }
    else if (IS_IPHONE_6_PLUS)
    {
        MoviePlayer.view.frame = CGRectMake(0,64,414,672);
        
    }
    self.tabBarController.tabBar.hidden=YES;
    
    Movie_View.hidden=NO;
    [MoviePlayer play];
    [Movie_View addSubview:MoviePlayer.view];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackComplete:)name:MPMoviePlayerPlaybackDidFinishNotification                                               object:MoviePlayer];
    }
    
}
- (void)moviePlaybackComplete:(NSNotification *)notification
{
    [MoviePlayer.view removeFromSuperview];
    Movie_View.hidden=YES;
    self.tabBarController.tabBar.hidden=NO;
    
}
-(void)LikeUnlikeAction:(id)sender
{
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {

    //http://dev414.trigma.us/krust/Webservices/video_like?user_id=785&video_id=786&like_status=1
    
    NSInteger Status=[[[arr_PostData valueForKey:@"islike"] objectAtIndex:[sender tag]] integerValue];
    if(Status ==1)
    {
        like_status=@"0";
    }
    else
    {
        like_status=@"1";
    }
    
    
    str_POSTID=[[arr_PostData valueForKey:@"id"]objectAtIndex:[sender tag]];
        
        if (isStringEmpty(str_POSTID))
        {
            str_POSTID=@"";
        }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         @"user_id" : str_USERID,
                                         @"video_id" : str_POSTID,
                                         @"like_status" : like_status
                                         
                                         }];
    
    //    [[AppManager sharedManager] showHUD:@"Loading..."];
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kvideolike];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     
     {
         // Get response from server
         
//         NSLog(@"JSON: %@", responseObject);
         
         
         NSInteger Status = [[responseObject valueForKey:@"status"] integerValue];
         
         [[AppManager sharedManager]hideHUD];

         
         if ([responseObject count]>0)
         {
             
             
             if (Status == 1)
             {
                 if (SegmentSelection==2)
                 {
                     
                     BOOL checkNet = [[AppManager sharedManager] CheckReachability];
                     
                     if(!checkNet == FALSE)
                     {
                         [self WebServiceShowProfileData];
                         tableVW_profile.hidden=NO;
                         [self GetVideoPostData];
                     }
                     else
                     {
                         
                         tableVW_profile.hidden=YES;
                     }
                 }
                 else if (SegmentSelection==0)
                 {
                     BOOL checkNet = [[AppManager sharedManager] CheckReachability];
                     if(!checkNet == FALSE)
                     {
                         tableVW_profile.hidden=NO;
                         
                         [btn_solo setBackgroundImage:[UIImage imageNamed:@"Solo-active"] forState:UIControlStateNormal];
                         [btn_challenge setBackgroundImage:[UIImage imageNamed:@"Challenges"] forState:UIControlStateNormal];
                         [self GetVideoPostData];
                     }
                     
                     else
                     {
                         tableVW_profile.hidden=YES;
                     }
                     
                     
                 }
                 else if (SegmentSelection==1)
                 {
                     
                     BOOL checkNet = [[AppManager sharedManager] CheckReachability];
                     if(!checkNet == FALSE)
                     {
                         tableVW_profile.hidden=NO;
                         
                         [btn_challenge setBackgroundImage:[UIImage imageNamed:@"Challenges-active"] forState:UIControlStateNormal];
                         [btn_solo setBackgroundImage:[UIImage imageNamed:@"Solo"] forState:UIControlStateNormal];
                         [self getChallengeVideo];
                     }
                     
                     else
                     {
                         tableVW_profile.hidden=YES;
                     }
                     
                 }
                 
                 //             NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
                 //
                 //             NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                 //
                 //             [self GetVideoPostData];
                 //
                 //             [table_Post reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
                 
                 return;

             }
             else if (Status == 0)
                 
             {
//                 NSLog(@"Status Apear 0");
             }
             
             
         }
         
         else
         {
             
             alert(@"Alert", @"No action perform.");
             [[AppManager sharedManager]hideHUD];
             
         }
         
     }
     
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Error", @"error");
         
     }];
        
    }
    
}



-(void)TappedOnDeleteVideo:(id)sender
{
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
        
     //  http://dev414.trigma.us/krust/Webservices/video_delete?user_id=841&video_id=365
        
        
        str_POSTID=[[arr_PostData valueForKey:@"id"]objectAtIndex:[sender tag]];
        
        if (isStringEmpty(str_POSTID))
        {
            str_POSTID=@"";
        }
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                           
                                           @{
                                             @"user_id" : str_USERID,
                                             @"video_id" : str_POSTID,
                                             
                                             }];
        
        //    [[AppManager sharedManager] showHUD:@"Loading..."];
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kvideodelete];

        [[AppManager sharedManager] getDataForUrl:url
         
                                       parameters:parameters
         
                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
         
         {
             // Get response from server
//             NSLog(@"JSON: %@", responseObject);

             NSInteger Status = [[responseObject valueForKey:@"status"] integerValue];
             
             if ([responseObject count]>0)
             {
                 
                 [[AppManager sharedManager]hideHUD];
                 
                 if (Status == 1)
                 {
                     if (SegmentSelection==2)
                     {
                         
                         BOOL checkNet = [[AppManager sharedManager] CheckReachability];
                         
                         if(!checkNet == FALSE)
                         {
                             [self WebServiceShowProfileData];
                             tableVW_profile.hidden=NO;
                             [self GetVideoPostData];
                         }
                         else
                         {
                             
                             tableVW_profile.hidden=YES;
                         }
                     }
                     else if (SegmentSelection==0)
                     {
                         BOOL checkNet = [[AppManager sharedManager] CheckReachability];
                         if(!checkNet == FALSE)
                         {
                             tableVW_profile.hidden=NO;
                             
                             [btn_solo setBackgroundImage:[UIImage imageNamed:@"Solo-active"] forState:UIControlStateNormal];
                             [btn_challenge setBackgroundImage:[UIImage imageNamed:@"Challenges"] forState:UIControlStateNormal];
                             [self GetVideoPostData];
                         }
                         
                         else
                         {
                             tableVW_profile.hidden=YES;
                         }
                         
                         
                     }
                     else if (SegmentSelection==1)
                     {
                         
                         BOOL checkNet = [[AppManager sharedManager] CheckReachability];
                         if(!checkNet == FALSE)
                         {
                             tableVW_profile.hidden=NO;
                             
                             [btn_challenge setBackgroundImage:[UIImage imageNamed:@"Challenges-active"] forState:UIControlStateNormal];
                             [btn_solo setBackgroundImage:[UIImage imageNamed:@"Solo"] forState:UIControlStateNormal];
                             [self getChallengeVideo];
                         }
                         
                         else
                         {
                             tableVW_profile.hidden=YES;
                         }
                         
                     }

                 }
                 
                 else if (Status == 0)
                     
                 {
//                     NSLog(@"Satus Appear 0");
                 }

                 return;
                 
             }
             
             else
             {
                 
                 alert(@"Alert", @"No action perform.");
                 [[AppManager sharedManager]hideHUD];
                 
             }
             
         }
         
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
         
         {
             [[AppManager sharedManager]hideHUD];
             
             alert(@"Error", @"error");
             
         }];
        
    }
    
}


-(void)MoreAction:(id)sender
{
    INDEXTAG=[sender tag];
    
    UIActionSheet *obj_ActionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Share on Facebook", nil), nil];
    [obj_ActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                
                
                
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                [controller setInitialText:[NSString stringWithFormat:@"%@ \n\n %@",[[arr_PostData valueForKey:@"challenge_name"]objectAtIndex:INDEXTAG],[[arr_PostData valueForKey:@"description"]objectAtIndex:INDEXTAG]]];
                
                
                //                [controller addURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arr_PostData objectAtIndex:INDEXTAG]valueForKey:@"description"]]]];
                
//                [controller addURL:[NSURL URLWithString:@"https://vimeo.com/106920303"]];
                
                [controller addURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arr_PostData valueForKey:@"video_name"] objectAtIndex:INDEXTAG]]]];

                //                [controller presentViewController:controller animated:YES completion:Nil];
                
                
                //                NSURL *imageUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arr_PostData objectAtIndex:INDEXTAG]valueForKey:@"video_image"]]];
                //                NSData* data = [[NSData alloc] initWithContentsOfURL:imageUrl];
                //                UIImage *photoImage = [UIImage imageWithData:data];
                //
                //                [controller addImage:photoImage];
                [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
                    switch (result) {
                        case SLComposeViewControllerResultCancelled:
                            break;
                        case SLComposeViewControllerResultDone:
                        {
//                            NSLog(@"Done Post share");
                        }
                            break;
                        default:
                            break;
                    }
                }];
                [self dismissViewControllerAnimated:YES completion:nil];
                [self presentViewController:controller animated:YES completion:Nil];
            }
            else
            {
                //                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK"                                                          otherButtonTitles: nil];
                alert(@"Message", @"Post not share on facebook");
                
                //                [myAlertView show];
            }
        }
            
            break;
        default:
            break;
    }
}


-(void)CommentVCPUSH:(id)sender
{
    PrivateChat * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivateChat"];
    vc1.str_post_id=[[arr_PostData valueForKey:@"id"]objectAtIndex:[sender tag]];
    [self.navigationController pushViewController:vc1 animated:YES];
}

-(void)LikeAction:(id)sender
{
    LikesVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Likes"];
    vc1.str_post_id=[[arr_PostData valueForKey:@"id"]objectAtIndex:[sender tag]];
    [self.navigationController pushViewController:vc1 animated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    Movie_View.hidden=YES;
    self.tabBarController.tabBar.hidden=NO;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)DoneVideoAction:(id)sender
{
    [MoviePlayer stop];
    Movie_View.hidden=YES;
    self.tabBarController.tabBar.hidden=NO;
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    if (scrollView==tableVW_profile)
    {
        
        //    CGFloat pageHeight = CGRectGetHeight(obj_scrollView.frame);
        //    NSUInteger page = floor((obj_scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
        
        float bottomEdge = tableVW_profile.contentOffset.y + tableVW_profile.frame.size.height;
        if (bottomEdge >= tableVW_profile.contentSize.height)
        {
            [self loadScrollViewWithPage];
            // we are at the end
        }
        // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
        
        
    }
    // a possible optimization would be to unload the views+controllers which are no longer visible
}
- (void)loadScrollViewWithPage
{
    if (page_count <= Numberofpages)
    {
        isFromScrollPage=TRUE;
        
        page_count=page_count+1;
        [spinner startAnimating];
        
        arr_PostData=[[NSMutableArray alloc]init];
   
        if (SegmentSelection==2)
        {
            
            BOOL checkNet = [[AppManager sharedManager] CheckReachability];
            
            if(!checkNet == FALSE)
            {
                [self WebServiceShowProfileData];
                tableVW_profile.hidden=NO;
                [self GetVideoPostData];
            }
            else
            {
                
                tableVW_profile.hidden=YES;
            }
        }
        else if (SegmentSelection==0)
        {
            BOOL checkNet = [[AppManager sharedManager] CheckReachability];
            if(!checkNet == FALSE)
            {
                tableVW_profile.hidden=NO;
                
                [btn_solo setBackgroundImage:[UIImage imageNamed:@"Solo-active"] forState:UIControlStateNormal];
                [btn_challenge setBackgroundImage:[UIImage imageNamed:@"Challenges"] forState:UIControlStateNormal];
                [self GetVideoPostData];
            }
            
            else
            {
                tableVW_profile.hidden=YES;
            }
            
            
        }
        else if (SegmentSelection==1)
        {
            
            BOOL checkNet = [[AppManager sharedManager] CheckReachability];
            if(!checkNet == FALSE)
            {
                tableVW_profile.hidden=NO;
                
                [btn_challenge setBackgroundImage:[UIImage imageNamed:@"Challenges-active"] forState:UIControlStateNormal];
                [btn_solo setBackgroundImage:[UIImage imageNamed:@"Solo"] forState:UIControlStateNormal];
                [self getChallengeVideo];
            }
            
            else
            {
                tableVW_profile.hidden=YES;
            }
            
        }
    
    }
    else
    {
        alert(@"Alert", @"No more posts.");
    }
    
}
- (IBAction)TappedOnFollow:(id)sender
{
 //   http://dev414.trigma.us/krust/Webservices/follow_user?user_id=785&follow_id=786&status=1
    
    str_USERID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    btn_follow.userInteractionEnabled=NO;

    if (isStringEmpty(str_USERID))
    {
        str_USERID=@"";
    }
    if (isStringEmpty(ProfileId))
    {
        ProfileId=@"";
    }
    if (isStringEmpty(FollowStatus))
    {
        FollowStatus=@"";
    }
    
    ProfileId=[arr_UserData valueForKey:@"id"];
    
    NSInteger Status=[[arr_UserData valueForKey:@"check_profile_follow"] integerValue];
    
    if(Status == 0)
    {
        FollowStatus=@"1";
    }
    else
    {
        FollowStatus=@"0";
    }

        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                           
                                           @{
                                             @"user_id" : str_USERID,
                                             @"follow_id" : ProfileId,
                                             @"status" : FollowStatus
                                             
                                             }];
    
        //        [[AppManager sharedManager] showHUD:@"Loading..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kfollowuser];

        [[AppManager sharedManager] getDataForUrl:url
         
                                       parameters:parameters
         
                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
         
         {
             // Get response from server
             
         //    NSLog(@"JSON: %@", responseObject);
             
             
             if ([responseObject count]>0)
             {
                 btn_follow.userInteractionEnabled=YES;
                 
                 [[AppManager sharedManager]hideHUD];
                 
                 NSInteger Status=[[responseObject valueForKey:@"status"]integerValue];
                 
                 if(Status == 1)
                 {
                     [self WebServiceShowProfileData];
                     
//                     alert(@"alert", @"user follow");

                     return;
                 }
                 else if (Status==0)
                 {
                     
                     [self WebServiceShowProfileData];

//                     alert(@"alert", @"user unfollow");
                     
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
- (IBAction)TappedOnFolloers:(id)sender
{
    FollowerlistViewController *VC1=[self.storyboard instantiateViewControllerWithIdentifier:@"FollowerlistViewController"];
    VC1.str_post_id=str_post_id;
    [self.navigationController pushViewController:VC1 animated:YES];
}
- (IBAction)TappedOnFollowings:(id)sender
{
    FollowingListViewController *VC1=[self.storyboard instantiateViewControllerWithIdentifier:@"FollowingListViewController"];
    VC1.str_post_id=str_post_id;
    [self.navigationController pushViewController:VC1 animated:YES];

}




@end
