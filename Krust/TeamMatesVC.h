//
//  TeamMatesVC.h
//  Krust
//
//  Created by Pankaj Sharma on 06/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamMatesVC : UIViewController
{
    
    IBOutlet UITableView *tableVW_selectFriend;
    BOOL isSelected;
    NSInteger indexpath;
    NSMutableArray *arr_FriendList;
    NSString * str_userID;
    NSMutableArray *arr_StoreIndexPath;
    NSMutableArray *arr_index;
    
    NSMutableArray * arr_SelectedFriends;
    NSMutableArray * arr_selectedFriendsID;
    NSMutableDictionary *dic;
    NSMutableSet *setDic;
    NSMutableArray * arr_friendsids;
    NSString *str_selecteedFriendID;
    IBOutlet UIView *View_popup;
    NSString * str_null;
    NSMutableArray * arr_deletedGorupMembers;
    NSMutableArray * arr_alreadymemberADDed;
    BOOL isIndexNil;
    NSInteger Statusofnotification;
    IBOutlet UIButton *btn_done;
}

@property(nonatomic,assign)BOOL isfromTagingFriend;
@property(nonatomic,strong)NSString *  str_postID;
@property(nonatomic,strong)NSString * str_GroupID;

@end
