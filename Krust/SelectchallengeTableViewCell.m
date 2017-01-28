//
//  SelectchallengeTableViewCell.m
//  Krust
//
//  Created by Pankaj Sharma on 07/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import "SelectchallengeTableViewCell.h"
#import "AppManager.h"

@implementation SelectchallengeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_VideoPost
{
    if ([[arr_VideoPost valueForKey:@"upload_by"] isEqualToString:@"admin"])
    {
        _lbl_challengeNameSelect.textColor=[UIColor blackColor];
        _lbl_challengeDescriptionSelect.textColor=[UIColor blackColor];

    }
    _lbl_PostEndDate.adjustsFontSizeToFitWidth=YES;
    _lbl_challengeNameSelect.text=[AppManager getCurrectValue:[arr_VideoPost valueForKey:@"challenge_name"]];
    _lbl_challengeDescriptionSelect.text=[AppManager getCurrectValue:[arr_VideoPost valueForKey:@"description"]];
    _lbl_PostEndDate.text=[AppManager getCurrectValue:[arr_VideoPost valueForKey:@"post_valid"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
