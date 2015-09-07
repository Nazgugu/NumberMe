//
//  AppDelegate.m
//  NumberMe
//
//  Created by Liu Zhe on 15/8/2.
//  Copyright (c) 2015年 Liu Zhe. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "EGOCache.h"
#import "OpenShareHeader.h"
#import "guessGame.h"
#import "UAAppReviewManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
#endif
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    WelcomeViewController *welcome = [[WelcomeViewController alloc] init];
    self.window.rootViewController = welcome;
    [self.window makeKeyAndVisible];
    [self setUpReviewManager];
    [self setUpEGOCache];
    [self registerPlatforms];
    
    return YES;
}

- (void)setUpReviewManager
{
    [UAAppReviewManager setAppID:@"1030279451"];
    [UAAppReviewManager setAppName:@"NumberMe"];
    [UAAppReviewManager setDaysUntilPrompt:3];
    [UAAppReviewManager setUsesUntilPrompt:8];
    [UAAppReviewManager showPromptIfNecessary];
}

- (void)registerPlatforms
{
    [OpenShare connectWeiboWithAppKey:@"3997311644"];
    [OpenShare connectWeixinWithAppId:@"wxecd46c32832549fa"];
}

- (void)setUpEGOCache
{
    [EGOCache globalCache].defaultTimeoutInterval = INT_MAX;
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:TIPMETHOD])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:TIPMETHOD];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //[[EGOCache globalCache] clearCache];
    
    if (![[EGOCache globalCache] hasCacheForKey:@"games"])
    {
        if (![[EGOCache globalCache] hasCacheForKey:@"normalGames"])
        {
            NSData *normalGameData = [NSKeyedArchiver archivedDataWithRootObject:[NSMutableArray new]];
            [[EGOCache globalCache] setData:normalGameData forKey:@"normalGames"];
        }
    }
    else
    {
        NSData *normalGameData = [[EGOCache globalCache] dataForKey:@"games"];
        NSMutableArray *games = [NSKeyedUnarchiver unarchiveObjectWithData:normalGameData];
        for (guessGame *theGame in games)
        {
            theGame.gameMode = gameModeNormal;
        }
        normalGameData = [NSKeyedArchiver archivedDataWithRootObject:games];
        [[EGOCache globalCache] setData:normalGameData forKey:@"normalGames"];
        [[EGOCache globalCache] removeCacheForKey:@"games"];
        if ([[EGOCache globalCache] hasCacheForKey:@"maxScore"])
        {
            NSString *maxNormal = [[EGOCache globalCache] stringForKey:@"maxScore"];
            [[EGOCache globalCache] setString:maxNormal forKey:@"maxNormalScore"];
            [[EGOCache globalCache] removeCacheForKey:@"maxScore"];
        }
    }
    
    if (![[EGOCache globalCache] hasCacheForKey:@"infinityGames"])
    {
        NSData *infinity = [NSKeyedArchiver archivedDataWithRootObject:[NSMutableArray new]];
        [[EGOCache globalCache] setData:infinity forKey:@"infinityGames"];
    }
    if (![[EGOCache globalCache] hasCacheForKey:@"levelGames"])
    {
        NSData *levelGames = [NSKeyedArchiver archivedDataWithRootObject:[NSMutableArray new]];
        [[EGOCache globalCache] setData:levelGames forKey:@"levelGames"];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if (IOS8_UP)
    {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone)
        {
            if ([[UIApplication sharedApplication] scheduledLocalNotifications].count == 0)
            {
                [self scheduleLocalNotification];
            }
        }
    }
    else
    {
        if ([[UIApplication sharedApplication] scheduledLocalNotifications].count == 0)
        {
            [self scheduleLocalNotification];
        }
    }
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
    if (IOS8_UP)
    {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone)
        {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            [self scheduleLocalNotification];
        }
    }
    else
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [self scheduleLocalNotification];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([OpenShare handleOpenURL:url])
    {
        return YES;
    }
    
    return YES;
}

- (void)scheduleLocalNotification
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:86400];
    if ([localNotification respondsToSelector:@selector(setAlertTitle:)])
    {
        localNotification.alertTitle = @"How are you doing?";
    }
    localNotification.alertBody = @"Hi there, long time no see. Why not give yourself a break and guess some numbers";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
