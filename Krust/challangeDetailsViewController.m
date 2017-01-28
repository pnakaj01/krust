//
//  challangeDetailsViewController.m
//  Krust
//
//  Created by Pankaj Sharma on 14/08/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "challangeDetailsViewController.h"
#import "AppManager.h"
#import "SelectFriendVC.h"
#import "MYVideoADDCameraViewController.h"
#import "ChangleVC.h"
#import "HeaderFile.h"
#import "cameraVC.h"
#import "SelectFriendVC.h"
#import "SelectchallengeVC.h"



@interface challangeDetailsViewController ()
{
    __block NSString* videoPath;
    
}

@end

@implementation challangeDetailsViewController

@synthesize str_CustumImage,CustumthumbnailImage,isFromPushCamera;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
//    [atePicker setLocale:locale];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived:) name:@"TestNotification" object:nil];
    
    NSDate *currentDate = [NSDate date];
    atePicker.minimumDate = currentDate;
    
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
    
    NSLog(@"CustumthumbnailImage --- >>> >> %@",CustumthumbnailImage);
    
    Picker_View.hidden = YES;

    arr_indexPaths=[[NSMutableArray alloc]init];
    arr_selectedfriendName=[[NSMutableArray alloc]init];
    arr_SelectedFriendData=[[NSMutableArray alloc]init];
    
    arr_indexPaths=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedValueArray"]];
    arr_SelectedFriendData=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"Dic"]];
    
   // NSLog(@"%@",arr_SelectedFriendData);
  
    for (int i=0; i<[arr_SelectedFriendData count]; i++)
    {
        str_selecteedFriendID = [[arr_SelectedFriendData valueForKey:@"id"] componentsJoinedByString:@","];
    }
  //  NSLog(@"%@",str_selecteedFriendID);
    
    arr_selectedfriendName = [arr_SelectedFriendData valueForKey:@"username"];

   
        [self  AddNewCustomCategoryInScrollView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(ClearData:)
//                                                 name:@"Pushcontrollercustum"
//                                               object:nil];
//    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(imagedata:)
//                                                 name:@"ImageVCPoppedcustum"
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(recvData:)
//                                                 name:@"FirstVCPoppedcustum"
//                                               object:nil];
    
    [AppManager sharedManager].navCon = self.navigationController;
    
    str_USERID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];

    imageVW_uploadImageVW.layer.cornerRadius=imageVW_uploadImageVW.frame.size.height/2;
    imageVW_uploadImageVW.clipsToBounds = YES;
    
    txtVW_description.placeholder = @"Description";
    txtVW_description.font=[UIFont fontWithName:@"System" size:18.0];
    txtVW_description.placeholderColor = [UIColor  lightGrayColor];
    
    UIColor *color = [UIColor lightGrayColor];

    txt_challengeName.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Challenge Name" attributes:@{NSForegroundColorAttributeName: color}];
    txt_duration.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Duration" attributes:@{NSForegroundColorAttributeName: color}];

    imageVW_ThumbNail.layer.cornerRadius=imageVW_ThumbNail.frame.size.height/2;
    imageVW_ThumbNail.clipsToBounds = YES;
    


}

-(void)viewDidAppear:(BOOL)animated
{
    if (CustumthumbnailImage == nil && CustumthumbnailImage == NULL)
    {
        imageVW_ThumbNail.image=[UIImage imageNamed:@"upload-video-icon2"];
        
    }
    else
    {
        imageVW_ThumbNail.image=CustumthumbnailImage;
        
    }

}
//- (void) ClearData:(NSNotification *) notification
//{
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"IndexSelectedstringcustum"];
//}
//
//- (void) recvData:(NSNotification *) notification
//{
//    NSDictionary* userInfo = notification.userInfo;
//    str_encripedString = [userInfo objectForKey:@"VideoStringcameraOnecustum"];
//    
//}
//- (void) imagedata:(NSNotification *) notification
//{
//    NSDictionary* userInfo = notification.userInfo;
//    CustumthumbnailImage = [userInfo valueForKey:@"Imagethumbnailcustum"];
//    NSLog(@"%@",CustumthumbnailImage);
//    
//    if (isStringEmpty(str_encripedString))
//    {
//        imageVW_ThumbNail.image=[UIImage imageNamed:@"upload-video-icon2"];
//
//    }
//    else
//    {
//        imageVW_ThumbNail.image=CustumthumbnailImage;
//    }
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender
{
    if (isFromPushCamera == YES)
    {
        isFromPushCamera=NO;
        
        ChangleVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Changle"];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
    else
    {
    [self.navigationController popViewControllerAnimated:YES];
    }
    txt_duration.text=nil;
    txt_challengeName.text=nil;
    txtVW_description.text=nil;
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedValueArray"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Dic"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FromCustumChallenge"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txt_challengeName)
    {
        [txt_challengeName  resignFirstResponder];
    }

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
//    if (textView==txtVW_challegeTo)
//    {
//        SelectFriendVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectFriendVC"];
//        [self.navigationController pushViewController:vc1 animated:YES];
//
//    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [txtVW_description resignFirstResponder];
        [txtVW_challegeTo resignFirstResponder];

        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

#pragma mark  Touch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txt_challengeName resignFirstResponder];
    [txt_duration resignFirstResponder];
    [txtVW_challegeTo resignFirstResponder];
    [txtVW_description resignFirstResponder];
}

- (IBAction)ADDvideo:(id)sender
{
    
    arr_indexPaths=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedValueArray"]];
    
    if (isStringEmpty(str_CustumImage))
    {
        alert(@"Message", @"Please Record Video First.");
    }
   else if (isStringEmpty([NSString stringWithFormat:@"%@",txt_challengeName.text]))
    {
        txt_challengeName.text=nil;
        alert(@"Message", @"Please Enter Your Challenge Name.");
        [txt_challengeName becomeFirstResponder];
    }
//    else if (isStringEmpty([NSString stringWithFormat:@"%@",txt_duration.text]))
//    {
//        alert(@"Message", @"Please Enter Duration.");
//        [txt_duration becomeFirstResponder];
//    }
    else if (txtVW_description.text.length==0)
    {
        alert(@"Message", @"Please Enter Description.");
        [txtVW_description becomeFirstResponder];
    }
    else if (arr_indexPaths.count==0)
    {
         alert(@"Message", @"Tag atleast one friend.");
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

-(void)WebserviceAddVideo
{
    
  // http://dev414.trigma.us/krust/Webservices/videoupload?user_id=782&Video_name=abc.mp4&description=abc&challenge_name=abc&challenge_to=1,2
    
    if (isStringEmpty(str_selecteedFriendID))
    {
        str_selecteedFriendID=@" ";
    }
    if (isStringEmpty(str_USERID))
    {
        str_USERID=@" ";
    }
    if (isStringEmpty(str_CustumImage))
    {
        str_CustumImage=@" ";

    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"user_id" : str_USERID,
                                         @"Video_name" : str_CustumImage,
                                         @"description" : txtVW_description.text,
                                         @"challenge_name" : txt_challengeName.text,
                                         @"challenge_to" : str_selecteedFriendID,
                                         @"post_valid" : @""
                                         
                                        }];
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,kvideoupload];

    
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

                 ChangleVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Changle"];
                 [self.navigationController pushViewController:vc1 animated:YES];
                 
                 txt_duration.text=nil;
                 txt_challengeName.text=nil;
                 txtVW_description.text=nil;
                 
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
         
         alert(@"Alert", @"Something went wrong.");

     }];
    
}

- (IBAction)TappedOnVideoAdd:(id)sender
{
    MYVideoADDCameraViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"MYVideoADDCamera"];
    [self.navigationController pushViewController:vc1 animated:YES];
    
//    NSString * storyboardName = @"Main";
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"MYVideoADDCamera"];
//    [self presentViewController:vc animated:YES completion:nil];
    
}
- (IBAction)OpenDatePicker:(id)sender
{
    [txtVW_challegeTo resignFirstResponder];
    [txt_challengeName resignFirstResponder];
    [txtVW_description resignFirstResponder];

    Picker_View.hidden = NO;
    txt_duration.text = [self formatDate:atePicker.date];
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionTransitionFlipFromLeft
                     animations:^
     {
         if (IS_IPHONE_6)
         {
             CGRect frame = Picker_View.frame;
             frame.origin.y = 450;
             frame.origin.x = 0;
             Picker_View.frame = frame;
         }else{
             CGRect frame = Picker_View.frame;
             frame.origin.y = 400;
             frame.origin.x = 0;
             Picker_View.frame = frame;
         }
     }
                     completion:^(BOOL finished)
     {
   //      NSLog(@"Completed");
         
     }];
}

-(IBAction)Cancel_bn:(id)sender
{


    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionTransitionFlipFromLeft
                     animations:^
     {
         if (IS_IPHONE_6)
         {
             CGRect frame = Picker_View.frame;
             frame.origin.y = 667;
             frame.origin.x = 0;
             Picker_View.frame = frame;
         }
         else
         {
             CGRect frame = Picker_View.frame;
             frame.origin.y = 568;
             frame.origin.x = 0;
             Picker_View.frame = frame;
         }
         
     }
                     completion:^(BOOL finished)
     {
   //      NSLog(@"Completed");
         
     }];
    
}
- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd HH:mm "];
    
    
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}
-(IBAction)date_picker_btn:(id)sender
{
    [txtVW_challegeTo resignFirstResponder];
    [txt_challengeName resignFirstResponder];
    [txtVW_description resignFirstResponder];
    
    txt_duration.text = [self formatDate:atePicker.date];

    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionTransitionFlipFromLeft
                     animations:^
     {
         if (IS_IPHONE_6)
         {
             CGRect frame = Picker_View.frame;
             frame.origin.y = 667;
             frame.origin.x = 0;
             Picker_View.frame = frame;
         }
         else
         {
             CGRect frame = Picker_View.frame;
             frame.origin.y = 568;
             frame.origin.x = 0;
             Picker_View.frame = frame;
         }
         
     }
            completion:^(BOOL finished)
     {
 //        NSLog(@"Completed");
         
     }];

}


-(void)AddNewCustomCategoryInScrollView
{
    
    for (UIView *v in [categoryScrollView subviews]) {
        [v removeFromSuperview];
    }
    int x_value=5;
    int y_value=5;
    
    for(int index=0;index<[arr_selectedfriendName count];index++)
    {
        
        GridView=[[UIImageView alloc]init];
        GridView.backgroundColor=[UIColor lightGrayColor];
        GridView.layer.cornerRadius=10.0;
        GridView.clipsToBounds=YES;
        [GridView setUserInteractionEnabled:YES];
        
        UILabel * lbl_name=[[UILabel alloc]init];
        [GridView addSubview:lbl_name];
        
        NSString * title=[NSString stringWithFormat:@"%@",[arr_selectedfriendName objectAtIndex:index]];
        
        CGSize computedSize = [title sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(130, 10000 ) lineBreakMode:NSLineBreakByWordWrapping];
        
        
        lbl_name.text=[NSString stringWithFormat:@"%@",title];
        lbl_name.frame = CGRectMake(5, 2,computedSize.width+10 , 30);
        [lbl_name sizeToFit];
        lbl_name.textColor=[UIColor darkGrayColor];
        lbl_name.textAlignment=NSTextAlignmentLeft;
        lbl_name.lineBreakMode = NSLineBreakByWordWrapping;
        lbl_name.backgroundColor=[UIColor clearColor];
        
        UIButton * btn_delete=[UIButton buttonWithType:UIButtonTypeCustom];
        btn_delete.frame=CGRectMake(lbl_name.frame.size.width+14, 2, 25, 25);
        [btn_delete setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        btn_delete.tag=index;
        [btn_delete addTarget:self action:@selector(DeleteNameAddedGroup:) forControlEvents:UIControlEventTouchUpInside];
        
        [GridView addSubview:btn_delete];
  //      NSLog(@"lbl frame...%@",NSStringFromCGRect(lbl_name.frame));
        
        GridView.frame=CGRectMake(x_value, y_value,lbl_name.frame.size.width+40, 30);
        [categoryScrollView addSubview:GridView];
        
        if((x_value+GridView.frame.size.width)>=categoryScrollView.frame.size.width)
        {
            x_value=5;
            y_value=y_value+GridView.frame.size.height+10;
        }
        
        GridView.frame=CGRectMake(x_value, y_value,lbl_name.frame.size.width+40, 30);
        x_value=x_value+GridView.frame.size.width+10;
        
        [GridView setImage:[UIImage imageNamed:@"delete_bg.png"]];
        
        [categoryScrollView setContentSize:CGSizeMake(categoryScrollView.frame.size.width, y_value+50)];
        
    }
    
}

-(void)DeleteNameAddedGroup:(UIButton*)delete
{
    arr_selectedfriendName=[arr_selectedfriendName mutableCopy];
    
//    NSLog(@" Before %@",arr_indexPaths);

    if([arr_selectedfriendName count]>0)
    {
        [arr_selectedfriendName removeObjectAtIndex:delete.tag];
        
//        for (int i=0; arr_indexPaths.count>i; i++)
//        {
//            if ([arr_indexPaths containsObject:[NSString stringWithFormat:@"%ld",(long)delete.tag]])
//            {
                [arr_indexPaths removeObjectAtIndex:delete.tag];
//            }
//
//        }
  //      NSLog(@" after %@",arr_indexPaths);
        
        [[NSUserDefaults standardUserDefaults] setValue:arr_indexPaths forKey:@"SelectedValueArray"];

       
        
        NSString *PersonID = [[arr_SelectedFriendData objectAtIndex:delete.tag]valueForKey:@"id"];
        
        for (int i=0; i<[arr_SelectedFriendData count]; i++)
        {
            if ([[[arr_SelectedFriendData objectAtIndex:i]valueForKey:@"id"] isEqualToString:PersonID])
            {
                [arr_SelectedFriendData removeObjectAtIndex:i];
            }
            
        }
       [[NSUserDefaults standardUserDefaults]setValue:arr_SelectedFriendData forKey:@"Dic"];
        
        
        // NSLog(@"%@   %lu",chosenImages,(unsigned long)[chosenImages count]);
        
        
        [self AddNewCustomCategoryInScrollView];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [txt_challengeName resignFirstResponder];
    [txtVW_description resignFirstResponder];

}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (IBAction)TappedONCamera:(id)sender
{
    
//    PopupSelectTeam.hidden=YES;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"Library"];
    [actionSheet addButtonWithTitle:@"Camera"];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet showInView:self.view];
   
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
            str_CustumImage=nil;
            imageVW_ThumbNail.image=[UIImage imageNamed:@"upload-video-icon2"];
            [self.navigationController pushViewController:vc1 animated:YES];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FromCustumChallenge"];
            
        }
            break;
            
        case 2:
        {
            
            
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)TappedOnTagFriends:(id)sender
{
    if (isStringEmpty(str_CustumImage))
    {
        alert(@"Message", @"Please Record a Video First.");
    }
    else if (isStringEmpty([NSString stringWithFormat:@"%@",txt_challengeName.text]))
    {
        txt_challengeName.text=nil;
        alert(@"Message", @"Please Enter Your Challenge Name.");
        [txt_challengeName becomeFirstResponder];
    }
     else if (txtVW_description.text.length==0)
    {
        alert(@"Message", @"Please Enter Description.");
        [txtVW_description becomeFirstResponder];
    }
    else
    {
    SelectFriendVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectFriend"];
    [self.navigationController pushViewController:vc1 animated:YES];
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
      //      NSLog(@"videopath of your mp4 file = %@", videoPath);  // PATH OF YOUR .mp4 FILE
      
            exportSession.outputFileType = AVFileTypeMPEG4;
            
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                
                switch ([exportSession status]) {
                        
                    case AVAssetExportSessionStatusFailed:
                        
               //         NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                        
                        break;
                        
                    case AVAssetExportSessionStatusCancelled:
                        
      //                  NSLog(@"Export canceled");
                        
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
                 //               NSLog(@"couldn't generate thumbnail, error:%@", error);
                            }
                            
                            else
                                
                            {
//                                NSLog(@"%@",im);
                                CustumthumbnailImage=[UIImage imageWithCGImage:im];
//                                NSLog(@"--cameraVC-%@",CustumthumbnailImage);
                            }
                        };
                        CGSize maxSize = CGSizeMake(320, 180);
                        generator.maximumSize = maxSize;
                        
                        [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
                        
                        
                        NSData  *plainData = [NSData dataWithContentsOfFile:videoPath];
                        
                      //  NSLog(@"Export completed");
                        
                        str_encripedString =[plainData base64EncodedStringWithOptions:0];
                        str_CustumImage=str_encripedString;
                     //   NSLog(@" encrept data %@", str_CustumImage);
                    
                    }
                        break;
                    default:
                        break;
                        
                }
            }];
        }
        
    }
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
