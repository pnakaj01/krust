//
//  SelectchallengeVC.h
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectchallengeVC : UIViewController
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
    NSString * strrr_PostID;
    NSInteger Indexfoarray;
    NSString * strr_PostID;
    IBOutlet UIView *View_popup;
    NSInteger Statusofnotification;
}
@property (strong, nonatomic) IBOutlet UITableView *tableVW_challenges;

@end
