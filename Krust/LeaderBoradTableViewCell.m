//
//  LeaderBoradTableViewCell.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "LeaderBoradTableViewCell.h"
#import "AppManager.h"
#import "Haneke.h"



@implementation LeaderBoradTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_likedata
{
    NSString *str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    if ([[arr_likedata valueForKey:@"id"]isEqualToString:str_userID])
    {
      //  NSLog(@"user exist");
        _btn_follow.hidden=YES;
    }
    else
    {
    
    NSInteger Status=[[arr_likedata valueForKey:@"follow"] integerValue];
        if(Status ==1)
        {
            [_btn_follow setImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
        }
        else
        {
            [_btn_follow setImage:[UIImage imageNamed:@"btn-follow"] forState:UIControlStateNormal];
            
        }
    }
    
    _imageVW_username.layer.cornerRadius=_imageVW_username.frame.size.height/2;
    _imageVW_username.clipsToBounds = YES;
    
    _lbl_username.text=[AppManager getCurrectValue:[arr_likedata valueForKey:@"username"]];
    
    _lbl_rank.text=[AppManager getCurrectValue:[NSString stringWithFormat:@"#%@",[arr_likedata valueForKey:@"rank"]]];
    _lbl_likess.text=[AppManager getCurrectValue:[NSString stringWithFormat:@"%@ Likes",[arr_likedata valueForKey:@"count"]]];
    
    NSString *imagestr = [NSString stringWithFormat:@"%@",[arr_likedata valueForKey:@"profile_image"]];
    [_imageVW_username hnk_setImageFromURL: [NSURL URLWithString:imagestr]];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
