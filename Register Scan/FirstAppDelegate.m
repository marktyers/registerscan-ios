//
//  FirstAppDelegate.m
//  Register Scan
//
//  Created by Mark Tyers on 26/09/2013.
//  Copyright (c) 2013 Mark Tyers. All rights reserved.
//

#import "FirstAppDelegate.h"

@implementation FirstAppDelegate

@synthesize userToken=_userToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.userToken = [prefs objectForKey:@"userTokenKey"];
    if (self.userToken == NULL) {
        NSLog(@"usertoken is null");
        [prefs setObject:@"NO" forKey:@"userTokenKey"];
    }
    NSLog(@"app del usertoken: %@", self.userToken);
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.userToken forKey:@"userTokenKey"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.userToken forKey:@"userTokenKey"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.userToken forKey:@"userTokenKey"];
}

@end
