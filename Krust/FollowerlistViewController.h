//
//  FollowerlistViewController.h
//  Krust
//
//  Created by Pankaj Sharma on 16/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowerlistViewController : UIViewController
{
    NSMutableArray *arr_likeData;
    NSString *str_userID;
    NSMutableArray *arr_Listusers;
    NSString *str_followfriendID;
    NSString *follow_status;
    IBOutlet UIView *PopUp_AlertComment;
    NSInteger Statusofnotification;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableview_like;
- (IBAction)back:(id)sender;
@property(strong,nonatomic)NSString *str_post_id;
@end
