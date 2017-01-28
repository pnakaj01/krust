//
//  AppDelegate.h
//  Krust
//
//  Created by Pankaj Sharma on 24/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"HomeVC.h"
#import"LeaderBoardVC.h"
#import"cameraVC.h"
#import"notificationVC.h"
#import"ChangleVC.h"
#import "Selectchallenge1ViewController.h"
#import "TSMessageView.h"

// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.

UIStoryboard *storyboard;
HomeVC *ViewControllerObj;
LeaderBoardVC *FirstViewControllerObj;
//cameraVC *SecondViewControllerObj;
Selectchallenge1ViewController *SecondViewControllerObj;
notificationVC *ThirdViewControllerObj;
ChangleVC *ForthViewControllerObj;

UITabBarController *tabbar_controller;
NSInteger BadeValue;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,UIAlertViewDelegate,AVCaptureFileOutputRecordingDelegate,UINavigationControllerDelegate>
{
    
    UIAlertView *notificationAlert;

}


@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)UINavigationController *navController;

-(void)tabbar;


@end

