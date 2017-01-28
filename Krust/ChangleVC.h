//
//  ChangleVC.h
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangleVC : UIViewController
{
    
    IBOutlet UITableView *tableVW_challenge;
    NSMutableArray * arr_IncomingMessages;
    NSString * str_userID;
    IBOutlet UISegmentedControl *segment;
    IBOutlet UIView *view_popup;
    IBOutlet UILabel *lbl_messagepopup;
    NSString * StatusofChallenge;
    NSInteger Statusofnotification;
    NSString * str_UserIdMember;
    NSString * str_VideoID;

}

@end
