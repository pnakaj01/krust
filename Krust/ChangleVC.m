//
//  ChangleVC.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "ChangleVC.h"
#import "challengeCell.h"
#import "SelectchallengeVC.h"
#import "SelectFriendVC.h"
#import "AppManager.h"

@interface ChangleVC ()

@end

@implementation ChangleVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"Pushcontroller" object:self userInfo:nil];
    
    view_popup.hidden=YES;
    str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    arr_IncomingMessages=[[NSMutableArray alloc]init];
    
    [AppManager sharedManager].navCon = self.navigationController;
    
    self.tabBarController.tabBar.hidden=NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
        tableVW_challenge.hidden=NO;
        
        [self GetMessageData];
    }
    else
    {
        tableVW_challenge.hidden=YES;
    }
    
}

- (IBAction)segmentAction:(id)sender
{
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
        tableVW_challenge.hidden=NO;
        [self GetMessageData];
    }
    else
    {
        tableVW_challenge.hidden=YES;
    }
    
}


-(void)GetMessageData
{
    //    http://dev414.trigma.us/krust/Webservices/challenge_come?user_id=785
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    
    if (segment.selectedSegmentIndex==0)
    {
        
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
                 
                 NSInteger Status=[[[[responseObject valueForKey:@"list"]objectAtIndex:0]valueForKey:@"status"] integerValue];
                 
                 if(Status == 1)
                 {
                     view_popup.hidden=YES;
                     arr_IncomingMessages=[responseObject valueForKey:@"list"];
                     tableVW_challenge.hidden=NO;
                     [tableVW_challenge reloadData];
                    
                     return;
                 }
                 else if (Status==0)
                 {
                     
//                     alert(@"Alert", @"No incoming challenges.");
                     tableVW_challenge.hidden=YES;
                     view_popup.hidden=NO;
                     lbl_messagepopup.text=@"No incoming challenges";
                     [[AppManager sharedManager]hideHUD];
                     
                     return;
                     
                 }
             }
             
         }
         
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
         
         {
             [[AppManager sharedManager]hideHUD];
             tableVW_challenge.hidden=YES;
             view_popup.hidden=NO;
             lbl_messagepopup.text=@"No incoming challenges";
             alert(@"Alert", @"Something went wrong.");
             
         }];
        
    }
    
    else
    {
        
        if (isStringEmpty(str_userID))
        {
            str_userID=@"";
        }
//        http://dev414.trigma.us/krust/Webservices/challenge_out?user_id=785
        segment.selectedSegmentIndex=1;
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                           
                                           @{
                                             
                                             @"user_id" : str_userID
                                             
                                             }];
        
        
        [[AppManager sharedManager] showHUD:@"Loading..."];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kchallengeout];

        [[AppManager sharedManager] getDataForUrl:url
         
                                       parameters:parameters
         
                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
         
         {
             // Get response from server
             
       //      NSLog(@"JSON: %@", responseObject);
             
             
             if ([responseObject count]>0)
             {
                 [[AppManager sharedManager]hideHUD];
                 
                 NSInteger Status=[[[[responseObject valueForKey:@"list"]objectAtIndex:0]valueForKey:@"status"] integerValue];
                 
                 if(Status == 1)
                 {
                     view_popup.hidden=YES;
                     tableVW_challenge.hidden=NO;
                     arr_IncomingMessages=[responseObject valueForKey:@"list"];
                     [tableVW_challenge reloadData];
                     return;
                 }
                 else if (Status==0)
                 {
//                     alert(@"Alert", @"No outcoming challenges.");
                     tableVW_challenge.hidden=YES;
                     view_popup.hidden=NO;
                     lbl_messagepopup.text=@"No outgoing challenges";
                     [[AppManager sharedManager]hideHUD];
                     return;
                     
                 }
             }
             
         }
         
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
         
         {
             [[AppManager sharedManager]hideHUD];
             tableVW_challenge.hidden=YES;
             view_popup.hidden=NO;
             lbl_messagepopup.text=@"No outgoing challenges";
             alert(@"Alert", @"Something went wrong.");
             
         }];
        
    }
    
}


#pragma mark --TableView Delegate--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr_IncomingMessages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"challengeCell";
    // Similar to UITableViewCell, but
    challengeCell *tempcell;
    
    if (tempcell == nil)
    {
        tempcell = (challengeCell *)[tableVW_challenge dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        tempcell = (challengeCell *)[nib objectAtIndex:0];
        if ([arr_IncomingMessages count]>0)
        {
            
            [tempcell loaditemwithAdvertListArray:[arr_IncomingMessages objectAtIndex:indexPath.row]];
            
        }
    }
    
    if ([arr_IncomingMessages count]>0)
    {
        tempcell.selectionStyle = UITableViewCellSelectionStyleNone;
        tempcell.selectionStyle=UITableViewCellAccessoryNone;
        tempcell.btn_AcceptChallenge.tag=indexPath.row;
        [tempcell.btn_AcceptChallenge addTarget:self action:@selector(AcceptChallenge:) forControlEvents:UIControlEventTouchUpInside];
        
        tempcell.btn_RejectChallenge.tag=indexPath.row;
        [tempcell.btn_RejectChallenge addTarget:self action:@selector(RejectChallenge:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[[arr_IncomingMessages valueForKey:@"challenge_status"] objectAtIndex:indexPath.row] isEqualToString:@"Pending"] && [[[arr_IncomingMessages valueForKey:@"type"] objectAtIndex:indexPath.row] isEqualToString:@"in"])
        {
            if (IS_IPHONE_5)
            {
            
                tempcell.lbl_message.frame=CGRectMake(15, 4, 170, 21);
              //  tempcell.btn_AcceptChallenge.frame=CGRectMake(tempcell.lbl_message.frame.origin.x-5, ,55 , 35);
                
            }
            else if (IS_IPHONE_6)
            {
                tempcell.lbl_message.frame=CGRectMake(15, 6, 190, 22);

            }
            else if (IS_IPHONE_6_PLUS)
            {
                tempcell.lbl_message.frame=CGRectMake(15, 6, 270, 22);
            }
        }

    }
    // Just want to test, so I hardcode the data
    return tempcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
}
-(void)RejectChallenge:(id)sender
{
    
//    if([[[arr_IncomingMessages valueForKey:@"challenge_status"]objectAtIndex:[sender tag]] isEqualToString:@"Accepted"] && [[[arr_IncomingMessages valueForKey:@"type"]objectAtIndex:[sender tag]] isEqualToString:@"in"])
//    {
//        StatusofChallenge = [NSString stringWithFormat:@"%d",0];
//    }
//     if ([[[arr_IncomingMessages valueForKey:@"challenge_status"]objectAtIndex:[sender tag]] isEqualToString:@"Pending"] && [[[arr_IncomingMessages valueForKey:@"type"]objectAtIndex:[sender tag]] isEqualToString:@"in"])
//    {
        StatusofChallenge = [NSString stringWithFormat:@"%d",0];
//    }
//    else
//    {
//        StatusofChallenge = [NSString stringWithFormat:@"%d",0];
//
//    }
    
     str_UserIdMember=[[arr_IncomingMessages valueForKey:@"userid"]objectAtIndex:[sender tag]];
    if (isStringEmpty(str_UserIdMember))
    {
        str_UserIdMember=@"";
    }
     str_VideoID=[[arr_IncomingMessages valueForKey:@"video_id"]objectAtIndex:[sender tag]];
    
    if (isStringEmpty(str_VideoID))
    {
        str_VideoID=@"";
    }
    
    [self RejectOrAcceptChallenge];
}
-(void)AcceptChallenge:(id)sender
{
//    if([[[arr_IncomingMessages valueForKey:@"challenge_status"]objectAtIndex:[sender tag]] isEqualToString:@"Accepted"] && [[[arr_IncomingMessages valueForKey:@"type"]objectAtIndex:[sender tag]] isEqualToString:@"in"])
//    {
//        StatusofChallenge = [NSString stringWithFormat:@"%d",0];
//    }
//    if ([[[arr_IncomingMessages valueForKey:@"challenge_status"]objectAtIndex:[sender tag]] isEqualToString:@"Pending"] && [[[arr_IncomingMessages valueForKey:@"type"]objectAtIndex:[sender tag]] isEqualToString:@"in"])
//    {
        StatusofChallenge = [NSString stringWithFormat:@"%d",1];
//    }
//    else
//    {
//        StatusofChallenge = [NSString stringWithFormat:@"%d",0];
//        
//    }

    
    str_UserIdMember=[[arr_IncomingMessages valueForKey:@"userid"]objectAtIndex:[sender tag]];
    if (isStringEmpty(str_UserIdMember))
    {
        str_UserIdMember=@"";
    }
    str_VideoID=[[arr_IncomingMessages valueForKey:@"video_id"]objectAtIndex:[sender tag]];
    
    if (isStringEmpty(str_VideoID))
    {
        str_VideoID=@"";
    }
    
    [self RejectOrAcceptChallenge];

 
}
-(void)RejectOrAcceptChallenge
{
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    
    //  http://dev414.trigma.us/krust/Webservices/accept_reject?user_id=825&status=1&video_id=1
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" : str_UserIdMember,
                                         @"status" : StatusofChallenge,
                                         @"video_id" : str_VideoID
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kacceptreject];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     
     {
         // Get response from server
         
        // NSLog(@"JSON: %@", responseObject);
         
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
             NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
             
             if(Status == 1)
             {
                 segment.selectedSegmentIndex=0;
                 [self GetMessageData];
                 return;
             }
             else if (Status==0)
             {
                 //alert(@"Alert", @"No outcoming challenges.");
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
