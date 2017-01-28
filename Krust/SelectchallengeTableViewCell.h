//
//  SelectchallengeTableViewCell.h
//  Krust
//
//  Created by Pankaj Sharma on 07/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectchallengeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageVW_side;
@property (strong, nonatomic) IBOutlet UILabel *lbl_challengeNameSelect;
@property (strong, nonatomic) IBOutlet UILabel *lbl_challengeDescriptionSelect;
@property (strong, nonatomic) IBOutlet UIButton *btn_SelectChallenge;
-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_VideoPost;

@property (strong, nonatomic) IBOutlet UIImageView *imaeVW_thumbnailSelect;

@property (strong, nonatomic) IBOutlet UILabel *lbl_PostEndDate;

@end
