//
//  ChallengeListCell.h
//  Krust
//
//  Created by Pankaj Sharma on 8/17/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageVW_side;
@property (strong, nonatomic) IBOutlet UILabel *lbl_challengeName;
@property (strong, nonatomic) IBOutlet UILabel *lbl_challengeDescription;
@property (strong, nonatomic) IBOutlet UIButton *btn_SelectChallenge;
-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_VideoPost;

@property (strong, nonatomic) IBOutlet UIImageView *imaeVW_thumbnail;
@property (strong, nonatomic) IBOutlet UILabel *lbl_PostEndDate;

@end
