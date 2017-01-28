//
//  AddTeamVC.h
//  Krust
//
//  Created by Pankaj Sharma on 06/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"

@interface AddTeamVC : UIViewController<UIActionSheetDelegate>
{
    IBOutlet UITextField *txt_subject;
    IBOutlet PlaceholderTextView *txt_description;
    UIImage *obj_imagePick;
    NSData *dataImage;
    NSString *encryptedString;
    IBOutlet UIImageView *imageViewProfile;
    IBOutlet UIImageView *imageVW_plusIcon;
    NSString * str_userID;
    NSInteger Statusofnotification;

}
@end
