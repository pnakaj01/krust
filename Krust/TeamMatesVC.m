//
//  TeamMatesVC.m
//  Krust
//
//  Created by Pankaj Sharma on 06/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import "TeamMatesVC.h"
#import "AppManager.h"
#import "AddTeamMatesTWCell.h"
#import "TeamsVC.h"
#import "Haneke.h"

@interface TeamMatesVC ()

@end

@implementation TeamMatesVC
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
    str_null=@"";
    
    if (isStringEmpty(str_GroupID))
    {
        str_GroupID=@"";
    }

    // http://dev414.trigma.us/krust/Webservices/group_user_list?id=836&group_id=5&show=team
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"id" : str_userID,
                                         @"group_id" : str_GroupID,
                                         @"show" : str_null
                                         
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
             
             btn_done.hidden=NO;

             NSInteger Status=[[[[responseObject objectForKey:@"globle_follow_list"]objectAtIndex:0]valueForKey:@"status"] integerValue];
             
             if(Status == 1)
             {
                 View_popup.hidden=YES;
                 arr_FriendList=[responseObject valueForKey:@"globle_follow_list"];
                 
                 for (int i=0; i<arr_FriendList.count; i++)
                 {
                     NSInteger Status=[[[arr_FriendList objectAtIndex:i]valueForKey:@"group_follow"] integerValue];
                     
                     if(Status == 1)
                     {
                         [arr_friendsids addObject:[[arr_FriendList valueForKey:@"id"]objectAtIndex:i]];
                         [arr_index addObject:[NSString stringWithFormat:@"%d",i]];
                         
                     [[NSUserDefaults standardUserDefaults] setValue:arr_index forKey:@"SelectedValueArray"];
     
                     dic=[[NSMutableDictionary alloc]init];
     
                     [dic setObject:[[arr_FriendList objectAtIndex:i]valueForKey:@"id"] forKey:@"id"];
                     [dic setObject:[[arr_FriendList objectAtIndex:i]valueForKey:@"username"] forKey:@"username"];
                     [dic setObject:[NSString stringWithFormat:@"%ld",(long)i] forKey:@"index"];
     
                     [arr_selectedFriendsID addObject:dic];
                     
                     [[NSUserDefaults standardUserDefaults]setValue:arr_selectedFriendsID forKey:@"Dic"];

                     }
                     
//                     NSLog(@"%@",arr_index);
//                     NSLog(@"%@",arr_friendsids);
                     
                 }
          
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
         View_popup.hidden=NO;
         btn_done.hidden=YES;
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
    
    static NSString *cellIdentifier = @"AddTeamMatesTWCell";
    // Similar to UITableViewCell, but
    AddTeamMatesTWCell *tempcell;
    
    if (tempcell == nil)
    {
        tempcell = (AddTeamMatesTWCell *)[tableVW_selectFriend dequeueReusableCellWithIdentifier:cellIdentifier];
        // tempcell = [[HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        tempcell = (AddTeamMatesTWCell *)[nib objectAtIndex:0];
        
        if ([arr_FriendList count]>0)
        {
            
            [tempcell loaditemwithAdvertListArray:[arr_FriendList objectAtIndex:indexPath.row]];
        }
    }
    if ([arr_FriendList count]>0)
    {
        tempcell.selectionStyle = UITableViewCellSelectionStyleNone;
        tempcell.selectionStyle=UITableViewCellAccessoryNone;
        
//        NSLog(@"%@",arr_index);
        
        if([arr_index containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
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
        
//        if(Status == 1)
//        {
//            
////            if (arr_deletedGorupMembers.count>0)
////            {
////                if ([arr_deletedGorupMembers containsObject:[arr_alreadymemberADDed objectAtIndex:indexPath.row]])
////                {
////                    [tempcell.btn_selectFriend setImage:[UIImage imageNamed:@"ico-tck-blk"] forState:UIControlStateNormal];
////                    
////                }
////            }
//            if (isIndexNil==YES)
//            {
//                
//            }
//            else
//            {
//             if (!arr_index.count>0)
//            {
//                
//                [tempcell.btn_selectFriend setImage:[UIImage imageNamed:@"ico-tck-g"] forState:UIControlStateNormal];
//                
//                [arr_index addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
////                [arr_alreadymemberADDed addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//                [[NSUserDefaults standardUserDefaults] setValue:arr_index forKey:@"SelectedValueArray"];
//                
//                dic=[[NSMutableDictionary alloc]init];
//                
//                [dic setObject:[[arr_FriendList objectAtIndex:indexPath.row]valueForKey:@"id"] forKey:@"id"];
//                [dic setObject:[[arr_FriendList objectAtIndex:indexPath.row]valueForKey:@"username"] forKey:@"username"];
//                [dic setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"index"];
//                
//                [arr_selectedFriendsID addObject:dic];
//                
//                [[NSUserDefaults standardUserDefaults]setValue:arr_selectedFriendsID forKey:@"Dic"];
//                
//                NSLog(@"%@",arr_selectedFriendsID);
//                //        _lbl_like.text=@"Unlike";
//                
//            }
//        }
//        
//        }
//        else
//        {
//                [tempcell.btn_selectFriend setImage:[UIImage imageNamed:@"ico-tck-blk"] forState:UIControlStateNormal];
//            }

        
    }
    
    // Just want to test, so I hardcode the data
    return tempcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(IBAction)selectFriend:(id)sender
{
    NSLog(@"%@",arr_index);
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    
    AddTeamMatesTWCell *privateCell =(AddTeamMatesTWCell*)[tableVW_selectFriend cellForRowAtIndexPath:path];
    
    if ([arr_index containsObject:[NSString stringWithFormat:@"%ld",(long)[sender tag]]])
    {
        [privateCell.btn_selectFriend setImage:[UIImage imageNamed:@"ico-tck-blk"] forState:UIControlStateNormal];
        
        [arr_index removeObject:[NSString stringWithFormat:@"%ld",(long)[sender tag]]];
        
//        [arr_deletedGorupMembers addObject:[NSString stringWithFormat:@"%ld",(long)[sender tag]]];

        [[NSUserDefaults standardUserDefaults] setValue:arr_index forKey:@"SelectedValueArray"];
        
        NSLog(@"before %@",arr_selectedFriendsID);
        
        NSString *PersonID = [[arr_FriendList objectAtIndex:[sender tag]]valueForKey:@"id"];
        
        for (int i=0; i<[arr_selectedFriendsID count]; i++)
        {
            if ([[[arr_selectedFriendsID objectAtIndex:i]valueForKey:@"id"] isEqualToString:PersonID])
            {
                [arr_selectedFriendsID removeObjectAtIndex:i];
            }
            
        }
        
        if (arr_selectedFriendsID.count==0)
        {
            isIndexNil=YES;
        }
        else
        {
            isIndexNil=NO;
 
        }
        
        NSLog(@"after %@",arr_selectedFriendsID);
        
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
        
        NSLog(@"%@",arr_selectedFriendsID);
        
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
    
        if (isStringEmpty(str_selecteedFriendID))
        {
            alert(@"Alert", @"Please add atleast one team member.");
        }
        else
        {
            
            BOOL checkNet = [[AppManager sharedManager] CheckReachability];
            if(!checkNet == FALSE)
            {
                [self WebserviceAddVideo];
            }
            
        }
    
//    }
//    else
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }

}

-(void)WebserviceAddVideo
{
    
  // http://dev414.trigma.us/krust/Webservices/add_group_user?user_id=12&group_user=1,2&group_id=6
    if (isStringEmpty(str_userID)) {
        str_userID=@"";
    }
    if (isStringEmpty(str_GroupID)) {
        str_GroupID=@"";
    }
    if (isStringEmpty(str_selecteedFriendID)) {
        str_selecteedFriendID=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" : str_userID,
                                         @"group_id" : str_GroupID,
                                         @"group_user" : str_selecteedFriendID
                                       
                                         
                                         }];
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kaddgroupuser];

    [[AppManager sharedManager] getDataForUrl:url
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     
     {
         // Get response from server
         
    //     NSLog(@"JSON: %@", responseObject);
         
         
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
         
         alert(@"Error", @"Something went wrong.");
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
    
        [self.navigationController popViewControllerAnimated:YES];
//    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedValueArray"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Dic"];
}

@end
