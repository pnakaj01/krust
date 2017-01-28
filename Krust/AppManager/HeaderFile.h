//
//  HeaderFile.h
//  Deal App
//
//  Created by Shiju Varghese on 09/10/14.
//  Copyright (c) 2014 Shiju Varghese. All rights reserved.
//

#ifndef Deal_App_HeaderFile_h
#define Deal_App_HeaderFile_h

#import "AFNetworking.h"
#import "MBProgressHUD.h"

//http://dev414.trigma.us/serv/Webservices/customersignup?

//#define BASE_URL        @"http://jaytechinfo.in/dating/?action="

#define BASE_URL        @"http://52.88.74.45/Webservices/"

#define KResgiterUser @"signup"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x69c2eb);

#define kAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define kFileManager               [NSFileManager defaultManager]
#define kTitle                     @"TITLE:"

#define kLogin                     @"login?"

#define kCreateGroup               @"create_group?"

#define kvideoupload               @"videoupload?"

#define KChangePassword            @"change_password?"

#define Kchallengecome            @"challenge_come?"

#define Kchallengeout            @"challenge_out?"

#define Kacceptreject            @"accept_reject?"

#define kgroupshow               @"group_show?"

#define keditgroup            @"edit_group?"

#define Kcontactus            @"contact_us?"

#define Kfacebooklogin            @"facebook_login?"

#define Kfollowers            @"followers?"

#define Kfollowuser            @"follow_user?"

#define Kfollowing            @"following?"


#define Kforgot            @"forgot?"

#define Kvideo            @"video?"

#define Kfriendfeed            @"friend_feed?"

#define Kvideodelete            @"video_delete?"

#define Kvideolike            @"video_like?"

#define Kgloblefollowlist            @"globle_follow_list?"

#define Kselectfriendlist            @"select_friend_list?"

#define Kvideoweeklist            @"videoweeklist?"

#define Kvideouserlikelist           @"video_userlike_list?"

#define Kvideoshow            @"videoshow?"

#define Knotificationnews            @"notification_news?"

#define Kgroupacceptdecline            @"group_accept_decline?"

#define Kcommentshow            @"comment_show?"

#define Kcommentdelete           @"comment_delete?"

#define Kcommentupload            @"comment_upload?"

#define Kprofile            @"profile?"

#define Kvideoadmin            @"videoadmin?"


#define Kvideosolo            @"video_solo?"

#define Ksignup            @"signup?"

#define Klistgroup           @"list_group?"

#define Kdeletegroup            @"delete_group?"

#define Klogout            @"logout?"

#define Kprofileedit            @"profile_edit?"

#define Kuserprofiledelete            @"user_profile_delete?"
#define Kgroupuserlist            @"group_user_list?"
#define Kaddgroupuser            @"add_group_user?"


#define userInfoKey @"userInfoKey"

#define GCDBackgroundThread dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define GCDMainThread dispatch_get_main_queue()

#endif
