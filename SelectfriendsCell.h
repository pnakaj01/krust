//
//  SelectfriendsCell.h
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectfriendsCell : UITableViewCell
{
    NSMutableArray *arr_index;
}
@property (strong, nonatomic) IBOutlet UIButton *btn_selectFriend;
-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_VideoPost;
@property (strong, nonatomic) IBOutlet UIImageView *imageVW_user;
@property (strong, nonatomic) IBOutlet UILabel *lbbl_UserName;


@end
