//
//  AddTeamMatesTWCell.h
//  Krust
//
//  Created by Pankaj Sharma on 06/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTeamMatesTWCell : UITableViewCell
{
    NSMutableArray *arr_index;
}
@property (strong, nonatomic) IBOutlet UIButton *btn_selectFriend;
-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_VideoPost;
@property (strong, nonatomic) IBOutlet UIImageView *imageVW_user;
@property (strong, nonatomic) IBOutlet UILabel *lbbl_UserName;
@end
