//
//  challengeCell.h
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface challengeCell : UITableViewCell
{
    int StatusOFchallenge;
}
@property (strong, nonatomic) IBOutlet UILabel *lbl_message;
@property (strong, nonatomic) IBOutlet UIImageView *imageview_side;
@property (strong, nonatomic) IBOutlet UILabel *lbl_time;
-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_Incoming_outcomingddata;
@property (strong, nonatomic) IBOutlet UILabel *lbl_challenge_status;
@property (strong, nonatomic) IBOutlet UIButton *btn_AcceptChallenge;
@property (strong, nonatomic) IBOutlet UIImageView *imageVW_tick;
@property (strong, nonatomic) IBOutlet UILabel *lbl_PendingOrAccepted;
@property (strong, nonatomic) IBOutlet UIButton *btn_RejectChallenge;

@end
