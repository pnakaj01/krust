//
//  PrivateChat.m
//  Havoc
//
//  Created by Preeti Malhotra on 7/26/14.
//  Copyright (c) 2014 Preeti Malhotra. All rights reserved.
//

#import "PrivateChat.h"
#define myfont @"Verdana"
#import "AsyncImageView.h"
#import "AppManager.h"
#import <Social/Social.h>
#import "PlaceholderTextView.h"
#import "Profile VC.h"
#import "Haneke.h"


@interface PrivateChat ()

@end

@implementation PrivateChat

@synthesize str_post_id,arr_detailComment;

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [_txtx_view resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (_txtx_view.text.length == 0)
    {
        btn_send.userInteractionEnabled=NO;
        btn_send.titleLabel.textColor=[UIColor lightGrayColor];
    }
    else
    {
        btn_send.userInteractionEnabled=YES;
         btn_send.titleLabel.textColor=[UIColor colorWithRed:177.0/255.0 green:61.0/255.0 blue:0.0/255.0 alpha:1];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    _txtx_view.placeholder = @"Make a comment";
    _txtx_view.font=[UIFont fontWithName:@"Helvetica" size:16.0];
    _txtx_view.placeholderColor = [UIColor  lightGrayColor];
    
    _txtx_view.autocorrectionType = UITextAutocorrectionTypeNo;
    _txtx_view.layer.cornerRadius=5;
    _txtx_view.clipsToBounds=YES;
    _txtx_view.delegate=self;
    
    btn_send.layer.cornerRadius=3.0;
    btn_send.clipsToBounds=YES;
    
    arr_comment=[[NSMutableArray alloc]init];

    [self scrollToBottom];

    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived:) name:@"TestNotification" object:nil];


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

-(void)retrivechat
{
    //Add parameters to send server
    
    //http://dev414.trigma.us/krust/Webservices/comment_show?video_id=15
    
    if (isStringEmpty(str_post_id))
    {
        str_post_id=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"video_id" :str_post_id
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kcommentshow];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
//         NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
             NSInteger Status=[[[[responseObject objectForKey:@"Comment"] valueForKey:@"status"]objectAtIndex:0] integerValue];
             if(Status ==1)
             {
                 PopUp_AlertComment.hidden=YES;

                     arr_comment=[responseObject objectForKey:@"Comment"];
                     [chattable reloadData];
                     [self scrollToBottom];
                     chattable.hidden=NO;

                     return;
                     
                 
             }
             else if (Status==0)
                 
             {
                 PopUp_AlertComment.hidden=NO;

//             alert(@"Alert", @"No Comments.");

                 return;
             }
             
         }
         
         else
         {
             [[AppManager sharedManager]hideHUD];
             PopUp_AlertComment.hidden=NO;

             alert(@"Alert", @"something went wrong.");
             
         }

     }
     
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {

         [[AppManager sharedManager]hideHUD];
         
         alert(@"Alert", @"Something went wrong.");
         
     }];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [AppManager sharedManager].navCon = self.navigationController;

    PopUp_AlertComment.hidden=YES;
    btn_send.userInteractionEnabled=NO;
    chattable.hidden=YES;
    chattable.allowsSelection = NO;
    [self scrollToBottom];
    str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    self.tabBarController.tabBar.hidden=YES;
    [AppManager sharedManager].navCon = self.navigationController;
}

-(void)viewDidAppear:(BOOL)animated
{
    
    BOOL checkNet = [[AppManager sharedManager] CheckReachability];
    if(!checkNet == FALSE)
    {
        chattable.hidden=NO;

    [self retrivechat];
    }
    else
    {
        chattable.hidden=YES;

    }
    [self scrollToBottom];
    
}

-(void)dismissKeyboard
{
    [_txtx_view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [arr_comment count];
    
    //count number of row from counting array hear cataGorry is An Array
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
     static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setUserInteractionEnabled:YES];
    
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    for(UIView *cellView in [cell.contentView subviews])
    {
        if (![cellView isKindOfClass:[UIImageView class]] || ![cellView isKindOfClass:[UILabel class]] || ![cellView isKindOfClass:[UIButton class]])
        {
            [cellView removeFromSuperview];
        }
    }
    
    UILabel  * msg_lbl=[[UILabel alloc] init];
    msg_lbl.backgroundColor = [UIColor clearColor];
     msg_lbl.textColor = [UIColor colorWithRed:168.0/255.0 green:168.0/255.0 blue:168.0/255.0 alpha:1];
    msg_lbl.font=[UIFont fontWithName:@"Helvetica" size:16.0];
    [cell.contentView addSubview:msg_lbl];
    
    UILabel  * namelbl=[[UILabel alloc] init];
    namelbl.backgroundColor = [UIColor clearColor];
    namelbl.textColor = [UIColor colorWithRed:186.0/255.0 green:53.0/255.0 blue:11.0/255.0 alpha:1];
    namelbl.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    [cell.contentView addSubview:namelbl];
    
    UIButton  * namebutton=[[UIButton alloc] init];
    namebutton.backgroundColor = [UIColor clearColor];
    namebutton.tag=indexPath.row;
    [namebutton addTarget:self action:@selector(ShowProfilePUSH:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:namebutton];
    
    UILabel  * lbl_date=[[UILabel alloc] init];
    lbl_date.backgroundColor = [UIColor clearColor];
    lbl_date.textColor = [UIColor colorWithRed:134.0/255.0 green:183.0/255.0 blue:132.0/255.0 alpha:1];
    lbl_date.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    [cell.contentView addSubview:lbl_date];

    UIImageView *  personImgVw = [[UIImageView alloc]init];
    [cell.contentView addSubview:personImgVw];
    
    UIButton  * btn_delete=[[UIButton alloc] init];
    //    btn_delete.backgroundColor = [UIColor blackColor];
    [btn_delete setTitle:@"Delete" forState:UIControlStateNormal];
    [btn_delete setTitleColor:[UIColor colorWithRed:134.0/255.0 green:183.0/255.0 blue:132.0/255.0 alpha:1] forState:UIControlStateNormal];
    btn_delete.titleLabel.font = [UIFont systemFontOfSize:14.0];

    if ([[[arr_comment valueForKey:@"user_id"] objectAtIndex:indexPath.row] isEqualToString:str_userID])
    {
        [btn_delete addTarget:self action:@selector(deletecomment:) forControlEvents:UIControlEventTouchUpInside];
        btn_delete.tag=indexPath.row;
        [cell.contentView addSubview:btn_delete];
    }
    
    if (IS_IPHONE_5)
    {
        namelbl.frame = CGRectMake(48 , 4, 250, 18);

        namebutton.frame=CGRectMake(namelbl.frame.origin.x, namelbl.frame.origin.y, namelbl.frame.size.width, namelbl.frame.size.height);
        
        size = [[arr_comment valueForKey:@"comment"][indexPath.row] sizeWithFont:msg_lbl.font constrainedToSize:CGSizeMake(225, 99999)];
        
        msg_lbl.numberOfLines = size.height/msg_lbl.font.lineHeight;
        
        msg_lbl.frame = CGRectMake(48, namelbl.frame.size.height+5, 260, size.height);
        
        msg_lbl.text =  [[arr_comment valueForKey:@"comment"] objectAtIndex:indexPath.row];
        
        namelbl.text=[[arr_comment valueForKey:@"username"] objectAtIndex:indexPath.row];
        
        lbl_date.text=[[arr_comment valueForKey:@"date_uploads"] objectAtIndex:indexPath.row];
        lbl_date.frame = CGRectMake(170, size.height+21, 130, 20);
        
        btn_delete.frame = CGRectMake(100, size.height+18, 60, 15);

        personImgVw.frame=CGRectMake(7 , 4, 35, 35);
        
    }
    else if (IS_IPHONE_6)
    {
        namelbl.frame = CGRectMake(48 , 4, 250, 18);

         namebutton.frame=CGRectMake(namelbl.frame.origin.x, namelbl.frame.origin.y, namelbl.frame.size.width, namelbl.frame.size.height);
        
        size = [[arr_comment valueForKey:@"comment"][indexPath.row] sizeWithFont:msg_lbl.font constrainedToSize:CGSizeMake(225, 99999)];
        
        msg_lbl.numberOfLines = size.height/msg_lbl.font.lineHeight;
        
        msg_lbl.frame = CGRectMake(48, namelbl.frame.size.height+5, 320, size.height);
        
        msg_lbl.text =  [[arr_comment valueForKey:@"comment"] objectAtIndex:indexPath.row];
        
        namelbl.text=[[arr_comment valueForKey:@"username"] objectAtIndex:indexPath.row];
        
        lbl_date.frame = CGRectMake(240, msg_lbl.frame.size.height+18, 140, 20);
        
        lbl_date.text=[[arr_comment valueForKey:@"date_uploads"] objectAtIndex:indexPath.row];

        btn_delete.frame = CGRectMake(170, size.height+20, 60, 15);

        personImgVw.frame=CGRectMake(7, 4, 35, 35);
    }
    else if (IS_IPHONE_6_PLUS)
    {
        namelbl.frame = CGRectMake(48 , 4, 298, 18);

         namebutton.frame=CGRectMake(namelbl.frame.origin.x, namelbl.frame.origin.y, namelbl.frame.size.width, namelbl.frame.size.height);
        
         size = [[arr_comment valueForKey:@"comment"][indexPath.row] sizeWithFont:msg_lbl.font constrainedToSize:CGSizeMake(225, 99999)];
        
        msg_lbl.numberOfLines = size.height/msg_lbl.font.lineHeight;
        
        msg_lbl.frame = CGRectMake(48, namelbl.frame.size.height+5, 355, size.height);
        
        msg_lbl.text =  [[arr_comment valueForKey:@"comment"] objectAtIndex:indexPath.row];
        
        namelbl.text=[[arr_comment valueForKey:@"username"] objectAtIndex:indexPath.row];
        
        lbl_date.frame = CGRectMake(270, msg_lbl.frame.size.height+13, 140, 20);
        
        lbl_date.text=[[arr_comment valueForKey:@"date_uploads"] objectAtIndex:indexPath.row];
        
        btn_delete.frame = CGRectMake(195, size.height+16, 60, 15);

        personImgVw.frame=CGRectMake(7, 4, 35, 35);
        
    }
    
//    NSLog(@"%@",[arr_comment valueForKey:@"username_profile"]);
    
    personImgVw.layer.cornerRadius=personImgVw.frame.size.height/2;
    personImgVw.clipsToBounds = YES;

    
    
    
    NSString *imagestr = [NSString stringWithFormat:@"%@",[[arr_comment valueForKey:@"username_profile"] objectAtIndex:indexPath.row]];
    
    if (isStringEmpty(imagestr))
    {
        personImgVw.image=[UIImage imageNamed:@"img-user-default"];
    }
    else
    {
    [personImgVw hnk_setImageFromURL: [NSURL URLWithString:imagestr]];
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath

{
//    NSString* msg = [[arr_comment valueForKey:@"comments"]objectAtIndex:indexPath.row];
//    CGRect rect = [msg boundingRectWithSize:CGSizeMake(225, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica neue" size:13]} context:nil];
//    CGSize size1 = rect.size;
//    height = size1.height+ size.height ;
  
    height = 40.0 + size.height;
    
    if(height < 50)
    {
        height = 50;
    }
    return height;
    
//    if(height < 87)
//    {
//        if (height<=31)
//        {
//            height=50;
//        }
//        else
//        {
//            height = 97;
//            
//        }
//        return height;
//    }
//    
//    else
//    {
//        return height-20;
//    }
    
}

-(IBAction)ShowProfilePUSH:(id)sender
{
    NSString * str_FriendID=[[arr_comment valueForKey:@"comment_id"]objectAtIndex:[sender tag]];
    //NSLog(@"%@",str_FriendID);
    
    
        if ([[[arr_comment valueForKey:@"user_id"]objectAtIndex:[sender tag]] isEqualToString:@"780"])
        {
            alert(@"Alert", @"This video uploaded by admin");
        }
        else
        {
            Profile_VC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
            vc1.str_post_id=[[arr_comment valueForKey:@"user_id"]objectAtIndex:[sender tag]];
            [self.navigationController pushViewController:vc1 animated:YES];
        }


}

-(IBAction)deletecomment:(id)sender
{
//http://dev414.trigma.us/krust/Webservices/comment_delete?user_id=878&video_id=786&comment_id=136
    
    
    if (isStringEmpty(str_post_id))
    {
        str_post_id=@"";
    }
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    
    NSString * str_comment_id=[[arr_comment valueForKey:@"comment_id"]objectAtIndex:[sender tag]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" :str_userID,
                                         @"video_id" : str_post_id,
                                         @"comment_id" : str_comment_id
                                         
                                         }];
    
    
//    [[AppManager sharedManager] showHUD:@"Loading..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kcommentdelete];

    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
    //     NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
//             [[AppManager sharedManager]hideHUD];
             
             NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
             if(Status ==1)
             {
                 [self retrivechat];
                 [self scrollToBottom];
                 
                 return;
                 
                 
             }
             else if (Status==0)
                 
             {
                 
                 return;
             }
             
         }
         
         else
         {
//             [[AppManager sharedManager]hideHUD];
             alert(@"Alert", @"Null Data.");
             
         }
         
     }
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Alert", @"Something went wrong.");
         
     }];


}
- (IBAction)send_message:(id)sender
{
    
    if (isStringEmpty([NSString stringWithFormat:@"%@",_txtx_view.text]))
    {
        alert(@"Message", @"Please Write a Comment");
        
        btn_send.titleLabel.textColor=[UIColor clearColor];
        
    }
    
    else
    {
        BOOL checkNet = [[AppManager sharedManager] CheckReachability];
        if(!checkNet == FALSE)
        {
        [self SendComment];
        [_txtx_view resignFirstResponder];
        }
        
    }
    
}

-(void)SendComment
{
    //Add parameters to send server
    
   // http://dev414.trigma.us/krust/Webservices/comment_upload?user_id=785&video_id=786&comment_text=hi
    
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    
    if (isStringEmpty(str_post_id))
    {
        str_post_id=@"";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" :str_userID,
                                         @"video_id" :str_post_id,
                                         @"comment_text" :_txtx_view.text
                                         
                                         }];
    
    
//    [[AppManager sharedManager] showHUD:@"Loading..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kcommentupload];

    [[AppManager sharedManager] getDataForUrl:url
                                   parameters:parameters
     
    success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
    //     NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
             NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
             if(Status ==1)
             {
                 btn_send.backgroundColor=[UIColor clearColor];
                     [self retrivechat];
                     _txtx_view.text=nil;
                     [self scrollToBottom];
                     
                     return;
                     
             }
             
             else if (Status==0)
                 
             {
                 
                 alert(@"Alert", @"comment not uploaded.");
                 
                 return;
             }
             
         }
         
         else
         {
             [[AppManager sharedManager]hideHUD];
             
             alert(@"Alert", @"Null Data.");
             
         }
         
     }
     
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Error", @"Null response");
         
     }];
    
}

-(void)scrollToBottom
{
    CGFloat yOffset = 0;
    if (chattable.contentSize.height > chattable.bounds.size.height)
    {
        yOffset = chattable.contentSize.height - chattable.bounds.size.height;
    }
    
    [chattable setContentOffset:CGPointMake(0, yOffset) animated:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [chattable endEditing:YES];
    [_txtx_view resignFirstResponder];
}



@end
