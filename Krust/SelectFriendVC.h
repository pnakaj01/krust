//
//  SelectFriendVC.h
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectFriendVC : UIViewController
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
    NSInteger Statusofnotification;
}

@property(nonatomic,assign)BOOL isfromTagingFriend;
@property(nonatomic,strong)NSString *  str_postID;

@end
