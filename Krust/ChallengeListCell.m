//
//  ChallengeListCell.m
//  Krust
//
//  Created by Pankaj Sharma on 8/17/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "ChallengeListCell.h"
#import "AppManager.h"

@implementation ChallengeListCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_VideoPost
{
    
    if ([[arr_VideoPost valueForKey:@"upload_by"] isEqualToString:@"admin"])
    {
        _lbl_challengeName.textColor=[UIColor blackColor];
        _lbl_challengeDescription.textColor=[UIColor blackColor];

    }
    
    _lbl_PostEndDate.adjustsFontSizeToFitWidth=YES;
    _lbl_challengeName.text=[AppManager getCurrectValue:[arr_VideoPost valueForKey:@"challenge_name"]];
    _lbl_challengeDescription.text=[AppManager getCurrectValue:[arr_VideoPost valueForKey:@"description"]];
    _lbl_PostEndDate.text=[AppManager getCurrectValue:[arr_VideoPost valueForKey:@"post_valid"]];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
