//
//  PrivateChat.h
//  Havoc
//
//  Created by Preeti Malhotra on 7/26/14.
//  Copyright (c) 2014 Preeti Malhotra. All rights reserved.
//

#import "PrivateChat.h"
#import "PlaceholderTextView.h"

BOOL CHANNEL,PRIVATE;
@interface PrivateChat : UIViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIWebViewDelegate>
{
 
    float height;
    IBOutlet UITableView *chattable;
    NSData *dataImage;
    NSString *str_userID;
    CGSize size;
    NSMutableArray *arr_comment;
    IBOutlet UIButton *btn_send;
    IBOutlet UIView *PopUp_AlertComment;
    NSInteger Statusofnotification;
    
}
- (IBAction)send_message:(id)sender;

@property (strong, nonatomic) IBOutlet PlaceholderTextView *txtx_view;
@property(strong,nonatomic)NSString *str_post_id;

@property (nonatomic,strong)NSMutableArray *arr_detailComment;




@end
