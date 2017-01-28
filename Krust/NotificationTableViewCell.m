//
//  NotificationTableViewCell.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "AppManager.h"
#import "Haneke.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}
-(void)loaditemwithAdvertListArray:(NSMutableArray *)array_notifications
{
    if ([[array_notifications valueForKey:@"type_status"] isEqualToString:@"group"])
    {
        
        NSInteger Status=[[array_notifications valueForKey:@"accept"]integerValue] ;

        if (Status==0)
        {
            _btn_accpt.hidden=NO;
            _btn_reject.hidden=NO;
   
        }
        else if (Status==2)
        {
            _btn_accpt.hidden=YES;
            _btn_reject.hidden=YES;
        }
        else
        {
            _btn_accpt.hidden=YES;
            _btn_reject.hidden=YES;
        }
        
    }
    
    else
    {
        _btn_accpt.hidden=YES;
        _btn_reject.hidden=YES;
    }
    
    _imageVW_user.layer.cornerRadius=_imageVW_user.frame.size.height/2;
    _imageVW_user.clipsToBounds = YES;
    
    _lbl_notification.adjustsFontSizeToFitWidth=YES;
    
    _lbl_notification.text=[AppManager getCurrectValue:[NSString stringWithFormat:@"%@",[array_notifications valueForKey:@"show_massage"]]];
    _lbl_time.text=[AppManager getCurrectValue:[NSString stringWithFormat:@"%@",[array_notifications valueForKey:@"time"]]];
    
    NSString *imagestr =[NSString stringWithFormat:@"%@",[array_notifications valueForKey:@"profile_image"]];
    [_imageVW_user hnk_setImageFromURL: [NSURL URLWithString:imagestr]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
