//
//  SelectteamTableViewCell.h
//  Krust
//
//  Created by Pankaj Sharma on 08/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectteamTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl_user_name;
@property (strong, nonatomic) IBOutlet UIImageView *imageVW_user;
-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_likedata;
@end
