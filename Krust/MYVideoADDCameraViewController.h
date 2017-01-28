//
//  MYVideoADDCameraViewController.h
//  Krust
//
//  Created by Pankaj Sharma on 19/08/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MYVideoADDCameraViewController : UIViewController
{
    IBOutlet UIView* preCaptureToolbar;
    IBOutlet UIView* postCaptureToolbar;
    AVCaptureVideoPreviewLayer * prevLayer;
    AVCaptureSession * session;
    AVCaptureDeviceInput * input;
    AVCaptureDeviceInput * audioInput;
    AVCaptureMovieFileOutput * output;
    //    MPMoviePlayerController	* moviePlayer;
    IBOutlet UIActivityIndicatorView * loading;
    bool isLoading;
    IBOutlet UIButton * flipButton;
    IBOutlet UIButton * recordButton;
    NSTimer * timer;
    id delegate;
    bool recording;
    bool onImage;
    bool isFrontFacing;
    IBOutlet UIView *ViewForCameraOption;
    IBOutlet UIView *viewforCamreaClick;
    IBOutlet UIButton *btn_gallery;
    IBOutlet UIButton *camera_btn;
    BOOL flashIsOn;
    NSTimer *TimerForRecord;
    IBOutlet UILabel *lbl_flash;
    IBOutlet UIButton *btn_flash;
    NSString *encryptedString;
    IBOutlet UIButton *btn_record;
    BOOL isSwapCamera;
    IBOutlet UIButton *btn_swap;
    NSTimer *mytimer;
    BOOL swaping;
    IBOutlet UIImageView *ImageVWgrid;
    IBOutlet UIButton *btn_grid;
    IBOutlet UIButton *btn_done;
    IBOutlet UILabel *lbl_coundown;
    int TimeCount;

}

- (IBAction)recordClicked:(id)sender;
- (IBAction)flipClicked:(id)sender;
- (IBAction)TappedOnFlash:(id)sender;
- (IBAction)TappedOnOpenGallery:(id)sender;

-(IBAction) flipClicked;
-(IBAction) usedClicked;
-(IBAction) retakeClicked;
-(IBAction) playClicked;


// @property (strong, nonatomic) AVCaptureDeviceInput *audioInput;
//@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;
//
//@property (strong, nonatomic) AVCaptureMovieFileOutput *movieOutput;
//@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
//@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (weak, nonatomic) IBOutlet UIView *viewForCamera;

@end
