//
//  RegisterVC.h
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterVC : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    IBOutlet UITextField *txt_firstname;
    IBOutlet UITextField *txt_lastname;
    IBOutlet UITextField *txt_username;
    IBOutlet UITextField *txt_email;
    IBOutlet UITextField *txt_password;
    IBOutlet UITextField *txt_confirmPassword;
    UIImage *obj_imagePick;
    NSData *dataImage;
    NSString *encryptedString;
    IBOutlet UIImageView *imageViewProfile;
    
    IBOutlet UIImageView *imageVW_plusIcon;
    NSString * str_facebookimage;
    NSString * Fcaebook_id;
    NSMutableArray * arr_Facebookdata;
    NSString * FacebookImageString;
    NSString * FacebookNameString;
    NSString * FacebookIdString;
    NSString * FacebookEmailString;
    NSString * FacebookFirstName;
    NSString * FacebookLastName;
    
    BOOL iSFromRegisterFacebookLogin;
    NSString * str_deviceToken;
    
}
@property(nonatomic,strong)NSMutableArray * FaceBookData;
@property(nonatomic,assign)BOOL isFromFacebookSignIN;

@end
