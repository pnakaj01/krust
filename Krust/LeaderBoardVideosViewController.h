//
//  LeaderBoardVideosViewController.h
//  Krust
//
//  Created by Pankaj Sharma on 08/09/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LeaderBoardVideosViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
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
    NSInteger Statusofnotification;
    IBOutlet UIView *View_popup;
    
}
- (IBAction)DoneVideoAction:(id)sender;
- (IBAction)SegmentAction:(id)sender;
@property(nonatomic,strong)NSString * str_post_id;

@end
