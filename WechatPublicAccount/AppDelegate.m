//
//  AppDelegate.m
//  WechatPublicAccount
//
//  Created by mayan on 2019/11/26.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[CoreDataManager shareInstance] setupCoreDataStack];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[CoreDataManager shareInstance] cleanUp];
}


@end
