//
//  Selectchallenge1ViewController.m
//  Krust
//
//  Created by Pankaj Sharma on 24/08/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "Selectchallenge1ViewController.h"
//#import "ChallengeListCell.h"
#import "AppManager.h"
#import "cameraVC.h"
#import "SelectchallengeTableViewCell.h"
#import "TagTeamMembersVC.h"
#import "SelecttteamViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Haneke.h"

@interface Selectchallenge1ViewController ()
{
    __block NSString* videoPath;

}
@end


@implementation Selectchallenge1ViewController

@synthesize imagethumbnailSelect,str_encripedString,str_GroupID,str_membersIDs;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
  //  NSLog(@"thimnailImagePush %@",imagethumbnailSelect);
    
    
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

  //  NSLog(@"%@%@",str_membersIDs,str_GroupID);

    timerFlasg=TRUE;
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

-(void)viewWillAppear:(BOOL)animated
{
    
    [AppManager sharedManager].navCon = self.navigationController;
    
    btn_cancel.layer.cornerRadius=5.0f;
    btn_cancel.clipsToBounds=YES;
    
    btn_postasindiviual.layer.cornerRadius=5.0f;
    btn_postasindiviual.clipsToBounds=YES;
    
    btn_postasteam.layer.cornerRadius=5.0f;
    btn_postasteam.clipsToBounds=YES;
    
    backgroundimageVW_buttons.layer.cornerRadius=5.0f;
    backgroundimageVW_buttons.clipsToBounds=YES;
    
    PopupSelectTeam.hidden=YES;
    
    view_PopUp.hidden=YES;

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(ClearData:)
//                                                 name:@"Pushcontroller"
//                                               object:nil];
//    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(imagedata:)
//                                                 name:@"ImageVCPopped"
//                                               object:nil];

    
    self.tabBarController.tabBar.hidden=NO;

    txtVW_Details.placeholder = @"Description";
    txtVW_Details.font=[UIFont fontWithName:@"System" size:18.0];
    txtVW_Details.placeholderColor = [UIColor  lightGrayColor];

    //    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    spinner.frame = CGRectMake(0, 0, 320, 44);
    //    _tableVW_challenges.tableFooterView = spinner;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(recvData:)
//                                                 name:@"FirstVCPopped"
//                                               object:nil];

    arr_PostData=[[NSMutableArray alloc]init];
    str_USERID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
     
    
}
//- (void) ClearData:(NSNotification *) notification
//{
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"IndexSelectedstring"];
//}
//
//- (void) recvData:(NSNotification *) notification
//{
//    NSDictionary* userInfo = notification.userInfo;
//    str_encripedString = [userInfo objectForKey:@"VideoStringcameraOne"];
//    
//}
//- (void) imagedata:(NSNotification *) notification
//{
//    NSDictionary* userInfo = notification.userInfo;
//    imagethumbnailSelect = [userInfo valueForKey:@"Imagethumbnail"];
//    NSLog(@"%@",imagethumbnailSelect);
//    
//}

- (IBAction)TappedONDone:(id)sender
{
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FromTagTeam"]==YES)
//    {
//        str_encripedString=str_videoString;
//    }

    
    if (isStringEmpty(str_encripedString))
    {
        alert(@"Message", @"Please record the video first.");

    }
    else if (isStringEmpty([NSString stringWithFormat:@"%@",txtVW_Details.text]))
    {
        txtVW_Details.text=nil;
        alert(@"Message", @"Please enter description.");
        [txtVW_Details becomeFirstResponder];
    }
    else
    {
        BOOL checkNet = [[AppManager sharedManager] CheckReachability];
        if(!checkNet == FALSE)
        {
            [txtVW_Details resignFirstResponder];
            
            [self WebservicePostVideo];
        }
    }
}
-(void)WebservicePostVideo
{
    
  //  http://dev414.trigma.us/krust/Webservices/videoupload?user_id=782&Video_name=abc.mp4&description=abc&challenge_name=abc&challenge_to=1,2&post_valid=2015-08-07&custom_id=134
    
    http://dev414.trigma.us/krust/Webservices/videoupload?user_id=782&Video_name=abc.mp4&description=abc&challenge_name=abc&challenge_to=1,2&post_valid=2015-08-07&custom_id=134&upload_by=team&team_id=6
    
    if (isStringEmpty(str_membersIDs))
    {
        str_IsPostedAsGroup=@"user";
        str_membersIDs=@"";
    }
    else
    {
        str_IsPostedAsGroup=@"team";
    }
    
    if (isStringEmpty(str_membersIDs))
    {
        str_membersIDs=@"";
    }
    
    if (isStringEmpty(str_encripedString))
    {
        str_encripedString=@"";
    }
    
    PostID=[[NSUserDefaults standardUserDefaults]objectForKey:@"PostID"];
    
    if (isStringEmpty(PostID))
    {
        PostID=@"";
    }
    if (isStringEmpty(str_GroupID))
    {
        str_GroupID=@"";
    }
    if (isStringEmpty(str_GroupID))
    {
        str_GroupID=@"";
    }

    NSString *str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" :str_userID,
                                         @"Video_name" :str_encripedString,
                                         @"description" :txtVW_Details.text,
                                         @"challenge_to" : str_membersIDs,
                                         @"challenge_name" : @"",
                                         @"custom_id" : PostID,
                                         @"post_valid" : @"",
                                         @"team_id" : str_GroupID,
                                         @"upload_by" : str_IsPostedAsGroup,
                                         
                                         
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
//        [self.navigationController popViewControllerAnimated:YES];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"IndexSelectedstring"];
                     [_tableVW_challenges reloadData];

                     [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FromTagTeam"];
                     
                     str_encripedString=nil;
                     imagethumbnailSelect=nil;
                     txtVW_Details.text=nil;
                     str_encripedString=nil;
                     str_GroupID=nil;
                     str_IsPostedAsGroup=nil;
                     str_membersIDs=nil;
                     
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
             alert(@"Alert", @"Something went wrong.");
             [[AppManager sharedManager] hideHUD];
         }
         
     }
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Alert", @"Something went wrong.");
         
     }];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtVW_Details resignFirstResponder];
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

/*-(void)GetTimeData
{
    hour=[[NSString stringWithFormat:@"%@",[[arr_PostData valueForKey:@"hours"] objectAtIndex:0]] intValue];
    
    minit=[[NSString stringWithFormat:@"%@",[[arr_PostData valueForKey:@"minutes"] objectAtIndex:0]] intValue];
    
    sec=[[NSString stringWithFormat:@"%@",@"0"] intValue];
    
    
    if (hour==0 && minit==0 && sec==0)
    {
        lbl_days.text=@"00";
        lbl_hours.text=@"00";
        lbl_minitus.text=@"00";
        
    }
    
    CountDowntimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TimerFired) userInfo:nil repeats:YES];
    
}*/

-(void)viewDidAppear:(BOOL)animated
{
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FromTagTeam"]==YES)
//    {
//        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FromTagTeam"];
//        
//        cameraVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"camera"];
////        strr_PostID=[[arr_PostData valueForKey:@"id"]objectAtIndex:Indexfoarray];
////        [[NSUserDefaults standardUserDefaults]setObject:strr_PostID forKey:@"PostID"];
//        [self.navigationController pushViewController:vc1 animated:YES];
//
//    }
//    else
//    {
    
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
    [self GetVideoPostData];
    }
//    }
}
-(void)GetVideoPostData
{
    
    //http://dev414.trigma.us/krust/Webservices/video?user_id=785&page=1&challenge=admin
    
    if (isStringEmpty(str_USERID))
    {
        str_USERID=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" : str_USERID,
                                         @"challenge" : @"admin",
                                         @"page" : @""
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kvideo];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     {
         // Get response from server
         
    //     NSLog(@"JSON: %@", responseObject);
         
         
         if ([responseObject count]>0)
         {
             [spinner stopAnimating];
             
             [[AppManager sharedManager]hideHUD];
             
             NSInteger Status=[[[[responseObject valueForKey:@"post"]objectAtIndex:0]valueForKey:@"status"] integerValue];
             
             if(Status == 1)
             {
                 
                 arr_PostData=[responseObject valueForKey:@"post"];
                 
                 if (arr_PostData.count>0)
                 {
                     view_PopUp.hidden=YES;
         //            NSLog(@"%@",imagethumbnailSelect);
                     [_tableVW_challenges reloadData];
                     _tableVW_challenges.hidden=NO;
                   //  [self GetTimeData];
                 }
                 
                 return;
             }
             
             else if (Status==0)
             {
//                 alert(@"Alert", @"No Post.");
                 view_PopUp.hidden=NO;
                 _tableVW_challenges.hidden=YES;
                 [[AppManager sharedManager]hideHUD];
                 return;
             }
         }
         
     }
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [[AppManager sharedManager]hideHUD];
         view_PopUp.hidden=NO;
         _tableVW_challenges.hidden=YES;
         alert(@"Alert", @"Something went wrong.");
         
     }];
    
    
}

/*-(void)TimerFired
{
    
    lbl_days.text=[NSString stringWithFormat:@"%@",[[arr_PostData valueForKey:@"days"] objectAtIndex:0]];
    
    if(hour>0 || minit >0 || sec>0)
    {
        if (sec==0)
        {
            
            if (minit==0 && sec==0)
            {
                if (minit==0 && hour==0)
                {
                    sec=60;
                    timerFlasg=FALSE;
                }
                
                if(hour==0 && minit==0 && sec==0)
                {
                    [CountDowntimer invalidate];
                    timerFlasg=FALSE;
                    
                }
            }
            
            if (timerFlasg==TRUE && minit==0 && sec==0)
            {
                hour=hour-1;
                minit=60;
                sec=60;
            }
            else
            {
                sec=60;
            }
            
            minit=minit-1;
            
        }
        
        if(sec>0)
        {
            sec=sec-1;
        }
        //        lbl_days.text=[NSString stringWithFormat:@"%d",hour];
        lbl_hours.text=[NSString stringWithFormat:@"%d",hour];
        lbl_minitus.text=[NSString stringWithFormat:@"%d",minit];
        
    }
    else
    {
        lbl_days.text=@"00";
        [CountDowntimer invalidate];
    }
    
}*/
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --TableView Delegate--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr_PostData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellIdentifier = @"SelectchallengeTableViewCell";
    // Similar to UITableViewCell, but
    SelectchallengeTableViewCell *tempcell;
    
    if (tempcell == nil)
    {
        tempcell = (SelectchallengeTableViewCell *)[_tableVW_challenges dequeueReusableCellWithIdentifier:cellIdentifier];
        // tempcell = [[HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        tempcell = (SelectchallengeTableViewCell *)[nib objectAtIndex:0];
        
        if ([arr_PostData count]>0)
        {
            
            [tempcell loaditemwithAdvertListArray:[arr_PostData objectAtIndex:indexPath.row]];
        }
    }
    if ([arr_PostData count]>0)
    {
        tempcell.selectionStyle = UITableViewCellSelectionStyleNone;
        tempcell.selectionStyle=UITableViewCellAccessoryNone;
        
        if (indexPath.row%2==0)
        {
            
            tempcell.imageVW_side.image=[UIImage imageNamed:@"strip-orng"];
        }
        else
        {
            tempcell.imageVW_side.image=[UIImage imageNamed:@"strip-grey"];
            
        }
//        tempcell.btn_SelectChallenge.tag=indexPath.row;
        
//        [tempcell.btn_SelectChallenge addTarget:self action:@selector(CahllengeSelect:) forControlEvents:UIControlEventTouchUpInside];
        
//        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FromTagTeam"]==YES)
//        {
//            imagethumbnailSelect=thimnailImagePush;
//        }
        
        IndexValue=[[NSUserDefaults standardUserDefaults]valueForKey:@"IndexSelectedstring"];
        
        if ([IndexValue isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
        {
            if (imagethumbnailSelect!=nil)
            {
        
        tempcell.imaeVW_thumbnailSelect.image=imagethumbnailSelect;
        tempcell.lbl_challengeDescriptionSelect.frame=CGRectMake(tempcell.imaeVW_thumbnailSelect.frame.size.width+20,38,tempcell.lbl_challengeNameSelect.frame.size.width-tempcell.imaeVW_thumbnailSelect.frame.size.width,22);
        tempcell.lbl_challengeNameSelect.frame=CGRectMake(tempcell.imaeVW_thumbnailSelect.frame.size.width+20,5,tempcell.lbl_challengeNameSelect.frame.size.width-tempcell.imaeVW_thumbnailSelect.frame.size.width,28);

            }
//        [tempcell.btn_SelectChallenge setBackgroundImage:[UIImage imageNamed:@"btn-radio"] forState:UIControlStateNormal];
        }
        else
        {
//            [tempcell.btn_SelectChallenge setBackgroundImage:[UIImage imageNamed:@"btn-radio-blnk"] forState:UIControlStateNormal];
            tempcell.imaeVW_thumbnailSelect.image=nil;

        }
        
    }
    
    return tempcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PopupSelectTeam.hidden=NO;

//    if ([[[arr_PostData valueForKey:@""] objectAtIndex:indexPath.row] isEqualToString:@""])
//    {
//        OnlyIndiviualChallenge=YES;
//
//    }

    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"IndexSelectedstring"];
    
   // [_tableVW_challenges reloadData];
    
    indexradioselected=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    [[NSUserDefaults standardUserDefaults]setInteger:Indexfoarray forKey:@"IndexSelected"];
    [[NSUserDefaults standardUserDefaults]setObject:indexradioselected forKey:@"IndexSelectedstring"];
    
    strr_PostID=[[arr_PostData valueForKey:@"id"]objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:strr_PostID forKey:@"PostID"];
    
//    [self performSelector:@selector(Pushtocamera) withObject:nil afterDelay:0.1];
    
}

-(void)CahllengeSelect:(id)sender
{
//    imagethumbnail=nil;
//    
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"IndexSelectedstring"];
//    
//    [_tableVW_challenges reloadData];
//    
//    NSIndexPath *path = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
//    
//    ChallengeListCell *privateCell =(ChallengeListCell*)[_tableVW_challenges cellForRowAtIndexPath:path];
//
//    [privateCell.btn_SelectChallenge setBackgroundImage:[UIImage imageNamed:@"btn-radio"] forState:UIControlStateNormal];
//        
//    Indexfoarray=[sender tag];
//    indexradioselected=[NSString stringWithFormat:@"%ld",(long)[sender tag]];
//    
//    [[NSUserDefaults standardUserDefaults]setInteger:Indexfoarray forKey:@"IndexSelected"];
//    [[NSUserDefaults standardUserDefaults]setObject:indexradioselected forKey:@"IndexSelectedstring"];
//
//    [self performSelector:@selector(Pushtocamera) withObject:nil afterDelay:0.1];
    
}
-(void)Pushtocamera
{
    cameraVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"camera"];
    strr_PostID=[[arr_PostData valueForKey:@"id"]objectAtIndex:Indexfoarray];
    [[NSUserDefaults standardUserDefaults]setObject:strr_PostID forKey:@"PostID"];
    [self.navigationController pushViewController:vc1 animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [CountDowntimer invalidate];
    lbl_days.text=nil;
    lbl_hours.text=nil;
    lbl_minitus.text=nil;
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FromTagTeam"];

}

- (IBAction)TappedOnPostasindiviual:(id)sender
{
    PopupSelectTeam.hidden=YES;

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"Library"];
    [actionSheet addButtonWithTitle:@"Camera"];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet showInView:self.view];

}
- (IBAction)TappedOnpostasTeam:(id)sender
{

//    NSString * storyboardName = @"Main";
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"TagTeamMembersVC"];
//    [self presentViewController:vc animated:YES completion:nil];
    
    PopupSelectTeam.hidden=YES;

    SelecttteamViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"SelecttteamViewController"];
    //strr_PostID=[[arr_PostData valueForKey:@"id"]objectAtIndex:Indexfoarray];
   // [[NSUserDefaults standardUserDefaults]setObject:strr_PostID forKey:@"PostID"];
    [self.navigationController pushViewController:vc1 animated:YES];
    imagethumbnailSelect=nil;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FromTagTeam"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FromCustumChallenge"];

    

}
- (IBAction)TappedOnCancel:(id)sender
{
    PopupSelectTeam.hidden=YES;
}


#pragma mark - UIActionSheet Delegate -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex)
    {
        case 0:
        {
            
            UIImagePickerController *ip=[[UIImagePickerController alloc] init];
            ip.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            ip.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
            ip.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
            ip.delegate=self;
            [self presentViewController:ip animated:YES completion:nil];
            isFromLibary=YES;

        }
            break;
            
        case 1:
        {
            
                 cameraVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"camera"];
                //    strr_PostID=[[arr_PostData valueForKey:@"id"]objectAtIndex:Indexfoarray];
                //    [[NSUserDefaults standardUserDefaults]setObject:strr_PostID forKey:@"PostID"];
                imagethumbnailSelect=nil;
                [self.navigationController pushViewController:vc1 animated:YES];
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FromTagTeam"];
            
        }
            break;
            
        case 2:{
            
            
            
        }
            break;

        default:
            break;
    }
}


#pragma imagePickerDelegats

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    
    AVAsset *movie = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
    CMTime movieLength = movie.duration;
    float seconds = CMTimeGetSeconds(movieLength);
 //   NSLog(@"duration: %.2f", seconds);
    
    if (seconds > 10.0 || seconds < 5.0)
    {
        alert(@"Alert!", @"Video length must be less than 10 Seconds or more then 5 Seconds.");
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    else
    {
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[info objectForKey:UIImagePickerControllerMediaURL] options:nil];
        
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
        
        if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality])
        {
            
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
            
            exportSession.shouldOptimizeForNetworkUse = YES;
            
            videoPath = [documentDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", [NSDate date]]];
            
            exportSession.outputURL = [NSURL fileURLWithPath:videoPath];
     //       NSLog(@"videopath of your mp4 file = %@", videoPath);  // PATH OF YOUR .mp4 FILE
            
            exportSession.outputFileType = AVFileTypeMPEG4;
            
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                
                switch ([exportSession status]) {
                        
                    case AVAssetExportSessionStatusFailed:
                        
// NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                        
                        break;
                        
                    case AVAssetExportSessionStatusCancelled:
                        
                   //     NSLog(@"Export canceled");
                        
                        break;
                        
                    case AVAssetExportSessionStatusCompleted:{
                        
                        // If you wanna remove file...do this stuff
                        //[[NSFileManager defaultManager]removeItemAtPath:videoPath error:nil];
                        
                        [picker dismissViewControllerAnimated:YES completion:nil];
                        
                        AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
                        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                        generator.appliesPreferredTrackTransform=TRUE;
                        
                        CMTime thumbTime = CMTimeMakeWithSeconds(1,30);
                        
                        AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error)
                        {
                            if (result != AVAssetImageGeneratorSucceeded)
                            {
                      //          NSLog(@"couldn't generate thumbnail, error:%@", error);
                            }
                            
                            else
                                
                            {
                            //    NSLog(@"%@",im);
                                imagethumbnailSelect=[UIImage imageWithCGImage:im];
                           //     NSLog(@"--cameraVC-%@",imagethumbnailSelect);
                                
                            }
                        };
                        CGSize maxSize = CGSizeMake(320, 180);
                        generator.maximumSize = maxSize;
                        
                        [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
                        
                        
             NSData  *plainData = [NSData dataWithContentsOfFile:videoPath];
                        
          //   NSLog(@"Export completed");
                        
            str_encripedString =[plainData base64EncodedStringWithOptions:0];
                        
         //   NSLog(@" encrept data %@", str_encripedString);
                        
                        
                    }
                        break;
                    default:
                        break;
                        
                }
            }];
        }
        
    }
    
    [_tableVW_challenges reloadData];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    if (error)
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                           message:[error localizedDescription]
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    }

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    if (isFromLibary==YES)
    {
        isFromLibary=NO;
      //  NSLog(@"isFromLibary------->>>>>>>");
    }
    else
    {
    imagethumbnailSelect=nil;
    str_encripedString=nil;
    }
}



@end
