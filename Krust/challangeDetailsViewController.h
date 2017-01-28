//
//  challangeDetailsViewController.h
//  Krust
//
//  Created by Pankaj Sharma on 14/08/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"

@interface challangeDetailsViewController : UIViewController<UIActionSheetDelegate>
{
    IBOutlet UIImageView *imageVW_uploadImageVW;
    IBOutlet UITextField *txt_challengeName;
    IBOutlet UITextField *txt_duration;
    IBOutlet PlaceholderTextView *txtVW_description;
    IBOutlet PlaceholderTextView *txtVW_challegeTo;
    NSString *str_USERID;
    NSString *str_encripedString;
    NSMutableArray *arr_SelectedFriendData;
    NSString *str_selecteedFriendID;
    NSMutableArray *arr_friendID;
    NSMutableArray * arr_selectedfriendName;

    IBOutlet UIDatePicker *atePicker;
    int Screen_Width;
    
    IBOutlet UIView *Picker_View;
    IBOutlet UIScrollView *categoryScrollView;
    NSMutableArray * arr_indexPaths;
    
    UIImageView* GridView;
    NSInteger Statusofnotification;
    IBOutlet UIImageView *imageVW_ThumbNail;

}
@property(nonatomic,strong)UIImage * CustumthumbnailImage;
@property(nonatomic,strong)NSString * str_CustumImage;
@property(nonatomic,assign)BOOL isFromPushCamera;



@end
