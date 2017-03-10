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
    [[WQRouter defaultRouter] registerMiddleware:[WQRouteURLVerifyMiddleware middlewareWithScheme:@"test" host:nil]];
    [[WQRouter defaultRouter] registerMiddleware:[WQRouteURLParserMiddleware new]];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
