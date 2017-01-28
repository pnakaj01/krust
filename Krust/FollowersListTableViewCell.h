//
//  FollowersListTableViewCell.h
//  Krust
//
//  Created by Pankaj Sharma on 16/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowersListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btn_follow;
@property (strong, nonatomic) IBOutlet UILabel *lbl_user_likes;
@property (strong, nonatomic) IBOutlet UILabel *lbl_user_name;
@property (strong, nonatomic) IBOutlet UIImageView *imageVW_user;
-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_likedata;
@property (strong, nonatomic) IBOutlet UIButton *btn_UserProfile;

@end
