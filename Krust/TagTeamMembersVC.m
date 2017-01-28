//
//  TagTeamMembersVC.m
//  Krust
//
//  Created by Pankaj Sharma on 08/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import "TagTeamMembersVC.h"
#import "AppManager.h"
#import "tagTeammemberTableViewCell.h"
#import "cameraVC.h"
#import "SelecttteamViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Selectchallenge1ViewController.h"
#import "Haneke.h"

@interface TagTeamMembersVC ()
{
    __block NSString* videoPath;
    
}
@end

@implementation TagTeamMembersVC
@synthesize str_GroupID;
- (void)viewDidLoad
{
    [super viewDidLoad];
    arr_index=[[NSMutableArray alloc]init];
    arr_SelectedFriends=[[NSMutableArray alloc]init];
    dic=[[NSMutableDictionary alloc]init];
    arr_selectedFriendsID=[[NSMutableArray alloc]init];
    arr_friendsids=[[NSMutableArray alloc]init];
    arr_deletedGorupMembers=[[NSMutableArray alloc]init];
    arr_alreadymemberADDed=[[NSMutableArray alloc]init];
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

    //isSelected=NO;
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
    View_popup.hidden=YES;
    arr_selectedFriendsID=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"Dic"]];
    
    arr_SelectedFriends=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    
    //    arr_selectedFriendsID=[[NSUserDefaults standardUserDefaults]valueForKey:@"Dic"];
    
    //    arr_selectedFriendsID=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"Dic"]];
    
    arr_index = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedValueArray"]];
    
    str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    arr_FriendList=[[NSMutableArray alloc]init];
    self.tabBarController.tabBar.hidden=YES;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self WebserviceGetFriendList];
}
-(void)WebserviceGetFriendList
{
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    // http://dev414.trigma.us/krust/Webservices/group_user_list?id=836&group_id=5&show=team
    
    if (isStringEmpty(str_GroupID)) {
        str_GroupID=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"id" : str_userID,
                                         @"group_id" : str_GroupID,
                                         @"show" : @"team"
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kgroupuserlist];

    [[AppManager sharedManager] getDataForUrl:url
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     
     {
         // Get response from server
         
//         NSLog(@"JSON: %@", responseObject);
         
         
         if ([responseObject count]>0)
         {
             
             [[AppManager sharedManager]hideHUD];
             
             
             NSInteger Status=[[[[responseObject objectForKey:@"globle_follow_list"]objectAtIndex:0] valueForKey:@"status"] integerValue];
             
             if(Status == 1)
             {
                 View_popup.hidden=YES;
                 arr_FriendList=[responseObject valueForKey:@"globle_follow_list"];
                 btn_done.hidden=NO;

//                 for (int i=0; i<arr_FriendList.count; i++)
//                 {
//                     NSInteger Status=[[[arr_FriendList objectAtIndex:i]valueForKey:@"group_follow"] integerValue];
//                     
//                     if(Status == 1)
//                     {
//                         [arr_friendsids addObject:[[arr_FriendList valueForKey:@"id"]objectAtIndex:i]];
//                         [arr_index addObject:[NSString stringWithFormat:@"%d",i]];
//                         
//                         [[NSUserDefaults standardUserDefaults] setValue:arr_index forKey:@"SelectedValueArray"];
//                         
//                         dic=[[NSMutableDictionary alloc]init];
//                         
//                         [dic setObject:[[arr_FriendList objectAtIndex:i]valueForKey:@"id"] forKey:@"id"];
//                         [dic setObject:[[arr_FriendList objectAtIndex:i]valueForKey:@"username"] forKey:@"username"];
//                         [dic setObject:[NSString stringWithFormat:@"%ld",(long)i] forKey:@"index"];
//                         
//                         [arr_selectedFriendsID addObject:dic];
//                         
//                         [[NSUserDefaults standardUserDefaults]setValue:arr_selectedFriendsID forKey:@"Dic"];
//                         
//                     }
//                     
//                     NSLog(@"%@",arr_index);
//                     NSLog(@"%@",arr_friendsids);
//                     
//                 }
                 
                 [tableVW_selectFriend reloadData];
                 return;
             }
             
             else if (Status==0)
             {
                 View_popup.hidden=NO;
                 btn_done.hidden=YES;
                //alert(@"Alert", @"There are no friends.");
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
    return [arr_FriendList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tagTeammemberTableViewCell";
    // Similar to UITableViewCell, but
    tagTeammemberTableViewCell *tempcell;
    
    if (tempcell == nil)
    {
        tempcell = (tagTeammemberTableViewCell *)[tableVW_selectFriend dequeueReusableCellWithIdentifier:cellIdentifier];
        // tempcell = [[HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        tempcell = (tagTeammemberTableViewCell *)[nib objectAtIndex:0];
        
        if ([arr_FriendList count]>0)
        {
            
            [tempcell loaditemwithAdvertListArray:[arr_FriendList objectAtIndex:indexPath.row]];
        }
    }
    
    if ([arr_FriendList count]>0)
    {
        tempcell.selectionStyle = UITableViewCellSelectionStyleNone;
        tempcell.selectionStyle=UITableViewCellAccessoryNone;
        
     //   NSLog(@"%@",arr_index);
        
        
        if ([arr_index containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
        {
            [tempcell.btn_selectFriend setImage:[UIImage imageNamed:@"ico-tck-g"] forState:UIControlStateNormal];
        }
        else
        {
            [tempcell.btn_selectFriend setImage:[UIImage imageNamed:@"ico-tck-blk"] forState:UIControlStateNormal];
        }
        
        tempcell.btn_selectFriend.tag=indexPath.row;
        
        [tempcell.btn_selectFriend addTarget:self action:@selector(selectFriend:) forControlEvents:UIControlEventTouchUpInside];
        
        
//        NSInteger Status=[[[arr_FriendList objectAtIndex:indexPath.row]valueForKey:@"group_follow"] integerValue];
//        
//        if(Status ==1)
//        {
//            
//            if (arr_deletedGorupMembers.count>0)
//            {
//                if ([arr_deletedGorupMembers containsObject:[arr_alreadymemberADDed objectAtIndex:indexPath.row]])
//                {
//                    [tempcell.btn_selectFriend setImage:[UIImage imageNamed:@"ico-tck-blk"] forState:UIControlStateNormal];
//                }
//            }
//            else if (!arr_deletedGorupMembers.count>0)
//            {
//            
//            [tempcell.btn_selectFriend setImage:[UIImage imageNamed:@"ico-tck-g"] forState:UIControlStateNormal];
//            
//            [arr_index addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//            [arr_alreadymemberADDed addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//            [[NSUserDefaults standardUserDefaults] setValue:arr_index forKey:@"SelectedValueArray"];
//            
//            dic=[[NSMutableDictionary alloc]init];
//            
//            [dic setObject:[[arr_FriendList objectAtIndex:indexPath.row]valueForKey:@"id"] forKey:@"id"];
//            [dic setObject:[[arr_FriendList objectAtIndex:indexPath.row]valueForKey:@"username"] forKey:@"username"];
//            [dic setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"index"];
//            
//            [arr_selectedFriendsID addObject:dic];
//            
//            [[NSUserDefaults standardUserDefaults]setValue:arr_selectedFriendsID forKey:@"Dic"];
//            
//            NSLog(@"%@",arr_selectedFriendsID);
//            //        _lbl_like.text=@"Unlike";
//                
//            }
//            else
//            {
//                [tempcell.btn_selectFriend setImage:[UIImage imageNamed:@"ico-tck-blk"] forState:UIControlStateNormal];
//                
//                //        _lbl_like.text=@"Like";
//                
//            }
//
//        }
        
    }
   
    

    
    // Just want to test, so I hardcode the data
    return tempcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(IBAction)selectFriend:(id)sender
{
  //  NSLog(@"%@",arr_index);
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    
    tagTeammemberTableViewCell *privateCell =(tagTeammemberTableViewCell*)[tableVW_selectFriend cellForRowAtIndexPath:path];
    
    if ([arr_index containsObject:[NSString stringWithFormat:@"%ld",(long)[sender tag]]])
    {
        [privateCell.btn_selectFriend setImage:[UIImage imageNamed:@"ico-tck-blk"] forState:UIControlStateNormal];
        [arr_index removeObject:[NSString stringWithFormat:@"%ld",(long)[sender tag]]];
//        [arr_deletedGorupMembers addObject:[NSString stringWithFormat:@"%ld",(long)[sender tag]]];
        [[NSUserDefaults standardUserDefaults] setValue:arr_index forKey:@"SelectedValueArray"];
        
//        NSLog(@"before %@",arr_selectedFriendsID);
        
        NSString *PersonID = [[arr_FriendList objectAtIndex:[sender tag]]valueForKey:@"id"];
        
        for (int i=0; i<[arr_selectedFriendsID count]; i++)
        {
            if ([[[arr_selectedFriendsID objectAtIndex:i]valueForKey:@"id"] isEqualToString:PersonID])
            {
                [arr_selectedFriendsID removeObjectAtIndex:i];
            }
            
        }
        
  //      NSLog(@"after %@",arr_selectedFriendsID);
        
        [[NSUserDefaults standardUserDefaults]setValue:arr_selectedFriendsID forKey:@"Dic"];
        
    }
    else
    {
        [arr_index addObject:[NSString stringWithFormat:@"%ld",(long)[sender tag]]];
        
//        [arr_deletedGorupMembers removeObject:[NSString stringWithFormat:@"%ld",(long)[sender tag]]];

        [[NSUserDefaults standardUserDefaults] setValue:arr_index forKey:@"SelectedValueArray"];
        
        [privateCell.btn_selectFriend setImage:[UIImage imageNamed:@"ico-tck-g"] forState:UIControlStateNormal];
        
        dic=[[NSMutableDictionary alloc]init];
        
        [dic setObject:[[arr_FriendList objectAtIndex:[sender tag]]valueForKey:@"id"] forKey:@"id"];
        [dic setObject:[[arr_FriendList objectAtIndex:[sender tag]]valueForKey:@"username"] forKey:@"username"];
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)[sender tag]] forKey:@"index"];
        
        [arr_selectedFriendsID addObject:dic];
        
        [[NSUserDefaults standardUserDefaults]setValue:arr_selectedFriendsID forKey:@"Dic"];
        
       // NSLog(@"%@",arr_selectedFriendsID);
        
    }
    
}
- (IBAction)doneChallenge:(id)sender
{
    
    arr_friendsids=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"Dic"]];
    
    for (int i=0; i<[arr_friendsids count]; i++)
    {
        str_selecteedFriendID = [[arr_friendsids valueForKey:@"id"] componentsJoinedByString:@","];
    }
 //   NSLog(@"%@",arr_friendsids);
    
    //    if (isStringEmpty(str_selecteedFriendID))
    //    {
    //        str_selecteedFriendID=@" ";
    //    }
    
    //    if (isfromTagingFriend==YES)
    //    {
    

    NSArray *items = [str_selecteedFriendID componentsSeparatedByString:@","];
    
    if (items.count==0)
    {
        alert(@"Alert", @"Please tag atleast one team members.");
    }
    else
    {
        
        BOOL checkNet = [[AppManager sharedManager] CheckReachability];
        if(!checkNet == FALSE)
        {
           
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            [actionSheet addButtonWithTitle:@"Library"];
            [actionSheet addButtonWithTitle:@"Camera"];
            actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
            [actionSheet showInView:self.view];
    
//            cameraVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"camera"];
//            vc1.str_groupID=str_GroupID;
//            vc1.str_Teammembers=str_selecteedFriendID;
//            [self.navigationController pushViewController:vc1 animated:YES];
//            
//            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FromTagTeam"];
//            
//            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"Dic"];
//            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"SelectedValueArray"];
//            
//            str_selecteedFriendID=nil;
            
//            [self dismissViewControllerAnimated:YES completion:nil];
           
//    [self WebserviceAddVideo];
            
        }
        
    }
    
    //    }
    //    else
    //    {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
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
            
        }
            break;
            
        case 1:
        {
            
            cameraVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"camera"];
            vc1.str_groupID=str_GroupID;
            vc1.str_Teammembers=str_selecteedFriendID;
            [self.navigationController pushViewController:vc1 animated:YES];
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FromTagTeam"];
            
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"Dic"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"SelectedValueArray"];
            
            str_selecteedFriendID=nil;

            
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
   // NSLog(@"duration: %.2f", seconds);
    
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
       //     NSLog(@"videopath of your mp4 file = %@", videoPath);  // PATH OF YOUR .mp4 FILE
            
            exportSession.outputFileType = AVFileTypeMPEG4;
            
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                
                switch ([exportSession status]) {
                        
                    case AVAssetExportSessionStatusFailed:
                        
                //        NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                        
                        break;
                        
                    case AVAssetExportSessionStatusCancelled:
                        
//                        NSLog(@"Export canceled");
                        
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
                             //   NSLog(@"couldn't generate thumbnail, error:%@", error);
                            }
                            
                            else
                                
                            {
                           //     NSLog(@"%@",im);
                                thumbnailImage=[UIImage imageWithCGImage:im];
                                NSLog(@"--cameraVC-%@",thumbnailImage);
                                
                            }
                        };
                        CGSize maxSize = CGSizeMake(320, 180);
                        generator.maximumSize = maxSize;
                        
                        [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
                        
                        
                        NSData  *plainData = [NSData dataWithContentsOfFile:videoPath];
                        
                    //    NSLog(@"Export completed");
                        
                        str_encripedString =[plainData base64EncodedStringWithOptions:0];
                        
                   //     NSLog(@" encrept data %@", str_encripedString);
                        
                    [self performSelectorOnMainThread:@selector(PushController) withObject:nil waitUntilDone:YES];
                        
                        
                    }
                        break;
                    default:
                        break;
                        
                }
            }];
        }
        
    }

}

-(void)PushController
{
//    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
//    [userInfo setObject:str_encripedString forKey:@"VideoStringcameraOne"];
//    
//    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//    [nc postNotificationName:@"FirstVCPopped" object:self userInfo:userInfo];
//    
//    NSMutableDictionary* userInfo1 = [NSMutableDictionary dictionary];
//    [userInfo1 setValue:thumbnailImage forKey:@"Imagethumbnail"];
//    
//    NSNotificationCenter* nc1 = [NSNotificationCenter defaultCenter];
//    [nc1 postNotificationName:@"ImageVCPopped" object:self userInfo:userInfo1];
    
    Selectchallenge1ViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Selectchallenge1"];
    vc1.imagethumbnailSelect=thumbnailImage;
    vc1.str_encripedString=str_encripedString;
    vc1.str_GroupID=str_GroupID;
    vc1.str_membersIDs=str_selecteedFriendID;
    [self.navigationController pushViewController:vc1 animated:YES];
    
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"Dic"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"SelectedValueArray"];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FromTagTeam"];
    str_selecteedFriendID=nil;

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



-(void)WebserviceAddVideo
{
    
    // http://dev414.trigma.us/krust/Webservices/add_group_user?user_id=12&group_user=1,2&group_id=6
    
    if (isStringEmpty(str_selecteedFriendID)) {
        str_selecteedFriendID=@"";
    }
    if (isStringEmpty(str_userID)) {
        str_userID=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" : str_userID,
                                         @"group_id" : @"",
                                         @"group_user" : str_selecteedFriendID
                                         
                                         
                                         }];
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kaddgroupuser];

    [[AppManager sharedManager] getDataForUrl:url
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     
     {
         // Get response from server
         
      //   NSLog(@"JSON: %@", responseObject);
         
         
         if ([responseObject count]>0)
         {
             
             [[AppManager sharedManager]hideHUD];
             
             NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
             
             if(Status == 1)
             {
                 
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Dic"];
                 
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedValueArray"];
                 
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


- (IBAction)back:(id)sender
{
    //    if (isfromTagingFriend==YES)
    //    {
    //        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedValueArray"];
    //        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Dic"];
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
    //    else
    //    {
    
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"Dic"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"SelectedValueArray"];
    
    [self.navigationController popViewControllerAnimated:YES];
    //    }
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedValueArray"];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Dic"];
}

@end
