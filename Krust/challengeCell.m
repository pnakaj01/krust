//
//  challengeCell.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "challengeCell.h"
#import "AppManager.h"

@implementation challengeCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_Incoming_outcomingddata
{
    
    if([[arr_Incoming_outcomingddata valueForKey:@"challenge_status"] isEqualToString:@"Accepted"] && [[arr_Incoming_outcomingddata valueForKey:@"type"] isEqualToString:@"in"])
    {
        _btn_AcceptChallenge.hidden=YES;
        _btn_RejectChallenge.hidden=YES;
        _imageVW_tick.image=[UIImage imageNamed:@"tick-green"];
        _lbl_PendingOrAccepted.textColor=[UIColor colorWithRed:49.0/255.0 green:117.0/255.0 blue:41.0/255.0 alpha:1];

    }
    else if ([[arr_Incoming_outcomingddata valueForKey:@"challenge_status"] isEqualToString:@"Pending"] && [[arr_Incoming_outcomingddata valueForKey:@"type"] isEqualToString:@"in"])
    {
        [_btn_AcceptChallenge setImage:[UIImage imageNamed:@"accept"] forState:UIControlStateNormal];
        _imageVW_tick.image=[UIImage imageNamed:@"tick-red"];
        _lbl_PendingOrAccepted.textColor=[UIColor redColor];

    }
    else if ([[arr_Incoming_outcomingddata valueForKey:@"challenge_status"] isEqualToString:@"Rejected"] && [[arr_Incoming_outcomingddata valueForKey:@"type"] isEqualToString:@"in"])
    {
        _btn_AcceptChallenge.hidden=YES;
        _btn_RejectChallenge.hidden=YES;
        _imageVW_tick.image=[UIImage imageNamed:@"tick-red"];
        _lbl_PendingOrAccepted.textColor=[UIColor redColor];
        
    }
    
    if([[arr_Incoming_outcomingddata valueForKey:@"challenge_status"] isEqualToString:@"Accepted"] && [[arr_Incoming_outcomingddata valueForKey:@"type"] isEqualToString:@"out"])
    {
        _btn_AcceptChallenge.hidden=YES;
        _btn_RejectChallenge.hidden=YES;
        _imageVW_tick.image=[UIImage imageNamed:@"tick-green"];
        _lbl_PendingOrAccepted.textColor=[UIColor colorWithRed:49.0/255.0 green:117.0/255.0 blue:41.0/255.0 alpha:1];

    }
    else if ([[arr_Incoming_outcomingddata valueForKey:@"challenge_status"] isEqualToString:@"Pending"] && [[arr_Incoming_outcomingddata valueForKey:@"type"] isEqualToString:@"out"])
    {
        _btn_AcceptChallenge.hidden=YES;
        _btn_RejectChallenge.hidden=YES;
        _imageVW_tick.image=[UIImage imageNamed:@"tick-red"];
        _lbl_PendingOrAccepted.textColor=[UIColor redColor];

    }
    else if ([[arr_Incoming_outcomingddata valueForKey:@"challenge_status"] isEqualToString:@"Rejected"] && [[arr_Incoming_outcomingddata valueForKey:@"type"] isEqualToString:@"out"])
    {
        _btn_AcceptChallenge.hidden=YES;
        _btn_RejectChallenge.hidden=YES;
        _imageVW_tick.image=[UIImage imageNamed:@"tick-red"];
        _lbl_PendingOrAccepted.textColor=[UIColor redColor];
        
    }
    
    
    _lbl_message.minimumScaleFactor=YES;
    _lbl_message.adjustsFontSizeToFitWidth=YES;

    _lbl_message.text=[AppManager getCurrectValue:[arr_Incoming_outcomingddata valueForKey:@"show_massage"]];
    _lbl_time.text=[AppManager getCurrectValue:[arr_Incoming_outcomingddata valueForKey:@"time"]];
    _lbl_challenge_status.text=[AppManager getCurrectValue:[arr_Incoming_outcomingddata valueForKey:@"challenge_status"]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
