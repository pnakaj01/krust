//
//  NotificationTableViewCell.h
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell
-(void)loaditemwithAdvertListArray:(NSMutableArray *)array_notifications;
@property (strong, nonatomic) IBOutlet UIImageView *imageVW_user;
@property (strong, nonatomic) IBOutlet UILabel *lbl_notification;
@property (strong, nonatomic) IBOutlet UILabel *lbl_time;

@property (strong, nonatomic) IBOutlet UIButton *btn_Name;

@property (strong, nonatomic) IBOutlet UIButton *btn_accpt;

@property (strong, nonatomic) IBOutlet UIButton *btn_reject;

@end
