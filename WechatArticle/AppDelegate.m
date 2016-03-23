//
//  AppDelegate.m
//  WechatArticle
//
//  Created by 找房 on 15/12/18.
//  Copyright © 2015年 zhaofang. All rights reserved.
//

#import "AppDelegate.h"

#import "LanchImageView.h"

#import "WXApi.h"
#import "LDrawerViewController.h"

#import "ViewController.h"

#import "LeftViewController.h"

#import "HKUITool.h"

#import "UIImage+UIColor.h"

#import "CenterNaviController.h"

#import "SDImageCache.h"

#include <AudioToolbox/AudioToolbox.h>


#import <JMessage/JMessage.h>


#import "AFDropdownNotification.h"


@interface AppDelegate ()<WXApiDelegate,JMessageDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [WXApi registerApp:@"wx43f2ca0e0922b27f"];
    
    [UINavigationBar appearance].barTintColor=[UIColor orangeColor];
   
    
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];//注册
    
    
    UIViewController * lvc = [[LeftViewController alloc]init];
    
    [lvc.view setBackgroundColor:[UIColor whiteColor]];
     UINavigationController * leftNavi = [[UINavigationController alloc]initWithRootViewController:lvc];
    

    
    [leftNavi.navigationBar setHidden:YES];
    
    ViewController * center = [HKUITool homePageViewController];
    
    
    
    CenterNaviController * centerNavi = [[CenterNaviController alloc]initWithRootViewController:center];
    
    
    [centerNavi.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor orangeColor]] forBarMetrics:UIBarMetricsDefault];
    
    [centerNavi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [centerNavi.navigationBar setBarTintColor:[UIColor orangeColor]];
    
    [leftNavi.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor orangeColor]] forBarMetrics:UIBarMetricsDefault];
    
    [leftNavi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [centerNavi.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    
    [centerNavi.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    
    LDrawerViewController * ld = [[LDrawerViewController alloc]initWithCenterController: centerNavi  leftController:leftNavi];
    
    
    
    self.window.rootViewController = ld;
    [HKUITool setAppRootController:ld];
    
    
    
    
    [JMessage addDelegate:self withConversation:nil];
    
    [JMessage setupJMessage:launchOptions appKey:@"f4a4dfea3711edea5bde5111" channel:@"Haoke" apsForProduction:YES category:nil];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        /// 可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        /// categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    
    
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required - 处理收到的通知
    [JPUSHService handleRemoteNotification:userInfo];
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        
        if([userInfo[@"_j_type"] isEqualToString:@"jmessage"]){
            
            return;
        }
        
        //  [HKAPITools SetBadgeNumberOfMyCenter];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber -= 1;
        [JPUSHService setBadge:0];
        [AFDropdownNotification sharedNotiView].titleText = @"找房网";
        [AFDropdownNotification sharedNotiView].subtitleText = userInfo[@"aps"][@"alert"];
        [AFDropdownNotification sharedNotiView].image = [UIImage imageNamed:@"about_img"];
        [AFDropdownNotification sharedNotiView].autoHide = YES;
        [AFDropdownNotification sharedNotiView].dismissOnTap = YES;
        [[AFDropdownNotification sharedNotiView] presentInView:[UIApplication  sharedApplication].keyWindow.rootViewController.view withGravityAnimation:YES];
    }
    else{
        
        if([userInfo[@"_j_type"] isEqualToString:@"jmessage"]){
            
            
            
            
        }else{
            
            
            
            
        }
        
        
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        
        if([userInfo[@"_j_type"] isEqualToString:@"jmessage"]){
            
            return;
        }
        
        //  [HKAPITools SetBadgeNumberOfMyCenter];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber -= 1;
        [JPUSHService setBadge:0];
        [AFDropdownNotification sharedNotiView].titleText = @"找房网";
        [AFDropdownNotification sharedNotiView].subtitleText = userInfo[@"aps"][@"alert"];
        [AFDropdownNotification sharedNotiView].image = [UIImage imageNamed:@"icon"];
        [AFDropdownNotification sharedNotiView].autoHide = YES;
        [AFDropdownNotification sharedNotiView].dismissOnTap = YES;
        
        [AFDropdownNotification sharedNotiView].topButtonText = @"查看";
        
        [[AFDropdownNotification sharedNotiView] presentInView:[UIApplication  sharedApplication].keyWindow.rootViewController.view withGravityAnimation:YES];
    }
    else{
        
        if([userInfo[@"_j_type"] isEqualToString:@"jmessage"]){
            
            
            
            
        }else{
            
            
            
            
        }
        
        
    }
    
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.hk.WechatArticle" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WechatArticle" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WechatArticle.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}
-(void) application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings{

   // [AppDelegate registeSound];

}
#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
