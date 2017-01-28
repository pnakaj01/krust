//
//  NotificationDetailVC.h
//  Krust
//
//  Created by Pankaj Sharma on 22/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface NotificationDetailVC : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    IBOutlet UITableView *table_Post;
    NSMutableArray *arr_PostData;
    IBOutlet UIWebView *videoView;
    MPMoviePlayerController *MoviePlayer;
    NSString *str_USERID;
    NSString *str_POSTID;
    NSString *like_status;
    IBOutlet UIView *Movie_View;
    NSInteger page_count;
    IBOutlet UISegmentedControl *segment;
    UIActivityIndicatorView *spinner;
    NSInteger Numberofpages;
    BOOL isFromScrollPage;
    NSInteger INDEXTAG;
    
    IBOutlet UIView *View_popup;
    NSInteger Statusofnotification;
    
}
- (IBAction)Back:(id)sender;
- (IBAction)DoneVideoAction:(id)sender;
- (IBAction)SegmentAction:(id)sender;
@property(nonatomic,retain)NSString * str_VideoID;

@end
