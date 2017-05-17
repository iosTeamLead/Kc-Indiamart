//
//  AppDelegate.m
//  Grocery App
//
//  Created by eweba1-pc-55 on 9/13/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "AppDelegate.h"
#import "Server.h"
#import "MBProgressHUD.h"
#import "groceryProductData.h"
#import "LoginViewController.h"
#import "NotificationViewViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    sleep(1);
    [self registerForRemoteNotifications];

    application.applicationIconBadgeNumber = 0;
//    
//    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
//                                                    UIUserNotificationTypeBadge |
//                                                    UIUserNotificationTypeSound);
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
//                                                                             categories:nil];
//    [application registerUserNotificationSettings:settings];
//    [application registerForRemoteNotifications];
    [self homeRootTabControler];

//    NSString *str_userId =[NSString stringWithFormat:@"%@",kGetValueForKey(KMGUserId)];
//    if(![str_userId isEqualToString:@"(null)"])
//    {
//        [self homeRootTabControler];
//    }

    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [FBSDKLoginButton class];
    [self Login_Google];

    
    return YES;
}
- (void)registerForRemoteNotifications {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else {
        // Code for old versions
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        
        
        
    }
}






- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    
    if ([kGetValueForKey(@"key")isEqualToString:@"2"]) {
        
        
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    
    if ([kGetValueForKey(@"key")isEqualToString:@"1"]) {
        
        
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
    }
    
    
    return 0;
    
}

-(void)Login_Google {
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    //[GIDSignIn sharedInstance].delegate = self;
    
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

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) homeRootTabControler {
 self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
  
    
 [self.window makeKeyAndVisible];
}
//-(void) signInRootControler {
// UIStoryboard *signInNav = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//  
//    LoginViewController *next=[signInNav instantiateViewControllerWithIdentifier:@"LoginViewController"]
// self.window.rootViewController = signInNav;
// [self.window makeKeyAndVisible];
// 
//}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"localListData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"localListData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSLog( @"Handle push from foreground" );
    // custom code to handle push while app is in the foreground
    NSLog(@"User Info : %@",notification.request.content.userInfo);
 
    
    
}
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
  
//
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[[[response.notification.request.content.userInfo valueForKey:@"aps"] valueForKey:@"0"] valueForKey:@"message_images"] forKey:@"image"];
    [dict setObject:[[[response.notification.request.content.userInfo valueForKey:@"aps"] valueForKey:@"0"] valueForKey:@"title"] forKey:@"Message"];

    
    
    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
//    NSMutableArray *array = [NSMutableArray ]
    
    NotificationViewViewController *notificationDetail = [storyBoard instantiateViewControllerWithIdentifier:@"NotificationViewViewController"];
    
    
    
    notificationDetail.notificationDetailArray = [dict mutableCopy];
    notificationDetail.isFromNotification = YES;
    
    MMDrawer *drawer = (MMDrawer *)[self.window rootViewController];
    UINavigationController *vcCenter = (UINavigationController *)drawer.centerViewController;
    vcCenter.viewControllers = @[[storyBoard instantiateViewControllerWithIdentifier:@"NotificationsClass"],notificationDetail];

    
//    [drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
//        
//    }];
    
    
    
    completionHandler();
    
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        NSLog(@"didRegisterUser");
        [application registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    kSetValueForKey(@"token", devToken);
    NSLog(@"device %@",devToken);
    
}


- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo

{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[[[userInfo valueForKey:@"aps"] valueForKey:@"0"] valueForKey:@"message_images"] forKey:@"image"];
    [dict setObject:[[[userInfo valueForKey:@"aps"] valueForKey:@"0"] valueForKey:@"title"] forKey:@"Message"];
    
    
    
    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //    NSMutableArray *array = [NSMutableArray ]
    
    NotificationViewViewController *notificationDetail = [storyBoard instantiateViewControllerWithIdentifier:@"NotificationViewViewController"];
    
    
    
    notificationDetail.notificationDetailArray = [dict mutableCopy];
    notificationDetail.isFromNotification = YES;
    
    MMDrawer *drawer = (MMDrawer *)[self.window rootViewController];
    UINavigationController *vcCenter = (UINavigationController *)drawer.centerViewController;
    vcCenter.viewControllers = @[[storyBoard instantiateViewControllerWithIdentifier:@"NotificationsClass"],notificationDetail];
    

}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}


- (void)addMessageFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
    //  NSString *alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    //  NSMutableArray *parts = [NSMutableArray arrayWithArray:[alertValue componentsSeparatedByString:@": "]];
    // message.senderName = [parts objectAtIndex:0];
    // [parts removeObjectAtIndex:0];
    // message.text = [parts componentsJoinedByString:@": "];
    //int index = [dataModel addMessage:message];
    //if (updateUI)
    //  [chatViewController didSaveMessage:message atIndex:index];
}
@end
