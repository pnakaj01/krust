//
//  TeamsVC.m
//  Krust
//
//  Created by Pankaj Sharma on 06/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import "TeamsVC.h"
#import "AppManager.h"
#import "teamtableCell.h"
#import "TeamMatesVC.h"
#import "EditteamVC.h"
#import "Haneke.h"

@interface TeamsVC ()

@end

@implementation TeamsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableview_like.allowsMultipleSelectionDuringEditing = NO;
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
    
//    http://dev414.trigma.us/krust/Webservices/list_group?user_id=12
    
    str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         @"user_id" : str_userID
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Klistgroup];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     
     {
         // Get response from server
         
      //   NSLog(@"JSON: %@", responseObject);
         
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
             NSInteger Status=[[[[responseObject objectForKey:@"list"]objectAtIndex:0]valueForKey:@"status"]integerValue];
             
             if(Status == 1)
             {
                 PopUp_AlertComment.hidden=YES;
                 
                 arr_likeData=[responseObject objectForKey:@"list"];
                 
                 [_tableview_like reloadData];
                 
                 return;
             }
             else if (Status==0)
             {
                 
                 //                 alert(@"Alert", @"No Likes.");
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
    static NSString *cellIdentifier = @"teamtableCell";
    // Similar to UITableViewCell, but
    teamtableCell *tempcell;
    
    if (tempcell == nil)
    {
        tempcell = (teamtableCell *)[_tableview_like dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        tempcell = (teamtableCell *)[nib objectAtIndex:0];
        if ([arr_likeData count]>0)
        {
            
            [tempcell loaditemwithAdvertListArray:[arr_likeData objectAtIndex:indexPath.row]];
        }
    }
    
    if ([arr_likeData count]>0)
    {
        tempcell.selectionStyle = UITableViewCellSelectionStyleNone;
        tempcell.selectionStyle=UITableViewCellAccessoryNone;

    }
    
    // Just want to test, so I hardcode the data
    return tempcell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[arr_likeData valueForKey:@"group"]objectAtIndex:indexPath.row] isEqualToString:@"user"])
    {
 
        return NO;
        
    }
    
    return YES;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath

{
   
            
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
             //                           NSLog(@"Action to perform with Button 1");
                          //              NSLog(@"%ld",(long)indexPath.row);
                                        
                                        EditteamVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"EditteamVC"];
                                        vc1.str_groupID=[[arr_likeData valueForKey:@"group_id"]objectAtIndex:indexPath.row];
                                        [self.navigationController pushViewController:vc1 animated:YES];
                                        
                                    }];
    
    button.backgroundColor = [UIColor darkGrayColor]; //arbitrary color
    UITableViewRowAction *button2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    
                                     {

             // http://dev414.trigma.us/krust/Webservices/delete_group?group_id=14&user_id=840
                                         
                                         if (isStringEmpty(str_userID))
                                         {
                                             str_userID=@"";
                                         }

             NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                                
                                                @{
                                                  
                                                  @"group_id" : [[arr_likeData valueForKey:@"group_id"]objectAtIndex:indexPath.row],
                                                  @"user_id" : str_userID,
                                                
                                                  }];
             
             [[AppManager sharedManager] showHUD:@"Loading..."];
                                         NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kdeletegroup];

             [[AppManager sharedManager] getDataForUrl:url
              
                                            parameters:parameters
              
                                               success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
              
              {
                  // Get response from server
                  
          //        NSLog(@"JSON: %@", responseObject);
                  
                  
                  if ([responseObject count]>0)
                  {
                      
                      [[AppManager sharedManager]hideHUD];
                      
                      NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
                      
                      if(Status == 1)
                      {

                          [self GetLikeData];
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

        
    }];
    
    button2.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:53.0/255.0 blue:11.0/255.0 alpha:1]; //arbitrary color
    
    return @[button, button2]; //array with all the buttons you want. 1,2,3, etc...
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // you need to implement this method too or nothing will work:
    
}

// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        //add code here for when you hit delete
//    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert)
//    {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[arr_likeData valueForKey:@"group"]objectAtIndex:indexPath.row] isEqualToString:@"user"])
    {
    
    }
    else
    {
    TeamMatesVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"TeamMatesVC"];
    vc1.str_GroupID=[[arr_likeData valueForKey:@"group_id"]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc1 animated:YES];
    }

}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
