//
//  MEAppDelegate.m
//  Mess
//
//  Created by Jon on 8/21/14.
//  Copyright (c) 2014 Modeo. All rights reserved.
//

#import <ModeoFramework/ModeoFramework.h>
#import <Parse/Parse.h>

#import "MEAppDelegate.h"
#import "MEDataLogger.h"
#import "MERemoteLogger.h"

@interface MEAppDelegate ()

@property (strong, nonatomic) MEDataLogger *dataLogger;

@end

@implementation MEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"HSzaGkx6B3kF7Ow3J7utNijE7MrxGIeClkA0Drs8"
                  clientKey:@"5b1MR4op6iP40MFl1ZjKTp4mhV1wDwPI3YaRjgCv"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [MFBike sharedInstance];
    
    self.dataLogger = [MEDataLogger new];
    [self.dataLogger start];
    
    //UIApplicationLaunchOptionsBluetoothCentralsKey, UIApplicationLaunchOptionsBluetoothPeripheralsKey
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsBluetoothCentralsKey]) {
        NSArray *centralManagerIdentifiers = [launchOptions objectForKey:UIApplicationLaunchOptionsBluetoothCentralsKey];
        [[MERemoteLogger sharedInstance] log:[NSString stringWithFormat:@"Launched with centrals key. %lu centrals.", (unsigned long)centralManagerIdentifiers.count]];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
