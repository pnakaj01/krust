//
//  SelectFriendVC.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "SelectFriendVC.h"
#import "SelectfriendsCell.h"
#import "ChangleVC.h"
#import "AppManager.h"
#import "Haneke.h"

@interface SelectFriendVC ()

@end

@implementation SelectFriendVC

@synthesize isfromTagingFriend,str_postID;

- (void)viewDidLoad
{
    [super viewDidLoad];
    arr_index=[[NSMutableArray alloc]init];
    arr_SelectedFriends=[[NSMutableArray alloc]init];
    dic=[[NSMutableDictionary alloc]init];
    arr_selectedFriendsID=[[NSMutableArray alloc]init];
    arr_friendsids=[[NSMutableArray alloc]init];
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
    // http://dev414.trigma.us/krust/Webservices/select_friend_list?id=785
    
    
    
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
         
      //   NSLog(@"JSON: %@", responseObject);
         
         
         if ([responseObject count]>0)
         {
             
             [[AppManager sharedManager]hideHUD];
             
             
             NSInteger Status=[[[[responseObject valueForKey:@"select_friend_list"]objectAtIndex:0]valueForKey:@"status"] integerValue];
             
             if(Status == 1)
             {
                 View_popup.hidden=YES;
                 arr_FriendList=[responseObject valueForKey:@"select_friend_list"];
                 [tableVW_selectFriend reloadData];
                 return;
             }
             
             else if (Status==0)
             {
                 View_popup.hidden=NO;
//                 alert(@"Alert", @"There are no friends.");
                 [[AppManager sharedManager]hideHUD];
                 return;
             }
         }
         
     }
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [[AppManager sharedManager]hideHUD];
         View_popup.hidden=NO;

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
    
    static NSString *cellIdentifier = @"SelectfriendsCell";
    // Similar to UITableViewCell, but
    SelectfriendsCell *tempcell;
    
    if (tempcell == nil)
    {
        tempcell = (SelectfriendsCell *)[tableVW_selectFriend dequeueReusableCellWithIdentifier:cellIdentifier];
        // tempcell = [[HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        tempcell = (SelectfriendsCell *)[nib objectAtIndex:0];
        
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
        
    }
    
    // Just want to test, so I hardcode the data
    return tempcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(IBAction)selectFriend:(id)sender
{

//    NSLog(@"%@",arr_index);
    
        NSIndexPath *path = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    
        SelectfriendsCell *privateCell =(SelectfriendsCell*)[tableVW_selectFriend cellForRowAtIndexPath:path];

    if ([arr_index containsObject:[NSString stringWithFormat:@"%ld",(long)[sender tag]]])
    {
        [privateCell.btn_selectFriend setImage:[UIImage imageNamed:@"ico-tck-blk"] forState:UIControlStateNormal];
        [arr_index removeObject:[NSString stringWithFormat:@"%ld",(long)[sender tag]]];
        [[NSUserDefaults standardUserDefaults] setValue:arr_index forKey:@"SelectedValueArray"];
        
    //    NSLog(@"before %@",arr_selectedFriendsID);
        
        NSString *PersonID = [[arr_FriendList objectAtIndex:[sender tag]]valueForKey:@"id"];
        
        for (int i=0; i<[arr_selectedFriendsID count]; i++)
        {
            if ([[[arr_selectedFriendsID objectAtIndex:i]valueForKey:@"id"] isEqualToString:PersonID])
            {
                 [arr_selectedFriendsID removeObjectAtIndex:i];
            }
            
        }
        
//        NSLog(@"after %@",arr_selectedFriendsID);
        
        [[NSUserDefaults standardUserDefaults]setValue:arr_selectedFriendsID forKey:@"Dic"];
        
    }
    else
    {
        [arr_index addObject:[NSString stringWithFormat:@"%ld",(long)[sender tag]]];
        [[NSUserDefaults standardUserDefaults] setValue:arr_index forKey:@"SelectedValueArray"];
        
//        NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
//        [arr_index sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
//        
//        NSLog(@" Sorted array %@",arr_index);
        
        [privateCell.btn_selectFriend setImage:[UIImage imageNamed:@"ico-tck-g"] forState:UIControlStateNormal];
        
        dic=[[NSMutableDictionary alloc]init];

        [dic setObject:[[arr_FriendList objectAtIndex:[sender tag]]valueForKey:@"id"] forKey:@"id"];
        [dic setObject:[[arr_FriendList objectAtIndex:[sender tag]]valueForKey:@"username"] forKey:@"username"];
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)[sender tag]] forKey:@"index"];

        [arr_selectedFriendsID addObject:dic];
        
        [[NSUserDefaults standardUserDefaults]setValue:arr_selectedFriendsID forKey:@"Dic"];

     //   NSLog(@"%@",arr_selectedFriendsID);

    }

//    UIImage *img=[(UIButton *) sender currentImage];
//    
//    
//    if ([[UIImage imageNamed:@"ico-tck-blk"] isEqual:img])
//    {
//       [privateCell.btn_selectFriend setImage:[UIImage imageNamed:@"ico-tck-g"] forState:UIControlStateNormal];
//        [arr_StoreIndexPath addObject:[NSString stringWithFormat:@"%ld",(long)[sender tag]]];
//        [[NSUserDefaults standardUserDefaults]setObject:arr_StoreIndexPath forKey:@"ARYINDEX"];
//
//        
//    }
//    else
//    {
//        [privateCell.btn_selectFriend setImage:[UIImage imageNamed:@"ico-tck-blk"] forState:UIControlStateNormal];
//        [arr_StoreIndexPath removeObjectAtIndex:[sender tag]];
//        [[NSUserDefaults standardUserDefaults]setObject:arr_StoreIndexPath forKey:@"ARYINDEX"];
//
//    }
    
    
}
- (IBAction)doneChallenge:(id)sender
{
    
    arr_friendsids=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"Dic"]];
    
    for (int i=0; i<[arr_friendsids count]; i++)
    {
        str_selecteedFriendID = [[arr_friendsids valueForKey:@"id"] componentsJoinedByString:@","];
    }
//    NSLog(@"%@",arr_friendsids);
    
//    if (isStringEmpty(str_selecteedFriendID))
//    {
//        str_selecteedFriendID=@" ";
//    }

    
    if (isfromTagingFriend==YES)
    {
        
        if (isStringEmpty(str_selecteedFriendID))
        {
            alert(@"Alert", @"Please tag atleast one friend");
        }
        else
        {
        
            BOOL checkNet = [[AppManager sharedManager] CheckReachability];
            if(!checkNet == FALSE)
            {
            [self WebserviceAddVideo];
            }
            
        }
    }
    else
    {
    [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)WebserviceAddVideo
{
    
    // http://dev414.trigma.us/krust/Webservices/videoupload?user_id=782&Video_name=abc.mp4&description=abc&challenge_name=abc&challenge_to=1,2
    
    if (isStringEmpty(str_selecteedFriendID)) {
        str_selecteedFriendID=@"";
    }
    if (isStringEmpty(str_postID)) {
        str_postID=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" : str_userID,
                                         @"Video_name" : @"",
                                         @"description" : @"",
                                         @"challenge_name" :@"",
                                         @"challenge_to" : str_selecteedFriendID,
                                         @"post_valid" : @"",
                                         @"custom_id" : str_postID
                                         
                                         }];
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,kvideoupload];

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
                 
                 [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"SelectedValueArray"];
                 [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"Dic"];
                 
                 ChangleVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Changle"];
                 [self.navigationController pushViewController:vc1 animated:YES];
                 
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
    if (isfromTagingFriend==YES)
    {
        
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"SelectedValueArray"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"Dic"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
    
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
