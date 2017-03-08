//
//  WQAppDelegate.m
//  WQFramework
//
//  Created by jayla25349 on 03/08/2017.
//  Copyright (c) 2017 jayla25349. All rights reserved.
//

#import "WQAppDelegate.h"

@implementation WQAppDelegate
    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
