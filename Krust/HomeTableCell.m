//
//  HomeTableCell.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "HomeTableCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AppManager.h"
#import "Haneke.h"

@implementation HomeTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_VideoPost
{


   // NSLog(@"in cell data -=-=-=-%@",arr_VideoPost);
    
    NSInteger Status=[[arr_VideoPost valueForKey:@"islike"] integerValue];
    if(Status ==1)
    {
        [_imageVW_heart setImage:[UIImage imageNamed:@"icon-heart-fill"]];
//        _lbl_like.text=@"Unlike";
    }
    else
    {
        [_imageVW_heart setImage:[UIImage imageNamed:@"icon-heart"]];
//        _lbl_like.text=@"Like";
    }
    
    if ([[arr_VideoPost valueForKey:@"group"]isEqualToString:@"team"])
    {
        str_UserImageURl=[NSString stringWithFormat:@"%@",[arr_VideoPost valueForKey:@"group_profile"]];
    }
    else
    {
        str_UserImageURl=[NSString stringWithFormat:@"%@",[arr_VideoPost valueForKey:@"profileImageuser"]];
    }
    
    _imageVW_user.layer.cornerRadius=_imageVW_user.frame.size.height/2;
    _imageVW_user.clipsToBounds = YES;

    NSString * str_teamname=[NSString stringWithFormat:@"%@",[arr_VideoPost valueForKey:@"team_name"]];
    
    if((str_teamname==[NSNull class])||([str_teamname isEqual:@"null"])||([str_teamname isEqual:@"(null)"])||([str_teamname isEqual:@"<null>"])||([str_teamname isEqual:@"nil"])||([str_teamname isEqual:@""])||([str_teamname isEqual:@"<nil>"])||(str_teamname.length==0))
        
    {
        str_teamname=@"";
        
    }
    
    lbl_tagsfriends.marqueeType=MLContinuous;
    lbl_tagsfriends.scrollDuration = 15.0;
    lbl_tagsfriends.animationCurve = UIViewAnimationOptionCurveEaseInOut;
    lbl_tagsfriends.fadeLength = 10.0f;
    lbl_tagsfriends.continuousMarqueeExtraBuffer = 10.0f;
    lbl_tagsfriends.text=[AppManager getCurrectValue:[NSString stringWithFormat:@"%@  %@",str_teamname,[arr_VideoPost valueForKey:@"list_team_name"]]];

    _lbl_comments.text=[AppManager getCurrectValue:[NSString stringWithFormat:@"%@ Comments",[arr_VideoPost valueForKey:@"like_comments"]]];
    _lbl_likes.text=[AppManager getCurrectValue:[NSString stringWithFormat:@"%@ Likes",[arr_VideoPost valueForKey:@"like_count"]]];
    _lbl_PostTime.text=[AppManager getCurrectValue:[arr_VideoPost valueForKey:@"video_time"]];
    _lbl_timeLeft.text=[AppManager getCurrectValue:[NSString stringWithFormat:@"%@",[arr_VideoPost valueForKey:@"post_valid"]]];
    _lbl_uxername.text=[AppManager getCurrectValue:[arr_VideoPost valueForKey:@"user_name"]];
    _txtVW_description.text=[AppManager getCurrectValue:[arr_VideoPost valueForKey:@"description"]];
    _lbl_challenge_name.text=[AppManager getCurrectValue:[arr_VideoPost valueForKey:@"challenge_name"]];
    
    NSString *imagestr = [NSString stringWithFormat:@"%@",str_UserImageURl];
    [_imageVW_user hnk_setImageFromURL: [NSURL URLWithString:imagestr]];
    
 
    NSString *imagestr1 = [NSString stringWithFormat:@"%@",[arr_VideoPost valueForKey:@"video_image"]];
    [_imageVW_post hnk_setImageFromURL: [NSURL URLWithString:imagestr1]];
    
//     _imageVW_post.transform = CGAffineTransformMakeRotation(M_PI_2);
    
//    NSString *strVideoURL = [NSString stringWithFormat:@"%@",[arr_VideoPost valueForKey:@"profileImageuser"]];
//    NSURL *videoURL = [NSURL URLWithString:strVideoURL] ;
//    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
//    UIImage  *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
//    player = nil;
//    _imageVW_post.image=thumbnail;

    
//    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_VideoPost valueForKey:@"video_name"]]] options:nil];
//    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//    generator.appliesPreferredTrackTransform=TRUE;
//    
//    CMTime thumbTime = CMTimeMakeWithSeconds(1,30);
//    
//    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
//        if (result != AVAssetImageGeneratorSucceeded)
//        {
//            NSLog(@"couldn't generate thumbnail, error:%@", error);
//        }
//        
//        else
//            
//        {
//            _imageVW_post.image=[UIImage imageWithCGImage:im];
//            
//            
//        }
//    };
//    CGSize maxSize = CGSizeMake(320, 180);
//    generator.maximumSize = maxSize;
//    
//    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];

}

@end
