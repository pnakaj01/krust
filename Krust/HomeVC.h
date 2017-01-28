//
//  HomeVC.h
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface HomeVC : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
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
    NSArray * arr_dummy;
    UIRefreshControl *RefreshControl;
    
    

}
- (IBAction)DoneVideoAction:(id)sender;
- (IBAction)SegmentAction:(id)sender;

@end
