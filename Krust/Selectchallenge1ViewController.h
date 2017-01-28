//
//  Selectchallenge1ViewController.h
//  Krust
//
//  Created by Pankaj Sharma on 24/08/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"

@interface Selectchallenge1ViewController : UIViewController<UIActionSheetDelegate>
{
    NSTimer * CountDowntimer;
    int minit,sec,hour;
    IBOutlet UILabel *lbl_days;
    IBOutlet UILabel *lbl_hours;
    IBOutlet UILabel *lbl_minitus;
    BOOL timerFlasg;
    NSString *str_USERID;
    UIActivityIndicatorView *spinner;
    NSMutableArray *arr_PostData;
    NSString *str_encripedString;
    IBOutlet PlaceholderTextView *txtVW_Details;
    NSString *strr_PostID;
    NSString *PostID;
    NSInteger Indexfoarray;
    NSString  * IndexValue;
    NSString *indexradioselected;
    UIImage * imagethumbnailSelect;

    IBOutlet UIView *view_PopUp;
    
    IBOutlet UIView *PopupSelectTeam;
    IBOutlet UIButton *btn_postasindiviual;
    IBOutlet UIButton *btn_postasteam;
    IBOutlet UIButton *btn_cancel;
    IBOutlet UIImageView *backgroundimageVW_buttons;
    NSString * str_IsPostedAsGroup;
    NSInteger Statusofnotification;
    NSString * encryptedString;
    BOOL OnlyIndiviualChallenge;
    BOOL isFromLibary;
}
@property (strong, nonatomic) IBOutlet UITableView *tableVW_challenges;
@property(nonatomic,strong)UIImage * imagethumbnailSelect;
@property(nonatomic,strong)NSString * str_encripedString;
@property(nonatomic,strong)NSString * str_GroupID;
@property(nonatomic,strong)NSString * str_membersIDs;




@end
