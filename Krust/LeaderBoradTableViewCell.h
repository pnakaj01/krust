//
//  LeaderBoradTableViewCell.h
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderBoradTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btn_follow;
@property (strong, nonatomic) IBOutlet UILabel *lbl_username;
@property (strong, nonatomic) IBOutlet UILabel *lbl_likes;
@property (strong, nonatomic) IBOutlet UIImageView *imageVW_username;
-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_leaderboarddata;
@property (strong, nonatomic) IBOutlet UILabel *lbl_rank;

@property (strong, nonatomic) IBOutlet UILabel *lbl_likess;
@property (strong, nonatomic) IBOutlet UIButton *btn_UserProfile;

@end
