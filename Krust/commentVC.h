//
//  commentVC.h
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"

@interface commentVC : UIViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIWebViewDelegate>
{
    IBOutlet UITableView *tableVW_comment;
    float height;
    NSData *dataImage;
    NSString *str_userID;
    IBOutlet UIButton *btn_send;
    CGSize size;
    NSMutableArray *arr_comment;
    
}
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet PlaceholderTextView *txtx_view;
@property(strong,nonatomic)NSString *str_post_id;

@end
