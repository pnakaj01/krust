//
//  Profile VC.h
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface Profile_VC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    
    IBOutlet UITableView *tableVW_profile;
    NSMutableArray *arr_PostData;
    MPMoviePlayerController *MoviePlayer;
    NSString *str_USERID;
    NSString *str_POSTID;
    NSString *like_status;
    IBOutlet UIView *Movie_View;
    BOOL isSoloTApped;
    IBOutlet UIButton *btn_solo;
    IBOutlet UIButton *btn_challenge;
    IBOutlet UIImageView *user_profileImage;
    IBOutlet UILabel *lbl_post;
    IBOutlet UILabel *lbl_followers;
    IBOutlet UILabel *lbl_following;
    IBOutlet UILabel *lbl_username;
    BOOL isFromScrollPage;
    NSInteger page_count;
    NSInteger Numberofpages;
    UIActivityIndicatorView *spinner;
    int SegmentSelection;
    IBOutlet UIView *View_popup;
    NSString *  ProfileId;
    NSString * FollowStatus;
    IBOutlet UIButton *btn_follow;
    NSMutableArray * arr_UserData;
    NSInteger INDEXTAG;
    NSInteger Statusofnotification;


}
- (IBAction)back:(id)sender;
- (IBAction)DoneVideoAction:(id)sender;
- (IBAction)SegmentAction:(id)sender;
@property(nonatomic,strong)NSString *str_post_id;
@end
