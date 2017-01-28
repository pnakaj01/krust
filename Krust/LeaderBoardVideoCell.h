//
//  LeaderBoardVideoCell.h
//  Krust
//
//  Created by Pankaj Sharma on 08/09/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderBoardVideoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btn_like;
@property (strong, nonatomic) IBOutlet UIButton *btn_comment;
-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_VideoPost;
@property (strong, nonatomic) IBOutlet UIImageView *imageVW_post;
@property (strong, nonatomic) IBOutlet UILabel *txtVW_description;
@property (strong, nonatomic) IBOutlet UILabel *lbl_PostTime;
@property (strong, nonatomic) IBOutlet UILabel *lbl_uxername;
@property (strong, nonatomic) IBOutlet UIImageView *imageVW_user;
@property (strong, nonatomic) IBOutlet UILabel *lbl_likes;
@property (strong, nonatomic) IBOutlet UILabel *lbl_comments;
@property (strong, nonatomic) IBOutlet UILabel *lbl_timeLeft;
@property (strong, nonatomic) IBOutlet UIButton *btn_more;
@property (strong, nonatomic) IBOutlet UIButton *Btn_like_unlike;

@property (strong, nonatomic) IBOutlet UIImageView *imageVW_heart;
@property (strong, nonatomic) IBOutlet UILabel *lbl_like;
@property (strong, nonatomic) IBOutlet UIButton *btn_playVideo;
@property (strong, nonatomic) IBOutlet UILabel *lbl_challenge_name;
@property (strong, nonatomic) IBOutlet UIButton *btn_ShowUserProfile;


@end
