//
//  FeedbackViewController.m
//  Krust
//
//  Created by Pankaj Sharma on 22/08/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "FeedbackViewController.h"
#import "AppManager.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

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

-(void)viewWillAppear:(BOOL)animated
{
    txt_description.placeholder = @"Description";
    txt_description.font=[UIFont fontWithName:@"System" size:18.0];
    txt_description.placeholderColor = [UIColor  lightGrayColor];
    
    txt_subject.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Subject" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];

    
    [AppManager sharedManager].navCon = self.navigationController;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)TappedOnSubmit:(id)sender
{
  if (isStringEmpty([NSString stringWithFormat:@"%@",txt_subject.text]))
    {
        [txt_subject becomeFirstResponder];
        alert(@"Message", @"Please Enter Subject.");
        
    }
    else if (isStringEmpty([NSString stringWithFormat:@"%@",txt_description.text]))
    {
        txt_description.text=nil;
        alert(@"Message", @"Please Enter Description.");
        [txt_description becomeFirstResponder];
    }
    else
    {
        BOOL checkNet = [[AppManager sharedManager] CheckReachability];
        if(!checkNet == FALSE)
        {
            [txt_subject resignFirstResponder];
            [txt_description resignFirstResponder];
            
            [self WebserviceFeedback];
            
        }
    }
    
}
-(void)WebserviceFeedback
{
    NSString *str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    if (isStringEmpty(str_userID))
    {
        str_userID=@"";
    }
    
   // http://dev414.trigma.us/krust/Webservices/contact_us?subject=abc&massage=hello
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"subject" :txt_subject.text,
                                         @"massage" :txt_description.text,
                                         @"user_id" : str_userID
                                         
                                         }];
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    // [appdelRef showProgress:@"Please wait.."];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,Kcontactus];

    
    [[AppManager sharedManager] getDataForUrl:url
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
   //      NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             [[AppManager sharedManager]hideHUD];
             
             
                 NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
                 
                 if(Status ==1)
                 {
                     
                     alert(@"Alert", @"Feedback successfully submitted.");
                     [self.navigationController popViewControllerAnimated:YES];
                     txt_description.text=nil;
                     txt_subject.text=nil;
                     
                     return;
                     
                 }
                 
                 else if (Status==0)
                 {
                     alert(@"Alert", @"Failed to send feedback.");
                     
                     return;
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
    [txt_subject resignFirstResponder];
    [txt_description resignFirstResponder];
}
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [txt_description resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txt_subject)
    {
        [txt_subject  resignFirstResponder];
    }
    return YES;
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
