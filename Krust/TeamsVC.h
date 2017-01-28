//
//  TeamsVC.h
//  Krust
//
//  Created by Pankaj Sharma on 06/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamsVC : UIViewController
{
    NSMutableArray *arr_likeData;
    NSString *str_userID;
    NSMutableArray *arr_Listusers;
    IBOutlet UIView *PopUp_AlertComment;
    NSInteger Statusofnotification;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableview_like;

- (IBAction)back:(id)sender;

@end
