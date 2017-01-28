//
//  tagTeammemberTableViewCell.m
//  Krust
//
//  Created by Pankaj Sharma on 08/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import "tagTeammemberTableViewCell.h"
#import "AppManager.h"
#import "Haneke.h"

@implementation tagTeammemberTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)loaditemwithAdvertListArray:(NSMutableArray *)array_notifications
{
    
    _imageVW_user.layer.cornerRadius=_imageVW_user.frame.size.height/2;
    _imageVW_user.clipsToBounds = YES;
    
    _lbbl_UserName.adjustsFontSizeToFitWidth=YES;
    
    _lbbl_UserName.text=[AppManager getCurrectValue:[NSString stringWithFormat:@"%@",[array_notifications valueForKey:@"username"]]];
    NSString *imagestr =[NSString stringWithFormat:@"%@",[array_notifications valueForKey:@"profile_image"]];
    [_imageVW_user hnk_setImageFromURL: [NSURL URLWithString:imagestr]];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
