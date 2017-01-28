//
//  LeaderBoardVC.h
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LeaderBoardVC : UIViewController
{
    IBOutlet UITableView *tableVW_leaderBoard;
    NSMutableArray *arr_Leaderboarddata;
    IBOutlet UISegmentedControl *segment;
    NSString *str_userID;
    NSString *follow_status;
    NSString *str_followfriendID;
    MPMoviePlayerController *MoviePlayer;
    IBOutlet UIView *Movie_View;
    IBOutlet UIView *view_popup;
    IBOutlet UILabel *lbl_popupMessage;
    NSInteger Statusofnotification;
    BOOL isButtonSelected;

}
- (IBAction)segmentAction:(id)sender;

@end
