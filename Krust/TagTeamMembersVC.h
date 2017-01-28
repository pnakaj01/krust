//
//  TagTeamMembersVC.h
//  Krust
//
//  Created by Pankaj Sharma on 08/10/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagTeamMembersVC : UIViewController<UIActionSheetDelegate>
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
    NSMutableArray * arr_deletedGorupMembers;
    NSMutableArray * arr_alreadymemberADDed;
    IBOutlet UIButton *btn_done;
    NSInteger Statusofnotification;
    NSString *str_encripedString;
    UIImage *thumbnailImage;


}

@property(nonatomic,assign)BOOL isfromTagingFriend;
@property(nonatomic,strong)NSString *  str_postID;
@property(nonatomic,strong)NSString * str_GroupID;

@end
