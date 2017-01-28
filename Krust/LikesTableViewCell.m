//
//  LikesTableViewCell.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "LikesTableViewCell.h"
#import "AppManager.h"
#import "Haneke.h"

@implementation LikesTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}
-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_likedata
{
    NSString *str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];

    
    
    if ([[arr_likedata valueForKey:@"id"]isEqualToString:str_userID])
    {
        
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
    
    _imageVW_user.layer.cornerRadius=_imageVW_user.frame.size.height/2;
    _imageVW_user.clipsToBounds = YES;
 
    _lbl_user_name.text=[AppManager getCurrectValue:[arr_likedata valueForKey:@"username"]];
    
    
    NSString *imagestr = [NSString stringWithFormat:@"%@",[arr_likedata valueForKey:@"profile_image"]];
    [_imageVW_user hnk_setImageFromURL: [NSURL URLWithString:imagestr]];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
