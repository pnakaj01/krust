//
//  SelectteamTableViewCell.m
//  Krust
//
//  Created by Pankaj Sharma on 08/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import "SelectteamTableViewCell.h"
#import "AppManager.h"
#import "Haneke.h"


@implementation SelectteamTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_likedata
{
    
//    NSLog(@"%@",arr_likedata);
    _imageVW_user.layer.cornerRadius=_imageVW_user.frame.size.height/2;
    _imageVW_user.clipsToBounds = YES;
    
    _lbl_user_name.text=[AppManager getCurrectValue:[arr_likedata valueForKey:@"group_name"]];
    
    NSString *imagestr =[NSString stringWithFormat:@"%@",[arr_likedata valueForKey:@"image"]];
    [_imageVW_user hnk_setImageFromURL: [NSURL URLWithString:imagestr]];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
