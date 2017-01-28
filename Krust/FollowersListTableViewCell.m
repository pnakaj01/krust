//
//  FollowersListTableViewCell.m
//  Krust
//
//  Created by Pankaj Sharma on 16/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import "FollowersListTableViewCell.h"
#import "AppManager.h"
#import "Haneke.h"

@implementation FollowersListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_likedata
{
    NSString *str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    if ([[arr_likedata valueForKey:@"id"]isEqualToString:str_userID])
    {
        _btn_follow.hidden=YES;

    }
    else
    {
        NSInteger Status=[[arr_likedata valueForKey:@"follow_status"] integerValue];
        
        if(Status ==1)
        {
            [_btn_follow setImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
        }
        else
        {
            [_btn_follow setImage:[UIImage imageNamed:@"btn-follow"] forState:UIControlStateNormal];
        }
    }
    
    _imageVW_user.layer.cornerRadius=_imageVW_user.frame.size.height/2;
    _imageVW_user.clipsToBounds = YES;
    
    _lbl_user_name.text=[AppManager getCurrectValue:[arr_likedata valueForKey:@"username"]];
    
    NSString *imagestr1 =[NSString stringWithFormat:@"%@",[arr_likedata valueForKey:@"profile_image"]];
    [_imageVW_user hnk_setImageFromURL:[NSURL URLWithString:imagestr1]];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
