//
//  AppDelegate.m
//  Krust
//
//  Created by Pankaj Sharma on 24/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "notificationVC.h"

@interface AppDelegate ()

{
    NSMutableArray *tabbar_array;
    UINavigationController *navigation_app_delegate;
}

@end

@implementation AppDelegate
@synthesize navController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
//#ifdef __IPHONE_8_0
//    //Right, that is the point
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
//                                                                                         |UIRemoteNotificationTypeSound
//                                                                                         |UIRemoteNotificationTypeAlert) categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//#else
//    //register to receive notifications
//    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//#endif
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    notificationAlert.delegate =self;
    

    tabbar_array=[[NSMutableArray alloc]init];
    tabbar_controller=[[UITabBarController alloc]init];
    [self tabbar];
    
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==YES)
    {
    AppDelegate *app_in_login =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    app_in_login.window.rootViewController=tabbar_controller;
        
    }
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    
        // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
//    if (BadeValue==0)
//    {
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"NotificationApear"]== NO)
    {
     
    }
    else
    {
        [[tabbar_controller.tabBar.items objectAtIndex:3] setBadgeValue:@""];
    }

//    }
//    else
//    {
//    
//    [[tabbar_controller.tabBar.items objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%ld",(long)BadeValue]];
//    }

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    //    [notificationAlert dismissWithClickedButtonIndex:0 animated:YES];
    //
    //    notificationAlert = [[UIAlertView alloc]
    //                         initWithTitle:@"Alert!" message:@"You are near to Remembered location." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [notificationAlert show];
    
    BadeValue= [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] integerValue];
    
    [[tabbar_controller.tabBar.items objectAtIndex:3] setBadgeValue:@""];
  //  NSLog(@"%@",userInfo);
    
    if(application.applicationState == UIApplicationStateInactive) {
        
  //      NSLog(@"Inactive");

        [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:userInfo];

        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NotificationApear"];
        
        //Show the view with the content of the push
        
        completionHandler(UIBackgroundFetchResultNewData);
        
    }
    else if (application.applicationState == UIApplicationStateBackground)
    {
        
  //      NSLog(@"Background");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:userInfo];

        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NotificationApear"];

        //Refresh the local model
        
        completionHandler(UIBackgroundFetchResultNewData);
        
    }
    else
    {
        
  //      NSLog(@"Active");
        
        UITabBarController * actualVC = [[(UINavigationController *)self.window.rootViewController viewControllers] lastObject];
        id visibleController = [actualVC.viewControllers lastObject];
        
        
        if ([visibleController isKindOfClass:[notificationVC class]])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistrationReceived" object:userInfo];
        }
        else
        {
        
        [TSMessage showNotificationInViewController:actualVC
                                              title:NSLocalizedString([[userInfo objectForKey:@"data"] objectForKey:@"name"], nil)
                                           subtitle:NSLocalizedString([[userInfo objectForKey:@"aps"] objectForKey:@"alert"], nil)
                                              image:nil
                                               type:TSMessageNotificationTypeMessage
                                           duration:4.0f
                                           callback:^{}
                                        buttonTitle:@"Check"
                                     buttonCallback:^
         {
             // here perform action on tap of Chat now button
            
             

             [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:userInfo];
             
             [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NotificationApear"];

//             storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//             
//             notificationVC *ShowMessage = [storyboard instantiateViewControllerWithIdentifier:@"notification"];
//             [self.navController pushViewController:ShowMessage animated:YES];
             
         }
            atPosition:TSMessageNotificationPositionTop
                               canBeDismissedByUser:YES];
        
        //Show an in-app banner
        
        completionHandler(UIBackgroundFetchResultNewData);
        
    }

    }
    
//    UIApplicationState state = [application applicationState];
//    
//    if (state == UIApplicationStateActive)
//    {
    
//        UITabBarController* actualVC = [[(UINavigationController *)self.window.rootViewController viewControllers] lastObject];
        
      // NSLog(@"%@",[actualVC.viewControllers lastObject]);
        
      // id visibleController = [actualVC.viewControllers lastObject];
//        notificationVC * actualVC = [[(UINavigationController *)self.window.rootViewController viewControllers] lastObject];

//        }
    
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([token isEqualToString:@""] || [token isEqualToString:@"(null)"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"123456" forKey:@"DeviceToken"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"DeviceToken"];
    }
    NSLog(@"DeviceToken --- >>>> %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DeviceToken"]);
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}

-(void)tabbar
{
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ViewControllerObj = [storyboard instantiateViewControllerWithIdentifier:@"home"];
    FirstViewControllerObj=[storyboard instantiateViewControllerWithIdentifier:@"LeaderBoard"];
    SecondViewControllerObj=[storyboard instantiateViewControllerWithIdentifier:@"Selectchallenge1"];
    ThirdViewControllerObj=[storyboard instantiateViewControllerWithIdentifier:@"notification"];
    ForthViewControllerObj=[storyboard instantiateViewControllerWithIdentifier:@"Changle"];
    
    
    UINavigationController *Viewcontroller_navigation=[[UINavigationController alloc]initWithRootViewController:ViewControllerObj];
    [Viewcontroller_navigation.tabBarItem setImage: [ Viewcontroller_navigation.tabBarItem.image=[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    Viewcontroller_navigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"home-active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Viewcontroller_navigation.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [tabbar_array addObject:Viewcontroller_navigation];
    
    
    UINavigationController *FirstViewcontroller_navigation=[[UINavigationController alloc]initWithRootViewController:FirstViewControllerObj];
    [FirstViewcontroller_navigation.tabBarItem setImage: [ FirstViewcontroller_navigation.tabBarItem.image=[UIImage imageNamed:@"leadership"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    FirstViewcontroller_navigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"leadership-active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    FirstViewcontroller_navigation.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [tabbar_array addObject:FirstViewcontroller_navigation];
    
    
    UINavigationController *SecondViewcontroller_navigation=[[UINavigationController alloc]initWithRootViewController:SecondViewControllerObj];
    [SecondViewcontroller_navigation.tabBarItem setImage: [ SecondViewcontroller_navigation.tabBarItem.image=[UIImage imageNamed:@"camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    SecondViewcontroller_navigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"camera"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    SecondViewcontroller_navigation.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [tabbar_array addObject:SecondViewcontroller_navigation];
    
    
    UINavigationController *ThirdViewcontroller_navigation=[[UINavigationController alloc]initWithRootViewController:ThirdViewControllerObj];
    [ThirdViewcontroller_navigation.tabBarItem setImage: [ ThirdViewcontroller_navigation.tabBarItem.image=[UIImage imageNamed:@"notification"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    ThirdViewcontroller_navigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"notification-active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ThirdViewcontroller_navigation.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [tabbar_array addObject:ThirdViewcontroller_navigation];
    
    
    UINavigationController *ForthViewcontroller_navigation=[[UINavigationController alloc]initWithRootViewController:ForthViewControllerObj];
    [ForthViewcontroller_navigation.tabBarItem setImage: [ ForthViewcontroller_navigation.tabBarItem.image=[UIImage imageNamed:@"Challenge"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    ForthViewcontroller_navigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"Challenge-active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ForthViewcontroller_navigation.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [tabbar_array addObject:ForthViewcontroller_navigation];
    
    Viewcontroller_navigation.navigationBarHidden=YES;
    FirstViewcontroller_navigation.navigationBarHidden=YES;
    SecondViewcontroller_navigation.navigationBarHidden=YES;
    ThirdViewcontroller_navigation.navigationBarHidden=YES;
    ForthViewcontroller_navigation.navigationBarHidden=YES;
    
    tabbar_controller.delegate=self;
    [tabbar_controller setViewControllers:tabbar_array animated:YES];
    
    ////***LoginPass**/////
    
    //    AppDelegate *app_in_login =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    //    app_in_login.window.rootViewController=tabbar_controller;
    
    /////****/////
    
}


@end
