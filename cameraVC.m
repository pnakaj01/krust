//
//  cameraVC.m
//  Krust
//
//  Created by Pankaj Sharma on 25/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "cameraVC.h"
#import "HeaderFile.h"
#import "Detal VC.h"
#import "Base64.h"
#import "AppManager.h"
#import "Selectchallenge1ViewController.h"
#import "challangeDetailsViewController.h"

@interface cameraVC ()
{

}
@end

@implementation cameraVC

@synthesize  str_groupID,str_Teammembers;

-(void)viewWillAppear:(BOOL)animated
{
    btn_back.userInteractionEnabled=YES;
    btn_done.userInteractionEnabled=YES;
    btn_DoneVideo.userInteractionEnabled=YES;
    btn_record.userInteractionEnabled=YES;
    btn_swap.userInteractionEnabled=YES;
    camera_btn.userInteractionEnabled=YES;

    btn_back.hidden=NO;
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
    lbl_coundown.hidden=YES;
    btn_DoneVideo.hidden=YES;

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
        [self.view bringSubviewToFront:lbl_coundown];
        [self.view bringSubviewToFront:btn_back];
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
        
        camera_btn.frame=CGRectMake(140, 500, 96, 96);
        [self.view bringSubviewToFront:camera_btn];
        
        lbl_coundown.frame=CGRectMake(250, 530, 72, 30);
        [self.view bringSubviewToFront:lbl_coundown];
        
        btn_back.frame=CGRectMake(0 , 15, 60, 50);
        [self.view bringSubviewToFront:btn_back];
        
        
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
        
        lbl_coundown.frame=CGRectMake(260, 585, 72, 30);
        [self.view bringSubviewToFront:lbl_coundown];
        
        btn_back.frame=CGRectMake(0 , 15, 60, 50);
        [self.view bringSubviewToFront:btn_back];
    }
    
    
    //  [self camera_func];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    //    if (IS_IPHONE_5)
    //    {
    //        prevLayer = [AVCaptureVideoPreviewLayer layerWithSession: session];
    //        prevLayer.frame = CGRectMake(0, 0, 320, 524);
    //        prevLayer.videoGravity = AVLayerVideoGravityResize;
    //        [self.view.layer addSublayer: prevLayer];
    //
    //        [self.view bringSubviewToFront:ViewForCameraOption];
    //        [self.view bringSubviewToFront:viewforCamreaClick];
    //        [self.view bringSubviewToFront:btn_gallery];
    //        [self.view bringSubviewToFront:camera_btn];
    //        [self.view bringSubviewToFront:ImageVWgrid];
    //
    //
    //    }
    //    else if (IS_IPHONE_6_PLUS)
    //    {
    //        prevLayer = [AVCaptureVideoPreviewLayer layerWithSession: session];
    //        prevLayer.frame = CGRectMake(0, 0, 414, 692);
    //        prevLayer.videoGravity = AVLayerVideoGravityResize;
    //        [self.view.layer addSublayer: prevLayer];
    //
    //        ImageVWgrid.frame=CGRectMake(0, 0, 414, 692);
    //        [self.view bringSubviewToFront:ImageVWgrid];
    //
    //        ViewForCameraOption.frame=CGRectMake(0, 400, 414, 50);
    //        [self.view bringSubviewToFront:ViewForCameraOption];
    //
    //        viewforCamreaClick.frame=CGRectMake(0, 450, 414, 250);
    //        [self.view bringSubviewToFront:viewforCamreaClick];
    //
    //        btn_gallery.frame=CGRectMake(20, 495, 66, 66);
    //        [self.view bringSubviewToFront:btn_gallery];
    //
    //        lbl_coundown.frame=CGRectMake(btn_gallery.frame.origin.x+300, btn_gallery.frame.origin.y+40, 50, 30);
    //        [self.view bringSubviewToFront:btn_done];
    //
    //
    //        camera_btn.frame=CGRectMake(150, 480, 96, 96);
    //        [self.view bringSubviewToFront:camera_btn];
    //
    //    }
    //     else if (IS_IPHONE_6)
    //    {
    //        prevLayer = [AVCaptureVideoPreviewLayer layerWithSession: session];
    //        prevLayer.frame = CGRectMake(0, 0, 375, 615);
    //        prevLayer.videoGravity = AVLayerVideoGravityResize;
    //        [self.view.layer addSublayer: prevLayer];
    //
    //        ImageVWgrid.frame=CGRectMake(0, 0, 375, 623);
    //        [self.view bringSubviewToFront:ImageVWgrid];
    //
    //
    //
    //        ViewForCameraOption.frame=CGRectMake(0, 400, 375, 50);
    //        [self.view bringSubviewToFront:ViewForCameraOption];
    //
    //        viewforCamreaClick.frame=CGRectMake(0, 450, 375, 250);
    //        [self.view bringSubviewToFront:viewforCamreaClick];
    //
    //        btn_gallery.frame=CGRectMake(20, 495, 66, 66);
    //        [self.view bringSubviewToFront:btn_gallery];
    //
    //        lbl_coundown.frame=CGRectMake(btn_gallery.frame.origin.x+275, btn_gallery.frame.origin.y+60, 50, 30);
    //        [self.view bringSubviewToFront:btn_done];
    //
    //                camera_btn.frame=CGRectMake(140, 480, 96, 96);
    //        [self.view bringSubviewToFront:camera_btn];
    //
    //    }
    
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



-(void) clearFileIfExists:(NSURL*) filePath
{
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
    
    if ([fileManager fileExistsAtPath:outputPath])
    {
        [fileManager removeItemAtPath:outputPath error:NULL];
    }
    
    return outputURL ;
}

- (void) startRecording
{
    swaping=NO;
    Videoexist=NO;
    
    
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
  //  NSLog(@"started captureOutput");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
//    NSLog(@"Error %@",error);
 //   NSLog(@"Ended captureOutput");
    
    if (swaping==YES || Videoexist==YES)
    {
        
    }
    else
    {
        
        //    NSString *VideoURL=[NSString stringWithFormat:@"%@",outputFileURL];
        
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:outputFileURL options:nil];
        
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
        
        if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality])
        {
            
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
            
            exportSession.shouldOptimizeForNetworkUse = YES;
            
            __block NSString* videoPath = [documentDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", [NSDate date]]];
            
            exportSession.outputURL = [NSURL fileURLWithPath:videoPath];
            
      //      NSLog(@"videopath of your mp4 file = %@", videoPath);  // PATH OF YOUR .mp4 FILE
            
            exportSession.outputFileType = AVFileTypeMPEG4;
            
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                
                switch ([exportSession status])
                {
                    case AVAssetExportSessionStatusFailed:
                        
//                        NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                        
                        break;
                        
                    case AVAssetExportSessionStatusCancelled:
                        
            //            NSLog(@"Export canceled");
                        
                        break;
                        
                    case AVAssetExportSessionStatusCompleted:{
                        
                        AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
                        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                        generator.appliesPreferredTrackTransform=TRUE;
                        
                        CMTime thumbTime = CMTimeMakeWithSeconds(1,30);
                        
                        AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error)
                        {
                            if (result != AVAssetImageGeneratorSucceeded)
                            {
                        //        NSLog(@"couldn't generate thumbnail, error:%@", error);
                            }
                            
                            else
                                
                            {
                                //                        _imageVW_post.image=[UIImage imageWithCGImage:im];
                        //        NSLog(@"%@",im);
                                thumbnailImage=[UIImage imageWithCGImage:im];
                                
                                [self performSelectorOnMainThread:@selector(PushController) withObject:nil waitUntilDone:YES];

                        //        NSLog(@"--cameraVC-%@",thumbnailImage);
                                
                            }
                        };
                        CGSize maxSize = CGSizeMake(320, 180);
                        generator.maximumSize = maxSize;
                        
                        [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
                        
                        // If you wanna remove file...do this stuff
                        //[[NSFileManager defaultManager]removeItemAtPath:videoPath error:nil];
                        
                        NSData  *plainData = [NSData dataWithContentsOfFile:videoPath];
                //        NSLog(@"Export completed");
                        
                        // Get NSString from NSData object in Base64
                        
                        encryptedString =[plainData base64EncodedStringWithOptions:0];
                        
                        // [Base64 initialize];
                        // encryptedString = [Base64 encode:plainData];
                        // encryptedString = [plainData base64EncodedStringWithOptions:0];
                //        NSLog(@" encrept data %@", encryptedString);
                        
                        //[self performSelector:@selector(PushController) withObject:nil withObject:nil];
                    }
                        
                }
                
            }];
            
        }
        
    }
    
    
    //        NSString *strVideoURL = [NSString stringWithFormat:@"%@",[arr_VideoPost valueForKey:@"profileImageuser"]];
    //        NSURL *videoURL = [NSURL URLWithString:strVideoURL] ;
    //        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    //        UIImage  *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    //        player = nil;
    //        _imageVW_post.image=thumbnail;
    
    
    
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

    btn_back.userInteractionEnabled=YES;
    btn_done.userInteractionEnabled=YES;
    btn_DoneVideo.userInteractionEnabled=YES;
    btn_record.userInteractionEnabled=YES;
    btn_swap.userInteractionEnabled=YES;
    camera_btn.userInteractionEnabled=YES;
    
    //    Detal_VC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Detal_VC"];
    //    vc1.str_encripedString=encryptedString;
    //    [self.navigationController pushViewController:vc1 animated:YES];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FromCustumChallenge"]==YES)
    {
        
//        [self.navigationController popViewControllerAnimated:YES];
//        
//        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
//        [userInfo setObject:encryptedString forKey:@"VideoStringcameraOnecustum"];
//        
//        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//        [nc postNotificationName:@"FirstVCPoppedcustum" object:self userInfo:userInfo];
//        
//        NSMutableDictionary* userInfo1 = [NSMutableDictionary dictionary];
//        [userInfo1 setValue:thumbnailImage forKey:@"Imagethumbnailcustum"];
//        
//        NSNotificationCenter* nc1 = [NSNotificationCenter defaultCenter];
//        [nc1 postNotificationName:@"ImageVCPoppedcustum" object:self userInfo:userInfo1];
//        
//        NSLog(@"thimnailImagePush %@ str_videoString %@",thumbnailImage,encryptedString);
        
        challangeDetailsViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"challangeDetailsViewController"];
        vc1.CustumthumbnailImage=thumbnailImage;
        vc1.str_CustumImage=encryptedString;
        vc1.isFromPushCamera=YES;
        [self.navigationController pushViewController:vc1 animated:YES];
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FromCustumChallenge"];
    }
    else if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FromTagTeam"]==YES)
    {
        //        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FromTagTeam"];
        
//        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
//        [userInfo setObject:encryptedString forKey:@"VideoStringcameraOne"];
//        
//        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//        [nc postNotificationName:@"FirstVCPopped" object:self userInfo:userInfo];
//        
//        NSMutableDictionary* userInfo1 = [NSMutableDictionary dictionary];
//        [userInfo1 setValue:thumbnailImage forKey:@"Imagethumbnail"];
//        
//        NSNotificationCenter* nc1 = [NSNotificationCenter defaultCenter];
//        [nc1 postNotificationName:@"ImageVCPopped" object:self userInfo:userInfo1];
        
    //    NSLog(@"thimnailImagePush %@ str_videoString %@",thumbnailImage,encryptedString);

        
        Selectchallenge1ViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Selectchallenge1"];
        vc1.imagethumbnailSelect=thumbnailImage;
        vc1.str_encripedString=encryptedString;
        vc1.str_GroupID=str_groupID;
        vc1.str_membersIDs=str_Teammembers;
        [self.navigationController pushViewController:vc1 animated:YES];
    }
    else
    {
//        [self.navigationController popViewControllerAnimated:YES];
//        
//        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
//        [userInfo setObject:encryptedString forKey:@"VideoStringcameraOne"];
//        
//        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//        [nc postNotificationName:@"FirstVCPopped" object:self userInfo:userInfo];
//        
//        NSMutableDictionary* userInfo1 = [NSMutableDictionary dictionary];
//        [userInfo1 setValue:thumbnailImage forKey:@"Imagethumbnail"];
//        
//        NSNotificationCenter* nc1 = [NSNotificationCenter defaultCenter];
//        [nc1 postNotificationName:@"ImageVCPopped" object:self userInfo:userInfo1];
        
  //      NSLog(@"thimnailImagePush %@ str_videoString %@",thumbnailImage,encryptedString);

        Selectchallenge1ViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Selectchallenge1"];
        vc1.imagethumbnailSelect=thumbnailImage;
        vc1.str_encripedString=encryptedString;
        [self.navigationController pushViewController:vc1 animated:YES];

    }
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
    TimeCount=10;
    
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
     //   NSLog(@"Couldn't create input!");
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
     //   NSLog(@"Couldn't create input!");
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
    
    
    TimeCount=10;
    lbl_coundown.text=@"10";
    
    if ([camera_btn isSelected])
    {
        btn_done.hidden=NO;
        lbl_coundown.hidden=YES;
        [mytimer invalidate];
        btn_swap.userInteractionEnabled=YES;
        [camera_btn setImage:[UIImage imageNamed:@"cemra"] forState:UIControlStateNormal];
        camera_btn.selected=NO;
        btn_back.hidden=NO;
        btn_DoneVideo.hidden=YES;
        [self stopRecording];
        [self stopBlink];
        recording = false;
        [delegate cancelClicked];
        
        Videoexist=YES;
    }
    else
    {
        //        [self performSelector:@selector(StopVideo)
        //                   withObject:nil
        //                   afterDelay:10.0];
        //        TimerForCoundown = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
        
        [camera_btn setImage:[UIImage imageNamed:@"play-active"] forState:UIControlStateNormal];
        btn_DoneVideo.hidden=YES;

        camera_btn.selected=YES;
        
        mytimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(StopVideo) userInfo:nil repeats:YES];
        
        btn_back.hidden=YES;
        btn_swap.userInteractionEnabled=NO;
        btn_done.hidden=YES;
        lbl_coundown.hidden=NO;
        [self startRecording];
        [session startRunning];
        [delegate startRecording];
        [self startBlink];
        
    }
    
    //    camera_btn.selected=YES;
    //    }
    //    recording = !recording;
    
}

//- (IBAction)TappedONDone:(id)sender
//{
//    btn_done.hidden=NO;
//    [mytimer invalidate];
//    [self stopRecording];
//    [session stopRunning];
//    [delegate stopRecording];
//    camera_btn.selected=NO;
//    recording = false;
//}

- (IBAction)btn_DoneVideo:(id)sender
{
    [mytimer invalidate];
    [TimerForCoundown invalidate];
    [self stopRecording];
    [session stopRunning];
    [delegate stopRecording];
    camera_btn.selected=NO;
    recording = false;
    
    btn_back.userInteractionEnabled=NO;
    btn_done.userInteractionEnabled=NO;
    btn_DoneVideo.userInteractionEnabled=NO;
    btn_record.userInteractionEnabled=NO;
    btn_swap.userInteractionEnabled=NO;
    camera_btn.userInteractionEnabled=NO;
}

-(void)StopVideo
{
    if (TimeCount<5)
    {
        btn_DoneVideo.hidden=NO;
    }
    
    if (![lbl_coundown.text isEqualToString:@"1"])
    {
        lbl_coundown.text=[NSString stringWithFormat:@"%d",TimeCount];
        TimeCount=TimeCount-1;
    }
    else
    {
        [mytimer invalidate];
        [TimerForCoundown invalidate];
        [self stopRecording];
        [session stopRunning];
        [delegate stopRecording];
        camera_btn.selected=NO;
        recording = false;
        btn_back.hidden=NO;
        
        btn_back.userInteractionEnabled=NO;
        btn_done.userInteractionEnabled=NO;
        btn_DoneVideo.userInteractionEnabled=NO;
        btn_record.userInteractionEnabled=NO;
        btn_swap.userInteractionEnabled=NO;
        camera_btn.userInteractionEnabled=NO;

        
        if ([lbl_coundown.text isEqualToString:@"1"])
        {
            lbl_coundown.text=[NSString stringWithFormat:@"%d",TimeCount];
            TimeCount=TimeCount-1;
        }
        
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
    [mytimer invalidate];
    TimeCount=10;
    camera_btn.selected=NO;
    lbl_coundown.text=@"10";
    [TimerForCoundown invalidate];
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
- (IBAction)BackAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


/////////////////// ViewDidLoad Code //////////////////

//    [self.view bringSubviewToFront:preCaptureToolbar];
//    [self.view bringSubviewToFront:postCaptureToolbar];
//    [postCaptureToolbar setHidden:YES];
//    postCaptureToolbar.frame = CGRectMake(0, 480-53, 320, 53);
//    preCaptureToolbar.frame = CGRectMake(0, 480-53, 320, 53);
//    [self initFlipButton];




//    self.captureSession = [[AVCaptureSession alloc] init];
//    AVCaptureDevice *device =
//    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//
//    AVCaptureDevice *audioDevice =
//    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
//
//    NSError *error = nil;
//    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
//    self.audioInput =
//    [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:nil];
//    if (self.videoInput)
//    {
//        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
//        NSDictionary *stillImageOutputSettings = [[NSDictionary alloc]
//                                                  initWithObjectsAndKeys:AVVideoCodecJPEG,
//                                                  AVVideoCodecKey, nil];
//        [self.stillImageOutput setOutputSettings:stillImageOutputSettings];
//        [self.captureSession addInput:self.videoInput];
//        [self.captureSession addOutput:self.stillImageOutput];
//    }
//    else {
//    //    NSLog(@"Video Input Error: %@", error);
//    }
//    if (!self.videoInput)
//    {
//        NSLog(@"Audio Input Error: %@", error);
//    }
//
//
//    [self.captureSession setSessionPreset:AVCaptureSessionPresetMedium];
//
//    AVCaptureVideoPreviewLayer *previewLayer =
//    [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
//
//    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    if (IS_IPHONE_6)
//    {
//        previewLayer.frame = CGRectMake(0, 0, 375, 667);
////        blackOverlay = [[UIView alloc] initWithFrame: CGRectMake(0, 2,
////                                                                 375,
////                                                                 80)];
////        scroll_view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60,
////                                                                     375,
//
//    }
//    else if (IS_IPHONE_6_PLUS)
//    {
//        previewLayer.frame = CGRectMake(0, 0, 414, 736);
//
//    }
//    else
//    {
//        previewLayer.frame = CGRectMake(0, 0, 320, 310);
//
//
//    }
//
//    [self.viewForCamera.layer addSublayer:previewLayer];
//    [self.captureSession startRunning];


/////////////////// Simple Camera ////////////////**********

// -(void)camera_func
//{
//    AVCaptureConnection *stillImageConnection =
//    [self.stillImageOutput.connections objectAtIndex:0];
//    [self.stillImageOutput
//     captureStillImageAsynchronouslyFromConnection:stillImageConnection
//     completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
//     {
//         if (imageDataSampleBuffer != NULL)
//         {
//             NSData *imageData = [AVCaptureStillImageOutput
//                                  jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//             UIImage *image = [[UIImage alloc] initWithData:imageData];
//
//
//
//             int kMaxResolution = 640; // Or whatever
//             CGImageRef imgRef = image.CGImage;
//
//             CGFloat widthR = CGImageGetWidth(imgRef);
//             CGFloat heightR = CGImageGetHeight(imgRef);
//             NSLog(@"width %f",widthR);
//             NSLog(@"height %f",heightR);
//
//
//             CGAffineTransform transform = CGAffineTransformIdentity;
//             CGRect bounds = CGRectMake(0, 0, widthR, heightR);
//
//
//             if (widthR > kMaxResolution || heightR > kMaxResolution) {
//                 CGFloat ratio = widthR/heightR;
//                 if (ratio > 1) {
//                     bounds.size.width = kMaxResolution;
//                     bounds.size.height = roundf(bounds.size.width / ratio);
//                 }
//
//                 else {
//                     bounds.size.height = kMaxResolution;
//                     bounds.size.width = roundf(bounds.size.height * ratio);
//                 }
//             }
//
//             CGFloat scaleRatio = bounds.size.width / widthR;
//             NSLog(@"scale ratio %f",scaleRatio);
//
//             CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
//
//             CGFloat boundHeight;
//             UIImageOrientation orient = image.imageOrientation;
//             NSLog(@" Orientation %ld",(long)orient);
//
//             switch(orient) {
//
//                 case UIImageOrientationUp: //EXIF = 1
//
//                     transform = CGAffineTransformIdentity;
//
//                     break;
//
//
//
//                 case UIImageOrientationUpMirrored: //EXIF = 2
//
//                     transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
//
//                     transform = CGAffineTransformScale(transform, -1.0, 1.0);
//
//                     break;
//
//
//
//                 case UIImageOrientationDown: //EXIF = 3
//
//                     transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
//
//                     transform = CGAffineTransformRotate(transform, M_PI);
//
//                     break;
//
//
//
//                 case UIImageOrientationDownMirrored: //EXIF = 4
//
//                     transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
//
//                     transform = CGAffineTransformScale(transform, 1.0, -1.0);
//
//                     break;
//
//
//
//                 case UIImageOrientationLeftMirrored: //EXIF = 5
//
//                     boundHeight = bounds.size.height;
//
//                     bounds.size.height = bounds.size.width;
//
//                     bounds.size.width = boundHeight;
//
//                     transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
//
//                     transform = CGAffineTransformScale(transform, -1.0, 1.0);
//
//                     transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
//
//                     break;
//
//
//
//                 case UIImageOrientationLeft: //EXIF = 6
//
//                     boundHeight = bounds.size.height;
//
//                     bounds.size.height = bounds.size.width;
//
//                     bounds.size.width = boundHeight;
//
//                     transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
//
//                     transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
//
//                     break;
//
//
//
//                 case UIImageOrientationRightMirrored: //EXIF = 7
//
//                     boundHeight = bounds.size.height;
//
//                     bounds.size.height = bounds.size.width;
//
//                     bounds.size.width = boundHeight;
//
//                     transform = CGAffineTransformMakeScale(-1.0, 1.0);
//
//                     transform = CGAffineTransformRotate(transform, M_PI / 2.0);
//
//                     break;
//
//
//
//                 case UIImageOrientationRight: //EXIF = 8
//
//                     boundHeight = bounds.size.height;
//
//                     bounds.size.height = bounds.size.width;
//
//                     bounds.size.width = boundHeight;
//
//                     transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
//
//                     transform = CGAffineTransformRotate(transform, M_PI / 2.0);
//
//                     break;
//
//
//                 default:
//
//                     [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
//
//             }
//                UIGraphicsBeginImageContext(bounds.size);
//
//
//
//             CGContextRef context = UIGraphicsGetCurrentContext();
//
//
//
//             if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
//
//                 CGContextScaleCTM(context, -scaleRatio, scaleRatio);
//
//                 CGContextTranslateCTM(context, -heightR, 0);
//
//             }
//
//             else {
//
//                 CGContextScaleCTM(context, scaleRatio, -scaleRatio);
//
//                 CGContextTranslateCTM(context, 0, -heightR);
//
//             }
//
//             CGContextConcatCTM(context, transform);
//
//
//
//             CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, widthR, heightR), imgRef);
//
//             UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
//
//             UIGraphicsEndImageContext();
//
//                    }
//         else
//         {
//             NSLog(@"Error capturing still image: %@", error);
//         }
//     } ];
//
//}


//-(void) initFlipButton{
//    if(![UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront]){
//        [flipButton setHidden:YES];
//    }else{
//        [flipButton setHidden:NO];
//    }
//}


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


//-(void)countdown
//{
//    if (![lbl_coundown.text isEqualToString:@"0"])
//    {
//        lbl_coundown.text=[NSString stringWithFormat:@"%d",TimeCount];
//        TimeCount=TimeCount-1;
//    }
//    else
//    {
//        [TimerForCoundown invalidate];
//        TimeCount=10;
//        lbl_coundown.text=@"10";
//    }
//
//}



@end
