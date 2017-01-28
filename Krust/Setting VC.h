//
//  Setting VC.h
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface Setting_VC : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    
    IBOutlet UIButton *btn_done;
    IBOutlet UILabel *lbl_name;
    IBOutlet UIScrollView *scrollVW_setting;
    IBOutlet UILabel *lbl_email;
    IBOutlet UIImageView *imageViewProfile;
    UIImage *obj_imagePick;
    NSData *dataImage;
    NSString *encryptedString;
    BOOL isFromMethod;
    BOOL isFromLogout;
    IBOutlet UITextField *lbl_username;
    IBOutlet UIButton *btn_submit;
    IBOutlet UIButton *btn_facebookconnect;
    IBOutlet UILabel *lbl_connectTOFacebook;
    NSInteger Statusofnotification;

}
- (IBAction)TappedONCamera:(id)sender;
- (IBAction)DoneAction:(id)sender;
- (IBAction)TappedOnSubmit:(id)sender;
- (IBAction)TappedOnViewProfile:(id)sender;

@end
