//
//  LeaderBoardVideosViewController.m
//  Krust
//
//  Created by Pankaj Sharma on 08/09/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "LeaderBoardVideosViewController.h"
#import "LikesVC.h"
#import "commentVC.h"
#import "PrivateChat.h"
#import "Profile VC.h"
#import "Setting VC.h"
#import "AppManager.h"
#import "Profile VC.h"
#import <Social/Social.h>
#import "LeaderBoardVideoCell.h"
#import "Haneke.h"


@interface LeaderBoardVideosViewController ()

@end

@implementation LeaderBoardVideosViewController

@synthesize str_post_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    page_count=1;
    
    
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived:) name:@"TestNotification" object:nil];

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
        BOOL checkNet = [[AppManager sharedManager] CheckReachability];
        if(!checkNet == FALSE)
        {
            table_Post.hidden=NO;
            
            [self GetVideoPostData];
        }
        else
        {
            table_Post.hidden=YES;
            
        }
        
}


-(void)GetVideoPostData
{
    
       // http://dev414.trigma.us/krust/Webservices/videoweeklist?post_id=864&userid=825&page=1
    
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
                                         @"post_id" : str_post_id,
                                         @"userid" : str_USERID,
                                         @"page" : [NSString stringWithFormat:@"%ld",(long)page_count]
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kvideoweeklist];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     
     {
         // Get response from server
         
   //      NSLog(@"JSON: %@", responseObject);
         
         
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
                 [spinner stopAnimating];
                 
                 return;
             }
             
             else if (Status==0)
             {
                 View_popup.hidden=NO;
                 table_Post.hidden=YES;
                 [spinner stopAnimating];
                 [[AppManager sharedManager]hideHUD];
                 
                 return;
             }
         }
         
     }
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [[AppManager sharedManager]hideHUD];
         View_popup.hidden=NO;
         table_Post.hidden=YES;
         [spinner stopAnimating];
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
    
    static NSString *cellIdentifier = @"LeaderBoardVideoCell";
    // Similar to UITableViewCell, but
    LeaderBoardVideoCell *tempcell;
    
    if (tempcell == nil)
    {
        tempcell = (LeaderBoardVideoCell *)[table_Post dequeueReusableCellWithIdentifier:cellIdentifier];
        // tempcell = [[HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        tempcell = (LeaderBoardVideoCell *)[nib objectAtIndex:0];
    //    NSLog(@"%ld",(long)indexPath.row);
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
        
        [tempcell.btn_ShowUserProfile addTarget:self action:@selector(UserProfilePUSH:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [tempcell.btn_comment addTarget:self action:@selector(CommentVCPUSH:) forControlEvents:UIControlEventTouchUpInside];
        
        [tempcell.btn_like addTarget:self action:@selector(LikeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [tempcell.btn_more addTarget:self action:@selector(MoreAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [tempcell.Btn_like_unlike addTarget:self action:@selector(LikeUnlikeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [tempcell.btn_playVideo addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return tempcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
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
        //    [MoviePlayer setFullscreen:YES animated:NO];
        //    MoviePlayer.controlStyle = MPMovieControlStyleFullscreen;
        //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        [Movie_View addSubview:MoviePlayer.view];
        
        //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackComplete:)name:MPMoviePlayerPlaybackDidFinishNotification                                               object:MoviePlayer];
    }
}


/*- (void)playbackFinished:(NSNotification*)notification {
 NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
 switch ([reason intValue]) {
 case MPMovieFinishReasonPlaybackEnded:
 MoviePlayer.controlStyle = MPMovieControlStyleFullscreen;
 [MoviePlayer.view removeFromSuperview];
 Movie_View.hidden=YES;
 MoviePlayer = nil;
 self.tabBarController.tabBar.hidden=NO;
 NSLog(@"playbackFinished. Reason: Playback Ended");
 break;
 case MPMovieFinishReasonPlaybackError:
 MoviePlayer.controlStyle = MPMovieControlStyleFullscreen;
 [MoviePlayer.view removeFromSuperview];
 Movie_View.hidden=YES;
 MoviePlayer = nil;
 self.tabBarController.tabBar.hidden=NO;
 NSLog(@"playbackFinished. Reason: Playback Error");
 break;
 case MPMovieFinishReasonUserExited:
 MoviePlayer.controlStyle = MPMovieControlStyleFullscreen;
 [MoviePlayer.view removeFromSuperview];
 MoviePlayer = nil;
 Movie_View.hidden=YES;
 self.tabBarController.tabBar.hidden=NO;
 NSLog(@"playbackFinished. Reason: User Exited");
 break;
 default:
 break;
 }
 [MoviePlayer setFullscreen:NO animated:YES];
 }*/


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
             
      //       NSLog(@"JSON: %@", responseObject);
             
             if ([responseObject count]>0)
             {
                 [[AppManager sharedManager]hideHUD];
                 
                
                     [self GetVideoPostData];
                 
                 //             NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
                 //
                 //             NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                 //
                 //             [self GetVideoPostData];
                 //
                 //             [table_Post reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
                 
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
                
                NSURL *imageUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arr_PostData objectAtIndex:INDEXTAG]valueForKey:@"video_image"]]];
                NSData* data = [[NSData alloc] initWithContentsOfURL:imageUrl];
                UIImage *photoImage = [UIImage imageWithData:data];
                
                [controller addImage:photoImage];
                [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
                    switch (result) {
                        case SLComposeViewControllerResultCancelled:
                            break;
                        case SLComposeViewControllerResultDone:
                        {
                 //           NSLog(@"Done Post share");
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
    //    if (![spinner isAnimating])
    //    {
    
    PrivateChat * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivateChat"];
    vc1.str_post_id=[[arr_PostData valueForKey:@"id"]objectAtIndex:[sender tag]];
    [self.navigationController pushViewController:vc1 animated:YES];
    //    }
}
-(void)UserProfilePUSH:(id)sender
{
    //    if (![spinner isAnimating])
    //    {
    if ([[[arr_PostData valueForKey:@"user_id"]objectAtIndex:[sender tag]] isEqualToString:@"780"])
    {
        alert(@"Alert", @"This video uploaded by admin");
    }
    else
    {
        Profile_VC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
        vc1.str_post_id=[[arr_PostData valueForKey:@"user_id"]objectAtIndex:[sender tag]];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
    //    }
}
-(void)LikeAction:(id)sender
{
    //    if (![spinner isAnimating])
    //    {
    LikesVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Likes"];
    vc1.str_post_id=[[arr_PostData valueForKey:@"id"]objectAtIndex:[sender tag]];
    [self.navigationController pushViewController:vc1 animated:YES];
    //    }
    
}
- (IBAction)setting:(id)sender
{
    Setting_VC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Setting"];
    [self.navigationController pushViewController:vc1 animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    Movie_View.hidden=YES;
    self.tabBarController.tabBar.hidden=NO;
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    if (scrollView==table_Post)
    {
        
        //    CGFloat pageHeight = CGRectGetHeight(obj_scrollView.frame);
        //    NSUInteger page = floor((obj_scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
        
        float bottomEdge = table_Post.contentOffset.y + table_Post.frame.size.height;
        if (bottomEdge >= table_Post.contentSize.height)
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
        page_count=page_count+1;
        [spinner startAnimating];
        
        arr_PostData=[[NSMutableArray alloc]init];
       
            [self GetVideoPostData];
    }
    else
    {
        alert(@"Alert", @"No more posts.");
    }
    
}

- (IBAction)DoneVideoAction:(id)sender
{
    [MoviePlayer stop];
    Movie_View.hidden=YES;
    self.tabBarController.tabBar.hidden=NO;
    
    
}
- (IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
