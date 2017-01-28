//
//  MYVideoADDCameraViewController.m
//  Krust
//
//  Created by Pankaj Sharma on 19/08/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "MYVideoADDCameraViewController.h"
#import "HeaderFile.h"
#import "Detal VC.h"
#import "Base64.h"
#import "AppManager.h"
#import "challangeDetailsViewController.h"


@interface MYVideoADDCameraViewController ()

@end

@implementation MYVideoADDCameraViewController

-(void)viewWillAppear:(BOOL)animated
{
    TimeCount=10;
    lbl_coundown.text=@"10";

    [AppManager sharedManager].navCon = self.navigationController;
    btn_swap.userInteractionEnabled=YES;
    isSwapCamera=NO;
    flashIsOn=NO;
    self.tabBarController.tabBar.hidden=YES;
    lbl_flash.text=nil;
    ImageVWgrid.hidden=YES;
    btn_done.hidden=YES;
    
    //  [self camera_func];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupCaptureSession];
    
    if (IS_IPHONE_5)
    {
        prevLayer = [AVCaptureVideoPreviewLayer layerWithSession: session];
        prevLayer.frame = CGRectMake(0, 0, 320, 568);
        prevLayer.videoGravity = AVLayerVideoGravityResize;
        [self.view.layer addSublayer: prevLayer];
        
        
        
        [self.view bringSubviewToFront:ViewForCameraOption];
        [self.view bringSubviewToFront:viewforCamreaClick];
        [self.view bringSubviewToFront:btn_gallery];
        [self.view bringSubviewToFront:camera_btn];
        [self.view bringSubviewToFront:ImageVWgrid];
        
        
    }
    else if (IS_IPHONE_6_PLUS)
    {
        prevLayer = [AVCaptureVideoPreviewLayer layerWithSession: session];
        prevLayer.frame = CGRectMake(0, 0, 414, 736);
        prevLayer.videoGravity = AVLayerVideoGravityResize;
        [self.view.layer addSublayer: prevLayer];
        
        ImageVWgrid.frame=CGRectMake(0, 0, 414, 736);
        [self.view bringSubviewToFront:ImageVWgrid];
        
        ViewForCameraOption.frame=CGRectMake(0, 444, 414, 50);
        [self.view bringSubviewToFront:ViewForCameraOption];
        
        viewforCamreaClick.frame=CGRectMake(0, 494, 414, 250);
        [self.view bringSubviewToFront:viewforCamreaClick];
        
        btn_gallery.frame=CGRectMake(20, 495, 66, 66);
        [self.view bringSubviewToFront:btn_gallery];
        
        btn_done.frame=CGRectMake(btn_gallery.frame.origin.x+344, btn_gallery.frame.origin.y+40, 50, 30);
        [self.view bringSubviewToFront:btn_done];
        
        
        camera_btn.frame=CGRectMake(165, 565, 96, 96);
        [self.view bringSubviewToFront:camera_btn];
        
    }
    else if (IS_IPHONE_6)
    {
        prevLayer = [AVCaptureVideoPreviewLayer layerWithSession: session];
        prevLayer.frame = CGRectMake(0, 0, 375, 667);
        prevLayer.videoGravity = AVLayerVideoGravityResize;
        [self.view.layer addSublayer: prevLayer];
        
        ImageVWgrid.frame=CGRectMake(0, 0, 375, 667);
        [self.view bringSubviewToFront:ImageVWgrid];
        
        ViewForCameraOption.frame=CGRectMake(0, 400, 375, 50);
        [self.view bringSubviewToFront:ViewForCameraOption];
        
        viewforCamreaClick.frame=CGRectMake(0, 450, 375, 250);
        [self.view bringSubviewToFront:viewforCamreaClick];
        
        btn_gallery.frame=CGRectMake(20, 495, 66, 66);
        [self.view bringSubviewToFront:btn_gallery];
        
        btn_done.frame=CGRectMake(btn_gallery.frame.origin.x+275, btn_gallery.frame.origin.y+60, 50, 30);
        [self.view bringSubviewToFront:btn_done];
        
        camera_btn.frame=CGRectMake(140, 480, 96, 96);
        [self.view bringSubviewToFront:camera_btn];
        
    }
    
}
- (IBAction)TappedOnGrid:(id)sender
{
    if ([sender isSelected])
    {
        ImageVWgrid.hidden=YES;
        btn_grid.selected=NO;
        
    }
    else
    {
        btn_grid.selected=YES;
        
        ImageVWgrid.hidden=NO;
        
    }
}
// When the movie is done,release the controller.
-(void)myMovieFinishedCallback:(NSNotification*)aNotification
{
    MPMoviePlayerController* moviePlayer=[aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    
    // Release the movie instance created in playMovieAtURL
}



-(void) clearFileIfExists:(NSURL*) filePath{
    NSString * fileStr = [filePath absoluteString];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileStr]) {
        [fileManager removeItemAtPath:fileStr error:NULL];
    }
}

- (NSURL *) tempFileURL
{
    
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
  //  NSLog(@"Saved %@",outputPath);
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath]) {
        [fileManager removeItemAtPath:outputPath error:NULL];
    }
    return outputURL ;
}

- (void) startRecording
{
    swaping=NO;
    [btn_record setImage:[UIImage imageNamed:@"play-active"] forState:UIControlStateNormal];
    
    [self clearFileIfExists:[self tempFileURL]];
    [output startRecordingToOutputFileURL:[self tempFileURL] recordingDelegate:self];
}

- (void) stopRecording
{
  //  NSLog(@"stop recording");
    [output stopRecording];
}


- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
 //   NSLog(@"started captureOutput");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
  //  NSLog(@"Error %@",error);
    //NSLog(@"Ended captureOutput");
    
    if (swaping==YES)
    {
        
    }
    else
    {
        
        //    NSString *VideoURL=[NSString stringWithFormat:@"%@",outputFileURL];
        
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:outputFileURL options:nil];
        
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
        
        if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality])
        {
            
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
            
            exportSession.shouldOptimizeForNetworkUse = YES;
            
            __block NSString* videoPath = [documentDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", [NSDate date]]];
            
            exportSession.outputURL = [NSURL fileURLWithPath:videoPath];
            NSLog(@"videopath of your mp4 file = %@", videoPath);  // PATH OF YOUR .mp4 FILE
            
            exportSession.outputFileType = AVFileTypeMPEG4;
            
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                
                switch ([exportSession status])
                {
                        
                    case AVAssetExportSessionStatusFailed:
                        
                //        NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                        
                        break;
                        
                    case AVAssetExportSessionStatusCancelled:
                        
                  //      NSLog(@"Export canceled");
                        
                        break;
                        
                    case AVAssetExportSessionStatusCompleted:{
                        
                        // If you wanna remove file...do this stuff
                        //[[NSFileManager defaultManager]removeItemAtPath:videoPath error:nil];
                        
                        NSData  *plainData = [NSData dataWithContentsOfFile:videoPath];
                        
                   //     NSLog(@"Export completed");
                        
                        
                        // Get NSString from NSData object in Base64
                        encryptedString =[plainData base64EncodedStringWithOptions:0];
                        
                        // [Base64 initialize];
                        // encryptedString = [Base64 encode:plainData];
                        // encryptedString = [plainData base64EncodedStringWithOptions:0];
                      //  NSLog(@" encrept data %@", encryptedString);
                        
                        [self performSelectorOnMainThread:@selector(PushController) withObject:nil waitUntilDone:YES];
                    }
                        
                }
                
            }];
            
        }
        
    }
    //    NSData  *plainData = [NSData dataWithContentsOfURL:outputFileURL];
    //    encryptedString =[plainData base64EncodedStringWithOptions:0];
    //    NSLog(@" encrept data %@", encryptedString);
    //
    //    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    //    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
    //    {
    //        [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
    //                                    completionBlock:^(NSURL *assetURL, NSError *error)
    //        {
    //
    //
    //        }];
    //    }
    
}

-(void)PushController
{

//    challangeDetailsViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"challangeDetailsViewController"];
//    vc1.str_encripedString=encryptedString;
    [self.navigationController popViewControllerAnimated:YES];
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:encryptedString forKey:@"VideoString"];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"SecVCPopped" object:self userInfo:userInfo];
    
//    [self dismissViewControllerAnimated:NO completion:nil];

}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
        {
            return device;
        }
    }
    return nil;
}
- (AVCaptureDevice *) backFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}
- (AVCaptureDevice *) frontFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

-(void) swapCamera
{
    btn_done.hidden=YES;
    
    swaping=YES;
    
    [session stopRunning];
    [session removeInput:input];
    if(isFrontFacing)
    {
        input = [AVCaptureDeviceInput deviceInputWithDevice:[self backFacingCamera] error:nil];
        isSwapCamera=NO;
    }
    else
    {
        input = [AVCaptureDeviceInput deviceInputWithDevice:[self frontFacingCamera] error:nil];
        isSwapCamera=YES;
    }
    isFrontFacing = !isFrontFacing;
    
    if(!input)
    {
      //  NSLog(@"Couldn't create input!");
    }
    
    [session addInput:input];
    [session startRunning];
    
}

- (void)setupCaptureSession
{
    // Create the session
    session = [[AVCaptureSession alloc] init];
    session.sessionPreset =  AVCaptureSessionPresetMedium;;
    input = [AVCaptureDeviceInput deviceInputWithDevice:[self backFacingCamera] error:nil];
    
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    audioInput = [AVCaptureDeviceInput deviceInputWithDevice:[devices objectAtIndex:0] error:nil];
    
    if(!input || !audioInput)
    {
    //    NSLog(@"Couldn't create input!");
    }
    output= [[AVCaptureMovieFileOutput alloc] init] ;
    [session addInput:input];
    [session addInput:audioInput];
    [session addOutput:output];
    [session startRunning];
}

-(void) swapImage:(id) sender
{
    if(onImage)
    {
        [recordButton setImage:[UIImage imageNamed:@"record_button.png"] forState:UIControlStateNormal];
    }
    else
    {
        [recordButton setImage:[UIImage imageNamed:@"record_button_on.png"] forState:UIControlStateNormal];
    }
    onImage=!onImage;
}
-(void) stopBlink
{
    [timer invalidate];
}

-(void) startBlink
{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(swapImage:) userInfo:nil repeats:YES];
}

-(IBAction) recordClicked
{
    
    
    
}
- (IBAction)recordClicked:(id)sender
{
    
    //    if([sender isSelected])
    //    {
    //        //  [self initFlipButton];
    //        [self stopRecording];
    //        [session stopRunning];
    //        [delegate stopRecording];
    //        // [recordButton setImage:[UIImage imageNamed:@"record_button.png"] forState:UIControlStateNormal];
    ////        onImage=false;
    ////        [self stopBlink];
    //        camera_btn.selected=NO;
    //
    //        //[self playMovie];
    //
    //    }
    //    else
    //    {
    //        [flipButton setHidden:YES];
    //   [recordButton setImage:[UIImage imageNamed:@"record_button_on.png"] forState:UIControlStateNormal];
    //        onImage = true;
    TimeCount=10;
    lbl_coundown.text=@"10";
    
    if ([camera_btn isSelected])
    {
        btn_done.hidden=NO;
        
        [mytimer invalidate];
        
        btn_swap.userInteractionEnabled=YES;
        
        [camera_btn setImage:[UIImage imageNamed:@"cemra"] forState:UIControlStateNormal];
        
        camera_btn.selected=NO;
        
    }
    else
    {
        btn_swap.userInteractionEnabled=NO;
        btn_done.hidden=YES;
        [self startRecording];
        [session startRunning];
        [delegate startRecording];
        [self startBlink];
        //        [self performSelector:@selector(StopVideo)
        //                   withObject:nil
        //                   afterDelay:10.0];
        mytimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(StopVideo) userInfo:nil repeats:NO];
        
        [camera_btn setImage:[UIImage imageNamed:@"play-active"] forState:UIControlStateNormal];
        camera_btn.selected=YES;
    }
    
    
    //        camera_btn.selected=YES;
    //    }
    //    recording = !recording;
    
    
}

- (IBAction)TappedONDone:(id)sender
{
    btn_done.hidden=NO;
    [mytimer invalidate];
    [self stopRecording];
    [session stopRunning];
    [delegate stopRecording];
    camera_btn.selected=NO;
    recording = false;
}

-(void)StopVideo
{
    if (![lbl_coundown.text isEqualToString:@"0"])
    {
        lbl_coundown.text=[NSString stringWithFormat:@"%d",TimeCount];
        TimeCount=TimeCount-1;
    }
    else
    {
        [mytimer invalidate];
        [self stopRecording];
        [session stopRunning];
        [delegate stopRecording];
        camera_btn.selected=NO;
        recording = false;
    }
    
}

- (IBAction)flipClicked:(id)sender
{
    [camera_btn setImage:[UIImage imageNamed:@"cemra"] forState:UIControlStateNormal];
    
    camera_btn.selected=NO;
    [self swapCamera];
    
}

- (IBAction)TappedOnFlash:(id)sender
{
    if (isSwapCamera==YES)
    {
        alert(@"Alert", @"Flash can not be open in front camera mode.");
    }
    else
    {
        
        // check if flashlight available
        Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
        if (captureDeviceClass != nil) {
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            if ([device hasTorch] && [device hasFlash]){
                
                [device lockForConfiguration:nil];
                
                if (!flashIsOn)
                {
                    lbl_flash.text=@"ON";
                    [device setTorchMode:AVCaptureTorchModeOn];
                    [device setFlashMode:AVCaptureFlashModeOn];
                    flashIsOn = YES;
                }
                else
                {
                    lbl_flash.text=@"OFF";
                    [device setTorchMode:AVCaptureTorchModeOff];
                    [device setFlashMode:AVCaptureFlashModeOff];
                    flashIsOn = NO;
                }
                
                [device unlockForConfiguration];
            }
        }
    }
}

- (IBAction)TappedOnOpenGallery:(id)sender
{
    
}

-(IBAction) cancelClicked
{
    if(recording)
    {
        [self stopRecording];
        [self stopBlink];
        recording = false;
    }
    
    [delegate cancelClicked];
    
}
-(IBAction) flipClicked
{
}
-(IBAction) usedClicked
{
    //    [delegate didPickVideoAtPath:[self tempFileURL]];
}
-(IBAction) retakeClicked
{
    //    [session startRunning];
    //    [moviePlayer.view removeFromSuperview];
    //    moviePlayer = nil;
    //    [preCaptureToolbar setHidden:NO];
    //    [postCaptureToolbar setHidden:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    TimeCount=10;
    lbl_coundown.text=@"10";
    camera_btn.selected=NO;
    [mytimer invalidate];
    [camera_btn setImage:[UIImage imageNamed:@"cemra"] forState:UIControlStateNormal];
    [session startRunning];
}

//-(IBAction) playClicked
//{
//    [self playMovie];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
