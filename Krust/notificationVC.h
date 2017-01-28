//
//  notificationVC.h
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notificationVC : UIViewController
{
    
    IBOutlet UIButton *btn_back;
    IBOutlet UITableView *tablevW_notification;
    IBOutlet UISegmentedControl *segment;
    NSString *str_userID;
    NSMutableArray *arr_notificationns;
    NSInteger page_count;
    UIActivityIndicatorView *spinner;
    NSInteger Numberofpages;
    BOOL isFromScrollPage;
    IBOutlet UIView *View_PoPUP;
    BOOL DummyCheck;
    NSInteger Statusofnotification;
}
- (IBAction)TappedOnBack:(id)sender;
@property(nonatomic,assign)BOOL isFromSetting;
@property(nonatomic,assign)NSInteger StatusNotification;


@end
