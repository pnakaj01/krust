//
//  commentVC.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "commentVC.h"
#import "comment.h"
#define myfont @"Verdana"
#import "AsyncImageView.h"
#import "AppManager.h"

@interface commentVC ()

@end

@implementation commentVC

@synthesize str_post_id;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _txtx_view.placeholder = @"Say something nice";
    _txtx_view.font=[UIFont fontWithName:@"System" size:18.0];
    _txtx_view.placeholderColor = [UIColor  blackColor];
    
    _txtx_view.layer.cornerRadius=5.0f;
    _txtx_view.clipsToBounds=YES;
    
    arr_comment=[[NSMutableArray alloc]init];
    
    _txtx_view.autocorrectionType = UITextAutocorrectionTypeNo;
    str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self retrivechat];
    [self scrollToBottom];

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)retrivechat
{
    //Add parameters to send server


    //quenelle.fansfoot.com/web/?type=post_show&post_type=hot

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:

                                       @{

                                         @"type" :@"show_comments",
                                         @"post_id" :@"8411"

                                         }];


    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    // [appdelRef showProgress:@"Please wait.."];

    [[AppManager sharedManager] getDataForUrl:@"http://quenelle.fansfoot.com/mobile/web/?"

                                   parameters:parameters

                                      success:^(AFHTTPRequestOperation *operation, id responseObject)

     {
         // Get response from server

     //    NSLog(@"JSON: %@", responseObject);

         if ([responseObject count]>0)
         {
             [[AppManager sharedManager] hideHUD];
             
             NSInteger Status=[[[[responseObject objectForKey:@"post"]valueForKey:@"status"]objectAtIndex:0] integerValue];
             if(Status ==1)
             {

                 if ([[[[responseObject objectForKey:@"post"]valueForKey:@"type"]objectAtIndex:0] isEqualToString:@"show_comments"])
                 {


                     arr_comment=[responseObject objectForKey:@"post"];

                     [tableVW_comment reloadData];
                     [self scrollToBottom];
                     tableVW_comment.hidden=NO;

                     return;

                 }

             }
             else if (Status==0)

             {

//                 alert(@"Alert", @"No Comments.");

                 [[AppManager sharedManager]hideHUD];

                 return;
             }

         }

         else
         {

             alert(@"Alert", @"Null Data.");

         }

     }

     failure:^(AFHTTPRequestOperation *operation, NSError *error)

     {

     //    NSLog(@"Error: %@", @"No internet connection.");

         // [appdelRef hideProgress];
         [[AppManager sharedManager]hideHUD];
         alert(@"Error", @"No internet connection.");

     }];


}
-(void)dismissKeyboard
{
    [_txtx_view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 50;
    
    //count number of row from counting array hear cataGorry is An Array
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setUserInteractionEnabled:NO];
    
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
    msg_lbl.backgroundColor = [UIColor blackColor];
    msg_lbl.textColor = [UIColor blackColor];
    msg_lbl.font=[UIFont fontWithName:@"Helvetica" size:15.0];
    [cell.contentView addSubview:msg_lbl];
    
    UIImageView *  personImgVw = [[UIImageView alloc]init];
    personImgVw.backgroundColor=[UIColor blackColor];
    [personImgVw setImage:[UIImage imageNamed:@"like-icon"]];
    [cell.contentView addSubview:personImgVw];
    
    UILabel  * namelbl=[[UILabel alloc] init];
    namelbl.backgroundColor = [UIColor blackColor];
    namelbl.textColor = [UIColor blackColor];
    namelbl.font=[UIFont fontWithName:@"Helvetica" size:12.0];
    [cell.contentView addSubview:namelbl];
    
    if (IS_IPHONE_5)
    {
        namelbl.frame = CGRectMake(6 , 4, 298, 14);
        
        size = [[arr_comment valueForKey:@"comments"][indexPath.row] sizeWithFont:msg_lbl.font constrainedToSize:CGSizeMake(225, 99999)];
        
        msg_lbl.numberOfLines = size.height/msg_lbl.font.lineHeight;
        
        msg_lbl.frame = CGRectMake(40, namelbl.frame.size.height+8, 300, size.height);
        
        msg_lbl.text =  [[arr_comment valueForKey:@"comments"] objectAtIndex:indexPath.row];
        
        namelbl.text=[[arr_comment valueForKey:@"username"] objectAtIndex:indexPath.row];
        
        
        personImgVw.frame=CGRectMake(7, 4  , 35 , 35);
        
    }
    else if (IS_IPHONE_6)
    {
        namelbl.frame = CGRectMake(40 , 4, 298, 14);
        
        size = [[arr_comment valueForKey:@"comments"][indexPath.row] sizeWithFont:msg_lbl.font constrainedToSize:CGSizeMake(225, 99999)];
        
        msg_lbl.numberOfLines = size.height/msg_lbl.font.lineHeight;
        
        msg_lbl.frame = CGRectMake(40, namelbl.frame.size.height+8, 350, size.height);
        
        msg_lbl.text =  [[arr_comment valueForKey:@"comments"] objectAtIndex:indexPath.row];
        
        namelbl.text=[[arr_comment valueForKey:@"username"] objectAtIndex:indexPath.row];
        
        personImgVw.frame=CGRectMake(7, 4  , 35 , 35);
        
    }
    else if (IS_IPHONE_6_PLUS)
    {
        namelbl.frame = CGRectMake(40 , 4, 298, 14);
        
        size = [[arr_comment valueForKey:@"comments"][indexPath.row] sizeWithFont:msg_lbl.font constrainedToSize:CGSizeMake(225, 99999)];
        
        msg_lbl.numberOfLines = size.height/msg_lbl.font.lineHeight;
        
        msg_lbl.frame = CGRectMake(40, namelbl.frame.size.height+8, 394, size.height);
        
        msg_lbl.text =  [[arr_comment valueForKey:@"comments"] objectAtIndex:indexPath.row];
        
        namelbl.text=[[arr_comment valueForKey:@"username"] objectAtIndex:indexPath.row];
        
        personImgVw.frame=CGRectMake(7, 4  , 35 , 35);
        
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath

{
    //    NSString* msg = [[arr_comment valueForKey:@"comments"]objectAtIndex:indexPath.row];
    //    CGRect rect = [msg boundingRectWithSize:CGSizeMake(225, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica neue" size:13]} context:nil];
    //    CGSize size1 = rect.size;
    //    height = size1.height+ size.height ;
    
    height = 35.0 + size.height;
    
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
    return height;
    
    
}


- (IBAction)send_message:(id)sender
{

    if (isStringEmpty([NSString stringWithFormat:@"%@",_txtx_view.text]))
    {
        alert(@"Message", @"Please Write a Comment");
    }

    else
    {
        [self SendComment];
        [_txtx_view resignFirstResponder];

    }

}

-(void)SendComment
{
    //Add parameters to send server
    
    
    //quenelle.fansfoot.com/web/?type=post_show&post_type=hot
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"type" :@"upload_comments",
                                         @"USERID" :str_userID,
                                         @"PID" :str_post_id,
                                         @"text" :_txtx_view.text
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    // [appdelRef showProgress:@"Please wait.."];
    
    [[AppManager sharedManager] getDataForUrl:BASE_URL
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
       //  NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
             if(Status ==1)
             {
                 
                 if ([[responseObject valueForKey:@"type"] isEqualToString:@"upload_comments"])
                 {
                     
                     //                     [self retrivechat];
                     _txtx_view.text=nil;
                     [[AppManager sharedManager]hideHUD];
                     
                     
                     return;
                     
                 }
                 
             }
             
             else if (Status==0)
                 
             {
                 
                 //                 alert(@"Alert", @"No Comments.");
                 
                 [[AppManager sharedManager]hideHUD];
                 
                 return;
             }
             
         }
         
         else
         {
             
             alert(@"Alert", @"Null Data.");
             [[AppManager sharedManager]hideHUD];
             
         }
         
     }
     
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
      //   NSLog(@"Error: %@", @"No internet connection.");
         
         // [appdelRef hideProgress];
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Error", @"No internet connection.");
         
     }];
    
    
}

-(void)scrollToBottom
{
    CGFloat yOffset = 0;
    if (tableVW_comment.contentSize.height > tableVW_comment.bounds.size.height)
    {
        yOffset = tableVW_comment.contentSize.height - tableVW_comment.bounds.size.height;
    }
    
    [tableVW_comment setContentOffset:CGPointMake(0, yOffset) animated:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tableVW_comment endEditing:YES];
    [_txtx_view resignFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    tableVW_comment.hidden=YES;
    [AppManager sharedManager].navCon = self.navigationController;
    self.tabBarController.tabBar.hidden=YES;
    
}


//- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    static NSString *cellIdentifier = @"comment";
//    // Similar to UITableViewCell, but
//    comment *tempcell = (comment *)[tableVW_comment dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    if (tempcell == nil)
//    {
//        tempcell = [[comment alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
//        tempcell = (comment *)[nib objectAtIndex:0];
//        
//        tempcell.selectionStyle = UITableViewCellSelectionStyleNone;
//        tempcell.selectionStyle=UITableViewCellAccessoryNone;
//        
//    }
//    
//    // Just want to test, so I hardcode the data
//    return tempcell;
//}


- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
