//
//  SelectchallengeVC.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "SelectchallengeVC.h"
#import "ChallengeListCell.h"
#import "AppManager.h"
#import "cameraVC.h"
#import "SelectFriendVC.h"
#import "challangeDetailsViewController.h"


@interface SelectchallengeVC ()

@end

@implementation SelectchallengeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
//    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    spinner.frame = CGRectMake(0, 0, 320, 44);
//    _tableVW_challenges.tableFooterView = spinner;
    View_popup.hidden=YES;
    arr_PostData=[[NSMutableArray alloc]init];
    
    str_USERID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];


    self.tabBarController.tabBar.hidden=YES;

}
//-(void)GetTimeData
//{
//    hour=[[NSString stringWithFormat:@"%@",[[arr_PostData valueForKey:@"hours"] objectAtIndex:0]] intValue];
//    
//    minit=[[NSString stringWithFormat:@"%@",[[arr_PostData valueForKey:@"minutes"] objectAtIndex:0]] intValue];
//    
//    sec=[[NSString stringWithFormat:@"%@",@"0"] intValue];
//    
//    
//    if (hour==0 && minit==0 && sec==0)
//    {
//        lbl_days.text=@"00";
//        lbl_hours.text=@"00";
//        lbl_minitus.text=@"00";
//        
//    }
//    
//    CountDowntimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TimerFired) userInfo:nil repeats:YES];
//
//}

-(void)viewDidAppear:(BOOL)animated
{
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
    [self GetVideoPostData];
    }
}
-(void)GetVideoPostData
{
    
    
    //http://dev414.trigma.us/krust/Webservices/video?user_id=785&page=1&challenge=admin
    
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
         
     //    NSLog(@"JSON: %@", responseObject);
         
         
         if ([responseObject count]>0)
         {
             [spinner stopAnimating];
             
             [[AppManager sharedManager]hideHUD];
             
             
             NSInteger Status=[[[[responseObject valueForKey:@"post"]objectAtIndex:0]valueForKey:@"status"] integerValue];
             
             
             if(Status == 1)
             {
                 
                 arr_PostData=[responseObject valueForKey:@"post"];
                 View_popup.hidden=YES;
                 _tableVW_challenges.hidden=NO;
//                 [self GetTimeData];
                 [_tableVW_challenges reloadData];
                 
                 return;
             }
             
             else if (Status==0)
             {
//                 alert(@"Alert", @"No Post.");
                 View_popup.hidden=NO;
                 _tableVW_challenges.hidden=YES;
                 [[AppManager sharedManager]hideHUD];
                 return;
             }
         }
         
     }
     
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [[AppManager sharedManager]hideHUD];
         View_popup.hidden=NO;
         _tableVW_challenges.hidden=YES;
         alert(@"Alert", @"Something went wrong.");
         
     }];
    
    
}


//-(void)TimerFired
//{
// 
//    lbl_days.text=[NSString stringWithFormat:@"%@",[[arr_PostData valueForKey:@"days"] objectAtIndex:0]];
//
//    
//    if(hour>0 || minit >0 || sec>0)
//    {
//        
//        
//        if (sec==0)
//        {
//           
//            if (minit==0 && sec==0)
//            {
//                if (minit==0 && hour==0)
//                {
//                    sec=60;
//                    timerFlasg=FALSE;
//                }
//            
//                if(hour==0 && minit==0 && sec==0)
//                {
//                    [CountDowntimer invalidate];
//                    timerFlasg=FALSE;
//                   
//                }
//            }
//
//                if (timerFlasg==TRUE && minit==0 && sec==0)
//                {
//                    hour=hour-1;
//                    minit=60;
//                    sec=60;
//                }
//                else
//                {
//                    sec=60;
//                }
//            
//            minit=minit-1;
//
//        }
//
//        if(sec>0)
//        {
//            sec=sec-1;
//        }
////        lbl_days.text=[NSString stringWithFormat:@"%d",hour];
//        lbl_hours.text=[NSString stringWithFormat:@"%d",hour];
//        lbl_minitus.text=[NSString stringWithFormat:@"%d",minit];
//       
//    }
//    else
//    {
//        lbl_days.text=@"00";
//        [CountDowntimer invalidate];
//    }
//
//}
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)TappedOnCreateaChallenge:(id)sender
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedValueArray"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Dic"];
    
    challangeDetailsViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"challangeDetailsViewController"];
    [self.navigationController pushViewController:vc1 animated:YES];
    
    
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
    
    static NSString *cellIdentifier = @"ChallengeListCell";
    // Similar to UITableViewCell, but
    ChallengeListCell *tempcell;
    
    if (tempcell == nil)
    {
        tempcell = (ChallengeListCell *)[_tableVW_challenges dequeueReusableCellWithIdentifier:cellIdentifier];
        // tempcell = [[HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        tempcell = (ChallengeListCell *)[nib objectAtIndex:0];
        
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
        tempcell.btn_SelectChallenge.tag=indexPath.row;
        
        [tempcell.btn_SelectChallenge addTarget:self action:@selector(CahllengeSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    }
    
    return tempcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    
    ChallengeListCell *privateCell =(ChallengeListCell*)[_tableVW_challenges cellForRowAtIndexPath:path];
    
    [privateCell.btn_SelectChallenge setBackgroundImage:[UIImage imageNamed:@"btn-radio"] forState:UIControlStateNormal];
    
    SelectFriendVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectFriend"];
    vc1.isfromTagingFriend=YES;
    strr_PostID=[[arr_PostData valueForKey:@"id"]objectAtIndex:indexPath.row];
    vc1.str_postID=strr_PostID;
    //    [[NSUserDefaults standardUserDefaults]setObject:strr_PostID forKey:@"PostID"];
    [self.navigationController pushViewController:vc1 animated:YES];
}

-(void)CahllengeSelect:(id)sender
{
//   NSIndexPath *path = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
//    
//    ChallengeListCell *privateCell =(ChallengeListCell*)[_tableVW_challenges cellForRowAtIndexPath:path];
//    
//    if ([[UIImage imageNamed:@"btn-radio-blnk"] isEqual:privateCell.btn_SelectChallenge.currentImage])
//    {
//        [privateCell.btn_SelectChallenge setBackgroundImage:[UIImage imageNamed:@"btn-radio"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [privateCell.btn_SelectChallenge setBackgroundImage:[UIImage imageNamed:@"btn-radio-blnk"] forState:UIControlStateNormal];
//
//    }
    
//    NSIndexPath *path = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
//    
//    ChallengeListCell *privateCell =(ChallengeListCell*)[_tableVW_challenges cellForRowAtIndexPath:path];
//    
//    [privateCell.btn_SelectChallenge setBackgroundImage:[UIImage imageNamed:@"btn-radio"] forState:UIControlStateNormal];
//    
//    Indexfoarray=[sender tag];
//    [self performSelector:@selector(Pushtocamera) withObject:nil afterDelay:0.1];
}
-(void)Pushtocamera
{
    SelectFriendVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectFriend"];
    vc1.isfromTagingFriend=YES;
    strr_PostID=[[arr_PostData valueForKey:@"id"]objectAtIndex:Indexfoarray];
    vc1.str_postID=strr_PostID;
//    [[NSUserDefaults standardUserDefaults]setObject:strr_PostID forKey:@"PostID"];
    [self.navigationController pushViewController:vc1 animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [CountDowntimer invalidate];
    lbl_days.text=nil;
    lbl_hours.text=nil;
    lbl_minitus.text=nil;
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
