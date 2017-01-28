//
//  NotificationDetailVC.m
//  Krust
//
//  Created by Pankaj Sharma on 22/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import "NotificationDetailVC.h"
#import "VideoDetailTableViewCell.h"
#import "LikesVC.h"
#import "commentVC.h"
#import "PrivateChat.h"
#import "Profile VC.h"
#import "Setting VC.h"
#import "AppManager.h"
#import "Profile VC.h"
#import <Social/Social.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "notificationVC.h"
#import "Haneke.h"


@interface NotificationDetailVC ()

@end

@implementation NotificationDetailVC
@synthesize  str_VideoID;

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    Statusofnotification=[[[[notification object] valueForKey:@"data"]valueForKey:@"status"] integerValue];
    
    [self.tabBarController setSelectedIndex:3];
    
    //    notificationVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"notification"];
    //    vc1.StatusNotification=Statusofnotification;
    //    [self.navigationController pushViewController:vc1 animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"Pushcontroller" object:self userInfo:nil];
    
    View_popup.hidden=YES;
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0, 0, 320, 44);
    table_Post.tableFooterView = spinner;
    
    [AppManager sharedManager].navCon = self.navigationController;
    
    str_USERID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    Movie_View.hidden=YES;
    arr_PostData=[[NSMutableArray alloc]init];
    self.tabBarController.tabBar.hidden=YES;
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [self GetVideoPostData];
}

-(void)GetVideoPostData
{
    
    //http://dev414.trigma.us/krust/Webservices/notification_news?user_id=785&page=1
    
    if (isStringEmpty(str_VideoID))
    {
        str_VideoID=@"";
    }
    
    
    segment.selectedSegmentIndex=0;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"id" : str_VideoID,
                                         @"user_id" : str_USERID
                                         
                                         }];
    
    //    if (![spinner isAnimating])
    //    {
    [[AppManager sharedManager] showHUD:@"Loading..."];
    //    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kvideoshow];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     
     {
         // Get response from server
         
      //   NSLog(@"JSON: %@", responseObject);
         
         
         if ([responseObject count]>0)
         {
             
             [[AppManager sharedManager]hideHUD];
             
             
             NSInteger Status=[[[[responseObject valueForKey:@"post"]objectAtIndex:0]valueForKey:@"status"] integerValue];
             
             Numberofpages=[[[[responseObject valueForKey:@"post"]objectAtIndex:0]valueForKey:@"countdata"] integerValue];
             
             if(Status == 1)
             {
                 
                 arr_PostData=[responseObject valueForKey:@"post"];
                 View_popup.hidden=YES;
                 table_Post.hidden=NO;
                 [table_Post reloadData];
                 
                 return;
             }
             
             else if (Status==0)
             {
                 //        alert(@"Alert", @"No Post.");
                 View_popup.hidden=NO;
                 table_Post.hidden=YES;
                 [[AppManager sharedManager]hideHUD];
                 
                 return;
             }
         }
         
     }
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [[AppManager sharedManager]hideHUD];
         [spinner stopAnimating];
         View_popup.hidden=NO;
         table_Post.hidden=YES;
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
    
    static NSString *cellIdentifier = @"VideoDetailTableViewCell";
    // Similar to UITableViewCell, but
    VideoDetailTableViewCell *tempcell;
    
    if (tempcell == nil)
    {
        tempcell = (VideoDetailTableViewCell *)[table_Post dequeueReusableCellWithIdentifier:cellIdentifier];
        // tempcell = [[HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        tempcell = (VideoDetailTableViewCell *)[nib objectAtIndex:0];
     //   NSLog(@"%ld",(long)indexPath.row);
        if ([arr_PostData count]>0)
        {
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
        tempcell.btn_ShowUserProfile.tag=indexPath.row;
        tempcell.btn_DeletVideo.tag=indexPath.row;
        
        [tempcell.btn_ShowUserProfile addTarget:self action:@selector(UserProfilePUSH:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [tempcell.btn_comment addTarget:self action:@selector(CommentVCPUSH:) forControlEvents:UIControlEventTouchUpInside];
        
        [tempcell.btn_like addTarget:self action:@selector(LikeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [tempcell.btn_more addTarget:self action:@selector(MoreAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [tempcell.Btn_like_unlike addTarget:self action:@selector(LikeUnlikeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [tempcell.btn_playVideo addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        tempcell.btn_DeletVideo.hidden=YES;
        
        if ([[[arr_PostData valueForKey:@"user_id"] objectAtIndex:indexPath.row] isEqualToString:str_USERID])
        {
            
            tempcell.btn_DeletVideo.hidden=NO;
            [tempcell.btn_DeletVideo addTarget:self action:@selector(TappedOnDeleteVideo:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    return tempcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(void)TappedOnDeleteVideo:(id)sender
{
    
    //  http://dev414.trigma.us/krust/Webservices/video_delete?user_id=841&video_id=365
    
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
        
        str_POSTID=[[arr_PostData valueForKey:@"id"]objectAtIndex:[sender tag]];
        
        
        if (isStringEmpty(str_POSTID))
        {
            str_POSTID=@"";
        }
        
        if (isStringEmpty(str_USERID))
        {
            str_USERID=@"";
        }
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                           
                                           @{
                                             @"user_id" : str_USERID,
                                             @"video_id" : str_POSTID
                                             
                                             }];
        
        //    [[AppManager sharedManager] showHUD:@"Loading..."];
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kvideodelete];

        [[AppManager sharedManager] getDataForUrl:url
         
                                       parameters:parameters
         
                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
         
         {
             // Get response from server
             
       //      NSLog(@"JSON: %@", responseObject);
             
             NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
             
             [[AppManager sharedManager]hideHUD];
             
             if ([responseObject count]>0)
             {
                 if (Status ==1)
                 {
                         [self GetVideoPostData];
                 }
                 
                 else if (Status == 0)
                 {
              //       NSLog(@"Satus Appears 0");
                     
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
             alert(@"Alert", @"Something went wrong.");
             
         }];
        
    }
    
    
}

-(void)playVideo:(id)sender
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
    //    if (![spinner isAnimating]) {
    
    //http://dev414.trigma.us/krust/Webservices/video_like?user_id=785&video_id=786&like_status=1
    
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
        
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
        
        if (isStringEmpty(str_USERID))
        {
            str_USERID=@"";
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
             
         //    NSLog(@"JSON: %@", responseObject);
             
             NSInteger Status = [[responseObject valueForKey:@"status"] integerValue];
             [[AppManager sharedManager]hideHUD];
             
             if ([responseObject count]>0)
             {
                 if (Status == 1)
                 {
                     
                         [self GetVideoPostData];
                     
                 }
                 else if (Status == 0)
                     
                 {
                     
      //               NSLog(@"Satus Appears 0");
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
             alert(@"Alert", @"Something went wrong.");
             
         }];
        
    }
    
    
    //  }
}
-(void)MoreAction:(id)sender
{
    INDEXTAG=[sender tag];
    
    UIActionSheet *obj_ActionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Share on Facebook", nil), nil];
    [obj_ActionSheet showInView:self.view];
    
    //or whichever you don't need
    
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
                       //     NSLog(@"Done Post share");
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
-(void)UserProfilePUSH:(id)sender
{
     Profile_VC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    vc1.str_post_id=[[arr_PostData valueForKey:@"user_id"]objectAtIndex:[sender tag]];
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
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
- (IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)DoneVideoAction:(id)sender
{
    [MoviePlayer stop];
    Movie_View.hidden=YES;
    self.tabBarController.tabBar.hidden=NO;
}


@end
