//
//  EditteamVC.h
//  Krust
//
//  Created by Pankaj Sharma on 10/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"


@interface EditteamVC : UIViewController<UIActionSheetDelegate>
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
@property(nonatomic,strong)NSString * str_groupID;

@end
